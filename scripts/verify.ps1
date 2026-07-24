# Repo-adaptive governance verification (PowerShell / Windows).
# Mirrors scripts/verify.sh: secret-scan, doc-freshness, build, test, deploy-dry.
# Scoped to $RepoRoot only (does NOT walk outside the repo).
$ErrorActionPreference = 'Continue'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $RepoRoot

$failed = $false
function Notice($t,$m){ Write-Host "::notice title=$t::$m" }
function Err($t,$m){ Write-Host "::error title=$t::$m"; $script:failed = $true }

# ---------------------------------------------------------------- 1. secret-scan
Write-Host "== secret-scan =="
if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
  gitleaks detect --no-banner --redact
  if ($LASTEXITCODE -ne 0) { Err "secret-scan" "gitleaks found secrets" }
} else {
  # (a) filename-based: private key / credential files must not be committed.
  #     Exclude dependency / generated dirs (node_modules, .venv, _repo_clone,
  #     dist, build, .cache, coverage) — library files there are not first-party.
  $excludeDirs = '[\\/](node_modules|\.git|audits[\\/]private|\.venv|_repo_clone|dist|build|\.cache|coverage)[\\/]'
  $badFiles = Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.p8,*.p12,*credential*,*.pem,*.key `
    -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch $excludeDirs }
  if ($badFiles) { Err "secret-scan" "secret files present: $($badFiles.FullName -join ', ')" }
  # (b) content-based: first-party code/config only, require an assigned value.
  #     Exclude dependency / generated dirs + *.env.example / *.env.sample templates.
  $hits = Get-ChildItem -Path $RepoRoot -Recurse -File `
    -Include *.json,*.env,*.ts,*.js,*.py,*.yml,*.yaml,*.toml,*.sh `
    -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch $excludeDirs } |
    Where-Object { $_.Name -notmatch '\.env\.(example|sample)$' } |
    Where-Object { Select-String -Path $_.FullName -Pattern '(API_KEY|SECRET|PRIVATE_KEY|TOKEN|PASSWORD)\s*[=:]\s*["'']?[A-Za-z0-9/+_-]{8,}' -Quiet }
  if ($hits) { Err "secret-scan" "possible hardcoded secrets in: $($hits.FullName -join ', ')" }
}

# ---------------------------------------------------------------- 2. doc-freshness
Write-Host "== doc-freshness =="
if (-not (Test-Path (Join-Path $RepoRoot 'README.md'))) { Err "doc-freshness" "README.md missing" }
$newest = Get-ChildItem -Path (Join-Path $RepoRoot 'audits') -Recurse -Filter *.md -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '[\\/]audits[\\/]private[\\/]' } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $newest) { Err "doc-freshness" "no audit found under audits/" }
else {
  $age = ([datetime]::Now - $newest.LastWriteTime).Days
  if ($age -gt 30) { Err "doc-freshness" "newest audit is $age days old (>30)" }
}
$baselinePath = Join-Path $RepoRoot 'docs/_baseline.json'
if (-not (Test-Path $baselinePath)) {
  $cnt = (Get-ChildItem -Path (Join-Path $RepoRoot 'docs') -Recurse -Filter *.md -ErrorAction SilentlyContinue).Count
  "{ `"md_count`": $cnt }" | Out-File $baselinePath -Encoding utf8
  Notice "doc-freshness" "captured docs baseline md_count=$cnt"
}
$base = 0
if (Test-Path $baselinePath) {
  $m = (Get-Content $baselinePath) -match '"md_count":\s*(\d+)'
  if ($m) { $base = [int]($Matches[1]) }
}
$cur = (Get-ChildItem -Path (Join-Path $RepoRoot 'docs') -Recurse -Filter *.md -ErrorAction SilentlyContinue).Count
if ($cur -lt $base) { Err "doc-freshness" "docs md count $cur < baseline $base (deletion without approval)" }

