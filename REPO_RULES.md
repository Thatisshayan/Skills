# Repository Rules

Version: 1.0.0
Effective: 2026-07-23
Owner: Shayan
Applies to: Every human contributor and every agent (Hermes, Codex, etc.) working in this repository.
Purpose: Preserve project truth, prevent stale documentation, keep work recoverable, and guarantee that `main` is never red.

> These rules are enforced, not advisory. Where a rule says "must", a violation blocks merge to `main`.

## 0. Principles

1. Truth over velocity. A red CI is better than a silent lie.
2. `main` is sacred. Nothing reaches it without a branch, a review, green checks, and Shayan's approval.
3. Documentation is part of the change, not a later cleanup.
4. If it wasn't run, it wasn't verified. If it wasn't verified, say so.
5. Recovererability beats heroics. Commit often, branch always, defer explicitly.

## 1. Documentation Truth

**R1 — Docs Must Be Findable**
When an agent is told to work on the project, the important documents must be easy to locate immediately.
- Keep `README.md` current as the docs index.
- Keep top-level docs linked from `README.md`, `CONTRIBUTING.md`, and `AGENTS.md`.
- Avoid creating important one-off docs with no inbound links.

**R2 — Documents Must Be Updated During the Work**
Documentation is not a cleanup step that happens later.
- Update affected docs in the same work pass as the code or workflow change.
- If the implementation changes contract, behavior, operations, or scope, sync the docs before calling the task complete.
- If a document is now stale and cannot be fully updated in the same pass, say so explicitly and record the gap in the deferred-work register (Rule 12).

**R15 — Source-of-Truth Hierarchy Must Be Preserved**
Conflicting documents create drift.
- Treat code, current architecture docs, current governance docs, and the latest sync note as higher priority than historical planning files.
- When an older document becomes misleading, mark it `historical` or `superseded` instead of letting it silently compete with current truth.

**R31 — Doc Freshness Is Enforced (CI gate)**
Stale or missing docs are a defect, not a nicety. The CI gate fails `main` if any of:
- `README.md` is missing, or links to a non-existent relative file;
- no audit under `audits/` is newer than 30 days;
- the count of markdown files under `docs/` is below the recorded baseline (`docs/_baseline.json`) without an approved deletion (Rule 14).

## 2. Agent Integrity & Truthfulness

**R3 — Agents Must Be Truthful**
No fake completions, no invented verification, and no claiming a result that was not actually checked.
- Distinguish clearly between `done`, `partially done`, `deferred`, `blocked`, and `untested`.
- Do not imply a command, test, deploy, or build succeeded if it was not run.
- Do not present guesses as facts.

**R4 — No Silent Step-Skipping**
If a requested step was not done, that must be reported directly.
- Do not quietly skip verification, docs, cleanup, deployment checks, or follow-up tasks.
- If a step is omitted, state why.
- If a step cannot be done safely, stop and surface the reason.

**R8 — Do Not Assume Material Facts**
If a fact affects implementation, verification, safety, or release confidence, verify it.
- Inspect code, docs, config, and current repo state before concluding.
- Ask when ambiguity remains material after inspection.
- This rule does not forbid reasonable implementation progress; it forbids unsupported claims and risky guesses.

**R16 — Every Completion Report Must Separate Facts by Status**
Reports become unreliable when completed work and future work are mixed.
- Separate `completed`, `deferred`, `blocked`, and `pre-existing`.
- Include verification status.
- Include any known residual risk.

**R17 — Verification Must Match the Change Surface**
"Tests passed" is not enough if the change was docs-only, CI-only, mobile-only, or deployment-only.
- Choose verification that matches what changed.
- If only docs changed, verify links, references, and consistency.
- If CI or deployment behavior changed, verify the relevant external status where possible.

**R22 — Verification Baseline Exists**
Every repo must have a runnable verify path (build/test/lint/typecheck).
- If none exists, creating one is a required deferred-work item (Rule 12).
- Never claim success against a verify path that doesn't exist.

**R38 — Reports Must Link Evidence**
Every completion report must state the verification command actually run and, where applicable, link the CI run or audit file path. Claims without evidence are incomplete.

## 3. Audits

