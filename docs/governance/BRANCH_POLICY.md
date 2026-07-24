# Branch & CI Policy

This document defines the required branch protection and CI gating for `main`. It is referenced by `REPO_RULES.md` Rule 26 and Rule 30.

## Branch strategy
- `main` — protected, production-reflective. Never committed or pushed to directly.
- All work happens on branches named per Rule 27:
  - `feat/<short-slug>`
  - `fix/<short-slug>`
  - `docs/<short-slug>`
  - `chore/<short-slug>`
  - `refactor/<short-slug>`
  - `agent/<AgentName>-<short-slug>`
- Merge into `main` only via PR.

## Required status checks (all must pass)
1. `secret-scan`
2. `doc-freshness`
3. `build`
4. `test`
5. `deploy-dry`

These are implemented in `.github/workflows/gate.yml` and `scripts/verify.sh` / `scripts/verify.ps1`.

## GitHub branch protection settings (apply via Settings → Branches or `gh`)
- Require a pull request before merging to `main`.
- Require status checks: `gate` (the workflow job that runs all checks).
- Require branches to be up to date before merging.
- Dismiss stale approvals on new commits.
- Require review from Shayan or CODEOWNERS.
- Apply rules to administrators (no self-merge).
- Block force pushes and branch deletions.

## Approval flow
- Shayan's approval is recorded as a PR approval (or an explicit written instruction to the agent).
- A PR without Shayan's approval must not be merged.

## Incident response
- A red workflow on `main` is release-blocking. Revert first (Rule 36), diagnose second, fix via a new branch.