# ---------------------------------------------------------------- 3. build / test (adaptive)
Write-Host "== build / test =="
$PM = $null
if (Test-Path (Join-Path $RepoRoot 'pnpm-lock.yaml')) { $PM = 'pnpm' }
elseif (Test-Path (Join-Path $RepoRoot 'yarn.lock')) { $PM = 'yarn' }
elseif (Test-Path (Join-Path $RepoRoot 'package-lock.json')) { $PM = 'npm' }

function RunTimed($secs, $label, $cmd) {
  $p = Start-Process -NoNewWindow -PassThru -Wait $cmd[0] $cmd[1..($cmd.Count-1)]
  if ($p.ExitCode -eq 124) { Err $label "timed out after ${secs}s (likely network/install hang)" }
  elseif ($p.ExitCode -ne 0) { Err $label "failed (rc=$($p.ExitCode))" }
  else { Notice $label "ok" }
}

if ($PM) {
  switch ($PM) {
    'pnpm' { RunTimed 300 build @('pnpm','install','--frozen-lockfile') }
    'yarn' { RunTimed 300 build @('yarn','install','--frozen-lockfile') }
    'npm'  { RunTimed 300 build @('npm','ci') }
  }
  if (-not $failed) {
    foreach ($m in @('npm','pnpm','yarn')) {
      if (Get-Command $m -ErrorAction SilentlyContinue) {
        $c = if ($m -eq 'npm') { 'npm run build --if-present' } elseif ($m -eq 'pnpm') { 'pnpm run build --if-present' } else { 'yarn build' }
        Invoke-Expression $c >$null 2>&1; if ($LASTEXITCODE -eq 0) { Notice build "build ok" } else { Err build "build failed" }
        $c = if ($m -eq 'npm') { 'npm test --if-present' } elseif ($m -eq 'pnpm') { 'pnpm test --if-present' } else { 'yarn test' }
        Invoke-Expression $c >$null 2>&1; if ($LASTEXITCODE -eq 0) { Notice test "test ok" } else { Err test "test failed" }
      }
    }
  }
} elseif ((Test-Path (Join-Path $RepoRoot 'pyproject.toml')) -or (Test-Path (Join-Path $RepoRoot 'requirements.txt'))) {
  if (Test-Path (Join-Path $RepoRoot 'requirements.txt')) { pip install -q -r (Join-Path $RepoRoot 'requirements.txt') }
  pytest -q; if ($LASTEXITCODE -ne 0) { Err "test" "pytest failed" }
} elseif (Test-Path (Join-Path $RepoRoot 'Cargo.toml')) {
  cargo build --release; if ($LASTEXITCODE -ne 0) { Err "build" "cargo build failed" }
  cargo test --release; if ($LASTEXITCODE -ne 0) { Err "test" "cargo test failed" }
} else {
  Notice "build" "no build system detected; docs/static repo — skipping build/test"
}

# ---------------------------------------------------------------- 4. deploy-dry
Write-Host "== deploy-dry =="
if (Test-Path (Join-Path $RepoRoot 'vercel.json')) {
  vercel build --dry-run; if ($LASTEXITCODE -ne 0) { Err "deploy" "vercel dry-run failed" }
} elseif ((Test-Path (Join-Path $RepoRoot 'railway.json')) -or (Test-Path (Join-Path $RepoRoot 'railway.toml'))) {
  Notice "deploy" "railway target present; run 'railway up --detach' manually"
} elseif (Test-Path (Join-Path $RepoRoot 'eas.json')) {
  npx eas build --platform all --local --no-wait --non-interactive; if ($LASTEXITCODE -ne 0) { Err "deploy" "eas dry build failed" }
} elseif (Test-Path (Join-Path $RepoRoot 'netlify.toml')) {
  Notice "deploy" "netlify target present; manual deploy"
} else {
  Notice "deploy" "no deploy target; smoke build already covered"
}

if ($failed) { Write-Host "VERIFY FAILED"; exit 1 }
Write-Host "VERIFY PASSED"