**R5 — Audits Must Use Code, Docs, and Prior Audits**
An audit is not a surface-level opinion.
- Base every audit on current code inspection.
- Compare findings with current docs.
- Read relevant previous audits before producing a new one.
- Call out where earlier findings are still true, fixed, or now outdated.

**R6 — Every Audit Must Be Saved Using the Naming Convention**
Audit artifacts must be recoverable and sortable.
Required filename format (ISO, parseable, sortable):

`YYYY-MM-DD_<AgentName>_<Scope>_Audit.md`

Example: `2026-07-17_Codex_General_Audit.md`

Include the date, the agent name, and a concise but meaningful scope label.

**R7 — Audit Files Must Stay Private by Default**
Audit working files should be saved in the repo workspace without being exposed publicly by accident.
- Save private audit files under `audits/`; keep `audits/private/` gitignored.
- If an audit must become public, promote it intentionally into `docs/` and mention that decision in the commit/report.

**R33 — Audit Retention**
- Keep audits for at least 12 months.
- Purge `audits/private/` contents only after rotation and only with Shayan approval.
- Do not delete audit history to "clean up".

## 4. Deferred & Pre-existing

**R11 — Do Not Walk Past Pre-Existing Bugs**
If an agent encounters a real pre-existing bug or error, it should not be silently ignored just because it predates the current task.
- Assess whether the issue is safe and reasonable to fix in the current pass.
- If yes, fix it and report it as pre-existing.
- If not, record it in the deferred-work register and mention it in the report.
- This rule does not require reckless scope expansion; it requires visibility and responsible handling.

**R12 — Deferred Work Must Be Recorded**
Deferred work must survive the session.
- Record deferred items in `docs/governance/DEFERRED_WORK.md`.
- Include enough detail for a future agent to resume intelligently.
- Do not leave "we should do this later" only in chat.

## 5. Version Control, Branches & CI

**R9 — Commit and Push Regularly**
Work should be recoverable, reviewable, and not left sitting locally for long periods.
- Commit in coherent increments.
- Push only via a dedicated branch / PR (never directly to `main`).
- If something is intentionally left uncommitted, say what and why.

**R26 — Main Is Protected**
- No direct commits or pushes to `main`.
- `main` requires: a PR, green required checks, and Shayan's approval.
- A red workflow on `main` is a release-blocking incident, not a footnote.

**R27 — Branch Naming Convention (enforced)**
Use one of:
- `feat/<short-slug>`
- `fix/<short-slug>`
- `docs/<short-slug>`
- `chore/<short-slug>`
- `refactor/<short-slug>`
- `agent/<AgentName>-<short-slug>`

`slug` = kebab-case, ≤ 40 chars, no nested slashes.
Example: `agent/hermes-doc-freshness-gate`.

**R28 — Conventional Commits & PR Descriptions**
- Commit subjects use `type(scope): summary`.
- PR body must list which rules it satisfies and the verification evidence.

**R29 — No Force Push to Shared Branches**
`main` and long-lived branches are locked against force push. Force push only to your own ephemeral branch with an explicit need.

**R30 — CI Gate Must Be Green to Merge**
The required status checks — `secret-scan`, `build`, `test`, `doc-freshness`, `deploy-dry` — must all pass. Required checks are defined in `.github/workflows/gate.yml` and in `docs/governance/BRANCH_POLICY.md`.

**R32 — Repo-Adaptive Verification**
Verification matches the repo. Repos with no production deploy run a smoke build / dry-run instead of a real deploy; the gate still requires that smoke to pass. Detection logic lives in `scripts/verify.sh` / `scripts/verify.ps1`.

**R21 — Agent Attribution**
Agent-made changes carry an `Agent: <Name>` trailer or PR label so humans can distinguish AI work from human work.

## 6. Security, Safety & Spend

**R19 — Security & Secrets**
- No secrets in the repo, ever: `*.p8`, `*credential*`, `.env`, tokens, and keys stay out of code, docs, chat, commits, PRs, and logs.
- Every repo ships a `.gitignore` from first commit covering secrets, `node_modules`, build output, and IDE files (`.vs`, `desktop.ini`).
- If a secret was ever committed, rotate it immediately and report it; do not "fix" by gitignoring after the fact.

**R14 — No File Deletion Without Direct Shayan Approval**
File deletion is prohibited unless Shayan explicitly approves it.
- Do not delete files or folders without direct approval from Shayan.
- Ask first, even if the file looks obsolete.
- If removal seems necessary, propose it and wait for approval.
- This rule is strict.

