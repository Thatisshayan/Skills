#!/usr/bin/env bash
# Repo-adaptive governance verification.
# Implements REPO_RULES.md checks: secret-scan, doc-freshness, build, test, deploy-dry.
# Emits GitHub Actions annotations (::error / ::notice) when run in CI.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

FAIL=0
notice() { echo "::notice title=$1::$2"; }
error()  { echo "::error title=$1::$2"; FAIL=1; }

# ---------------------------------------------------------------- 1. secret-scan
echo "== secret-scan =="
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --no-banner --redact || error "secret-scan" "gitleaks found secrets"
else
  # (a) filename-based: private key / credential files must not be committed.
  #     Exclude dependency / generated dirs (.venv, node_modules, dist, build,
  #     _repo_clone, .cache, coverage) — library files there are not first-party.
  bad_files=$(find . -type f \( -name '*.p8' -o -name '*.p12' -o -name '*credential*' \
    -o -name '*.pem' -o -name '*.key' \) \
    -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/audits/private/*' \
    -not -path '*/.venv/*' -not -path '*/_repo_clone/*' -not -path '*/dist/*' \
    -not -path '*/build/*' -not -path '*/.cache/*' -not -path '*/coverage/*' 2>/dev/null || true)
  if [ -n "$bad_files" ]; then error "secret-scan" "secret files present: $bad_files"; fi
  # (b) content-based: only scan first-party code/config, require an ASSIGNED VALUE.
  #     Exclude dependency / generated dirs so library files don't false-positive.
  hits=$(grep -rIlE "(API_KEY|SECRET|PRIVATE_KEY|TOKEN|PASSWORD)[[:space:]]*[=:][[:space:]]*[\"']?[A-Za-z0-9/+_-]{8,}" \
    --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=audits/private \
    --exclude-dir=.venv --exclude-dir=_repo_clone --exclude-dir=dist --exclude-dir=build \
    --exclude-dir=.cache --exclude-dir=coverage \
    --include='*.json' --include='*.env' --include='*.ts' --include='*.js' --include='*.py' \
    --include='*.yml' --include='*.yaml' --include='*.toml' --include='*.sh' . 2>/dev/null || true)
  if [ -n "$hits" ]; then error "secret-scan" "possible hardcoded secrets in: $hits"; fi
fi

# ---------------------------------------------------------------- 2. doc-freshness
echo "== doc-freshness =="
[ -f README.md ] || error "doc-freshness" "README.md missing"
# link integrity (best-effort if tool present)
if command -v markdown-link-check >/dev/null 2>&1; then
  find . -name '*.md' -not -path './node_modules/*' -not -path './.git/*' \
    -not -path './audits/private/*' -print0 2>/dev/null \
    | xargs -0 -r -n1 markdown-link-check || error "doc-freshness" "broken doc links"
fi
# audit age (≤ 30 days)
newest=$(find audits -name '*.md' -not -path '*/private/*' -printf '%T@ %p\n' 2>/dev/null \
  | sort -n | tail -1 | cut -d' ' -f1)
if [ -z "$newest" ]; then
  error "doc-freshness" "no audit found under audits/"
else
  now=$(date +%s)
  age=$(( (now - ${newest%.*}) / 86400 ))
  if [ "$age" -gt 30 ]; then error "doc-freshness" "newest audit is $age days old (>30)"; fi
fi
# doc baseline
if [ ! -f docs/_baseline.json ]; then
  cnt=$(find docs -name '*.md' 2>/dev/null | wc -l)
  printf '{"md_count": %s}\n' "$cnt" > docs/_baseline.json
  notice "doc-freshness" "captured docs baseline md_count=$cnt"
fi
base=$(grep -o '"md_count": *[0-9]*' docs/_baseline.json | grep -o '[0-9]*$')
cur=$(find docs -name '*.md' 2>/dev/null | wc -l)
if [ "${cur:-0}" -lt "${base:-0}" ]; then
  error "doc-freshness" "docs md count $cur < baseline $base (deletion without approval)"
fi

# ---------------------------------------------------------------- 3. build / test
echo "== build / test =="
# pick the package manager from lockfiles (respect pnpm/yarn, don't assume npm)
PM=""
if [ -f pnpm-lock.yaml ]; then PM=pnpm
elif [ -f yarn.lock ]; then PM=yarn
elif [ -f package-lock.json ]; then PM=npm
fi
run_with_timeout() { # $1=seconds $2=label $3..=cmd
  local t="$1"; shift; local label="$1"; shift
  local out; out=$(timeout "$t" "$@" 2>&1); local rc=$?
  if [ $rc -eq 124 ]; then error "$label" "timed out after ${t}s (likely network/install hang)"; return; fi
  if [ $rc -ne 0 ]; then error "$label" "failed (rc=$rc): $(printf '%s' "$out" | tail -3)"; return; fi
  notice "$label" "ok"
}
if [ -n "$PM" ]; then
  case "$PM" in
    pnpm) run_with_timeout 300 build pnpm install --frozen-lockfile
          pnpm run build --if-present 2>&1 | tail -3 ;;
    yarn) run_with_timeout 300 build yarn install --frozen-lockfile ;;
    npm)  run_with_timeout 300 build npm ci ;;
  esac
  if [ $FAIL -eq 0 ]; then
    (npm run build --if-present || pnpm run build --if-present || yarn build) >/dev/null 2>&1 && notice build "build ok" || error build "build failed"
    (npm test --if-present || pnpm test --if-present || yarn test) >/dev/null 2>&1 && notice test "test ok" || error test "test failed"
  fi
elif [ -f pyproject.toml ] || [ -f requirements.txt ]; then
  pip install -q -r requirements.txt 2>/dev/null || true
  pytest -q || error "test" "pytest failed"
elif [ -f Cargo.toml ]; then
  cargo build --release || error "build" "cargo build failed"
  cargo test --release || error "test" "cargo test failed"
else
  notice "build" "no build system detected; docs/static repo — skipping build/test"
fi

# ---------------------------------------------------------------- 4. deploy-dry
echo "== deploy-dry =="
if [ -f vercel.json ]; then
  vercel build --dry-run >/dev/null 2>&1 || error "deploy" "vercel dry-run failed"
elif [ -f railway.json ] || [ -f railway.toml ]; then
  notice "deploy" "railway target present; run 'railway up --detach' manually"
elif [ -f eas.json ]; then
  npx eas build --platform all --local --no-wait --non-interactive >/dev/null 2>&1 \
    || error "deploy" "eas dry build failed"
elif [ -f netlify.toml ]; then
  notice "deploy" "netlify target present; manual deploy"
else
  notice "deploy" "no deploy target; smoke build already covered"
fi

if [ "$FAIL" -ne 0 ]; then
  echo "VERIFY FAILED"
  exit 1
fi
echo "VERIFY PASSED"