**R18 — Protect Existing User Changes**
This repo may contain user-owned local changes.
- Do not overwrite, revert, or clean unrelated existing changes without explicit approval.
- Call out unexpected conflicting changes before forcing through them.
- Preserve uncommitted user work unless directly told otherwise.

**R24 — Spend / Cost Guardrail**
No paid API calls, infrastructure spend, or billable deploys without explicit Shayan approval.

**R35 — Secret Scanning Never Bypassed**
The `secret-scan` job cannot be skipped via `[skip ci]` or forced merge. Findings block.

## 7. Repo Hygiene & Reproducibility

**R20 — One Coherent Project Per Repo**
Marketing sisters, forks, and duplicates are separate repos with clear purpose, not ambiguous clones.

**R23 — Reproducible Setup**
`README.md` + `.env.example` must let a fresh agent stand the repo up with no hidden manual steps.

**R34 — Dependency Hygiene**
Lockfiles are committed; dependencies are kept free of known-critical vulnerabilities; deprecated runtimes are flagged as deferred work.

**R36 — Rollback / Revert Policy**
A broken `main` is reverted first, diagnosed second. Reverts are themselves PRs.

**R39 — Changelog / Release Notes**
User-facing changes are recorded (`CHANGELOG.md` or release notes) before tagging.

**R37 — Agent Session Isolation**
An agent working in one repo must not read, write, or assume state from another repo unless explicitly told. Cross-project context is loaded by the user, not invented by the agent.

## 8. Rules Governance

**R25 — Rules Self-Governance**
This file is versioned (semver + date). Audits review whether the rules are being followed and whether the rules themselves need updating. Changes to `REPO_RULES.md` go through the same branch/PR/CI flow.

---

## Appendix A — Branch & CI Policy (protection settings)

GitHub branch protection for `main` (set via Settings → Branches or `gh`):
- Require a pull request before merging.
- Require status checks to pass: `gate` (covers secret-scan, build, test, doc-freshness, deploy-dry).
- Require branches to be up to date before merging.
- Dismiss stale approvals on new commits.
- Require review (Shayan or CODEOWNERS).
- Apply to administrators (no self-merge bypass).
- Block force pushes and branch deletion.
See `docs/governance/BRANCH_POLICY.md`.

## Appendix B — CI Gate Spec

`.github/workflows/gate.yml` runs on PRs to `main` and on pushes to non-main branches.
Jobs / checks:
1. `secret-scan` — gitleaks if available, else fallback grep for `*.p8`, `*credential*`, `API_KEY`, `SECRET`, `PRIVATE_KEY`.
2. `doc-freshness` — README exists + link integrity; newest audit < 30 days; `docs/` md count ≥ baseline.
3. `build` / `test` — repo-adaptive (Node / Python / Rust / static).
4. `deploy-dry` — if a deploy target config is present (vercel/railway/eas/netlify), run its dry-run; otherwise the smoke build covers it.

All checks must be green to merge. See `scripts/verify.sh` / `scripts/verify.ps1` for the implementation.

## Appendix C — Doc Freshness Check Details

- Baseline captured on first apply into `docs/_baseline.json` (`{"md_count": N}`).
- Any drop below baseline without an approved deletion (Rule 14) fails CI.
- Audit age computed from file mtime of the newest `audits/*.md` (excluding `audits/private/`).

## Appendix D — Apply Script Usage

From the repo root you want to govern:

```bash
# bash (git-bash / MSYS on Windows, or any shell on Linux/macOS)
/path/to/apply_repo_governance.sh .

# PowerShell (Windows)
pwsh -File apply_repo_governance.ps1 -Repo .

# To also open a PR (pushes the branch, never main):
apply_repo_governance.sh . --pr
```

The script never pushes to `main`. It creates a branch `agent/hermes-governance-bootstrap`, writes the governance files, seeds an initial audit dated today, commits locally, and (with `--pr`) opens a PR for Shayan's approval.

## Appendix E — Audit Filename Examples

- `2026-07-23_Hermes_GovernanceBootstrap_Audit.md`
- `2026-08-01_Codex_Security_Audit.md`
- `2026-09-15_Hermes_Performance_Audit.md`
