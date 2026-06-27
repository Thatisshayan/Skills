---
name: swarm-coding
description: Coordinate swarm coding work for substantial software tasks, including general repositories and webapps. Use when a task benefits from delegation, parallel implementation, subagents, workers, git worktrees, design-first webapp building, bundled webapp templates, or integration across multiple independent modules/features. Also use when converting a large request into scoped agent assignments, branch/worktree plans, merge steps, and verification.
---

# Swarm Coding

Use this skill to turn a broad coding request into coordinated work by a main agent and focused subagents. Favor first principles over environment folklore: inspect the actual repo, choose the lightest isolation that works, give each worker a bounded contract, then integrate and verify from the real code.

## Core Rules

1. Keep the main agent responsible for requirements, architecture, task slicing, merges, final fixes, tests, and the user-facing report.
2. Delegate only separable work. If the next local step depends on an answer, do that step locally instead of waiting on a subagent.
3. Give every subagent a clear ownership boundary: files, modules, pages, tests, and forbidden areas.
4. Share contracts before implementation: public APIs, route names, data shapes, component boundaries, filenames, dependency choices, and expected tests.
5. Prefer the existing repo stack. For greenfield webapps, use the default stack only when the user has not requested a different stack.
6. Avoid legacy assumptions. Do not require cloning into the user home directory, `/mnt/agents/output`, OSS-backed paths, or baked `node_modules` unless the live environment proves that is necessary.
7. Integrate from source, not promises. Review worker changes, resolve conflicts, run the real validation loop, and fix integration issues before reporting completion.

## Kimi CLI Agent Model

Kimi CLI has built-in subagent types, not arbitrary dynamic `create_subagent`
roles:

- Use `Agent(subagent_type="explore")` for read-only investigation.
- Use `Agent(subagent_type="plan")` for design, architecture, review, and
  task-slicing agents.
- Use `Agent(subagent_type="coder")` for implementation workers that may write
  files or run commands.
- Put role rules, ownership boundaries, repo/worktree path, forbidden paths,
  validation commands, and expected report format into `Agent.prompt`.
- Newly created subagents do not inherit main-agent context. Pass the shared
  contract and exact paths explicitly.
- Kimi subagents normally share the same working directory. For concurrent
  implementation, the main agent must create git worktrees first and assign each
  coder an absolute worktree path. If worktrees are unavailable, use read-only
  analysis workers or single-agent implementation.
- Subagents cannot launch other subagents.

## Mode Selection

Use **single-agent mode** when the task is a small bug fix, one script, a narrow feature, or unclear enough that parallel work would multiply assumptions.

Use **multi-agent mode** when at least two substantial slices can proceed independently after a short shared contract is written. Good signals include:

- Multiple independent modules, packages, routes, pages, or backend/frontend layers.
- A webapp with separate design, scaffold, page, asset, interaction, or verification work.
- A migration or refactor where mechanical changes and tests can be split by package.
- A research or audit task where independent questions can be answered in parallel.

When in doubt, start single-agent, create a plan, and delegate only after the interfaces and ownership are clear.

## Isolation Choice

Choose one isolation model from current facts:

| Situation | Preferred isolation |
| --- | --- |
| The client gives subagents isolated forked workspaces or patch uploads | Assign disjoint write scopes; integrate returned changes in the main workspace |
| Shared local git repo and subagents can edit filesystem paths | Use git worktrees under a repo-local or sibling `.worktrees/` directory; in Kimi CLI, create these before launching `coder` subagents |
| No git repo, tiny task, or filesystem isolation unavailable | Use single-agent mode or ask workers for read-only analysis |
| Webapp greenfield project | Scaffold once, commit baseline, then branch/worktree by page or feature |

## Repo Lifecycle

Resolve the actual project repo once and run repo/worktree lifecycle commands through it. Do not run these commands from a parent workspace that merely contains the project.

Commit identity rule: do not write global or repo-local git config unless the user asks. If a commit fails only because identity is missing, rerun that same commit with `git -c user.name="Coding Agent" -c user.email="coding-agent@localhost" commit ...`.

For a generated project that is not already a git repo, initialize and commit the scaffold baseline:

```bash
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  git init -q -b main 2>/dev/null || { git init -q && git branch -m main; }
}
git status --short --branch
git add -A
if ! git diff --cached --quiet; then
  if git var GIT_AUTHOR_IDENT >/dev/null 2>&1; then
    git commit -m "chore: establish agent baseline"
  else
    git -c user.name="Coding Agent" -c user.email="coding-agent@localhost" commit -m "chore: establish agent baseline"
  fi
fi
```

For an existing repo that needs a new shared baseline branch:

```bash
MAIN_REPO="$(git rev-parse --show-toplevel)"
git -C "$MAIN_REPO" status --short --branch
git -C "$MAIN_REPO" switch -c agent/base-<short-task>
git -C "$MAIN_REPO" add -A
git -C "$MAIN_REPO" diff --cached --quiet || git -C "$MAIN_REPO" commit -m "chore: establish agent baseline"
```

Create worker worktrees only after the baseline commit exists:

```bash
MAIN_REPO="$(git rev-parse --show-toplevel)"
WT_ROOT="$MAIN_REPO/../.worktrees"
mkdir -p "$WT_ROOT"
git -C "$MAIN_REPO" worktree add "$WT_ROOT/<scope>" -b agent/<scope>
git -C "$MAIN_REPO" worktree list --porcelain
```

Worktree cleanup is hygiene, not correctness. After worker branches are merged or deliberately abandoned, cleanup can be skipped or left for a separate pass. Frontend worktrees often contain large untracked dependency trees, so do not put deletion on the critical path or chain it with final validation.

When cleaning, remove one worktree per command and inspect state:

```bash
MAIN_REPO="$(git rev-parse --show-toplevel)"
WT_ROOT="$MAIN_REPO/../.worktrees"
git -C "$MAIN_REPO" worktree list --porcelain
git -C "$MAIN_REPO" worktree remove "$WT_ROOT/<scope>"
git -C "$MAIN_REPO" worktree list --porcelain
```

If `worktree list --porcelain` shows stale metadata, `git -C "$MAIN_REPO" worktree prune` cleans that metadata only; it is not a directory deletion retry. Remove leftover directories only in an explicit cleanup pass after verifying they are under `WT_ROOT` and have no unmerged worker changes.

Dependency directories such as `node_modules` are intentionally untracked and are not shared across git worktrees or merges. Each worktree that runs build, lint, typecheck, tests, or a dev server must install dependencies in that worktree first. After merging worker branches back, the final workspace must also have dependencies installed before final validation. Commit package manifests and lockfiles, not `node_modules`.

## Coordination Spec

For multi-agent work, write a concise contract before launching implementation. Use an uncommitted scratch note, a prompt section, or a committed `AGENT_SPEC.md` only when it will help workers stay aligned.

Include:

- User goal and non-goals.
- Current repo facts: stack, package manager, test commands, important constraints.
- Architecture or design decisions already made.
- Interfaces workers must not change without approval.
- Task slices with owner, allowed write paths, forbidden paths, and validation commands.
- Merge order and expected final verification.

Do not over-specify creative or implementation details that belong to a worker's assigned scope. Do specify anything another worker depends on.

## General Coding Workflow

1. Inspect the repo and nearest instructions. Check dirty state before edits.
2. Decide mode and isolation.
3. Create the coordination spec.
4. Launch workers for independent slices. Keep the immediate blocking path local.
5. While workers run, prepare shared infrastructure, write adapters, or handle another non-overlapping slice.
6. Review each worker result before merging. Reject or repair changes outside the worker's scope.
7. Merge incrementally. Prefer small merges in dependency order when conflicts are likely; use octopus merge only for truly independent branches.
8. Run the integration validation loop from the final workspace.
9. Run final validation and report exact verification results. Mention leftover worktrees if cleanup was skipped.

## Worker Prompt Template

Give each worker a prompt with this shape:

```text
You are not alone in this repo. Other agents may be editing different areas; do not revert changes you did not make.

Repo/worktree: <absolute path>
Branch or workspace: <branch/workspace name>
User goal: <original goal or faithful summary>

Shared contract:
- <interfaces, design decisions, package manager, constraints>

Your ownership:
- Implement: <specific module/page/feature>
- You may edit: <paths>
- Do not edit: <paths>

Before editing:
- Read <files>
- Check current git status

Validation:
- Install dependencies in this worktree if validation needs them and they are missing.
- Run <targeted commands>
- If a command cannot run, record the exact reason

Finish by committing your changes if you are in a git worktree assigned for merge, or by reporting changed files if the client uses patch upload or shared editing.
```

For implementation workers, include exact file paths and tests. For explorer workers, ask one concrete question and request evidence with file references.

## Webapp Workflow

For existing webapps, use the repo's stack and scripts. For greenfield webapps, if the user has not specified another stack and is not against the default, use:

- React + TypeScript.
- Vite or the repo/client's standard frontend scaffold.
- Tailwind CSS and shadcn/ui when component density or design-system speed helps.
- Public registry installs at runtime. Do not rely on baked dependencies or copied `node_modules`.
- Bundled templates from `assets/templates/` when a template matches the requested style or app shape.

Before designing, read `references/webapp-design.md`. Before implementing React UI, read `references/react-dev.md`.

### Dedicated Designer Gate

For any user-facing website, webapp, landing page, portfolio, dashboard, browser game, or interactive page, run a separate design phase before scaffold customization, content workers, asset workers, or page workers start.

- In multi-agent webapp mode, the first subagent is a dedicated designer. In Kimi CLI, use `Agent(subagent_type="plan")` and put the designer role into the prompt; do not rely on named subagents.
- Do not combine the designer with scaffold, content, asset, or page implementation work.
- If subagents are unavailable or the task is deliberately single-agent, the main agent must write the design artifact in a distinct design pass before implementation.
- For a template-based or single-page app, one compact `design/design.md` is enough.
- For a custom or multi-page app, create `design/design.md` plus per-page design files.
- Do not launch content, asset, or page workers until the main agent has read the design artifact and extracted stable worker contracts from it.

The designer should not implement code. The designer owns the experience: template choice or no-template choice, page/route map, information architecture, visual direction, content hierarchy, section mapping, interaction and motion language, responsive behavior, asset manifest, and worker grouping suggestions. The main agent may gather requirements, research, and template notes before design, but should not pre-decide page count, page structure, or visual style unless the user already specified them.

Designer subagent prompt shape. Replace `<skill-dir>` and `<project>` with absolute paths:

```text
You are the dedicated web designer for this build. Do not implement code.

Read <skill-dir>/references/webapp-design.md, the user's request, any research notes, and relevant template info. Make the creative and structural decisions before implementation starts.

Write the design artifact(s) under <project>/design/:
- design.md with global concept, routes/pages, visual system, interaction language, responsive rules, dependencies, asset manifest, and worker grouping suggestions.
- home.md and per-page design files for non-trivial multi-page sites.

Use exact filenames, route names, asset filenames, colors, typography, and section responsibilities so implementation workers can follow the design without inventing structure.
```

Design-first webapp sequence:

1. Main agent gathers requirements, research, and relevant template notes.
2. Dedicated designer creates the design artifact. For bundled templates, the design must name the selected template and map requested content to its configurable sections and assets.
3. Main agent reads the design, decides scaffold strategy, worker grouping, image filenames, routes, and write boundaries.
4. Scaffold step initializes the project, installs dependencies from the public registry, sets global theme/styles/routing, creates shared layout components when needed, implements the home page or template baseline, and commits. The main agent may do this locally when scaffold is a short template extraction; otherwise use a scaffold worker.
5. Main agent merges or commits scaffold baseline before creating page/content/asset branches so every downstream worker inherits shared components, styles, and contracts.
6. Page/content/asset workers implement only their assigned slices. They should not modify global routing, theme, shared layout, or generated assets unless explicitly assigned.
7. Main agent wires routes, resolves conflicts, runs build/tests, starts a local dev server when useful, and verifies the UI with screenshots or browser checks when the user-facing result depends on rendering.

Asset generation is client-tool dependent. The designer specifies the asset manifest; the main or scaffold agent chooses from tools actually available in the current environment: bundled template assets, user-provided assets, public sourced assets, browser/image-search tools, or explicit image-generation tools exposed by the client. Do not probe for arbitrary shell binaries or invent command names for image generation.

Dependency rules for webapp workers:

- Before any worker runs `npm run build`, `npm run lint`, tests, or a dev server, run the package-manager install in that worker's worktree if `node_modules` or the needed binaries are missing.
- After merging worker branches into the main/final workspace, run the package-manager install there before final build. Do not expect a worker's `node_modules` to appear in the main workspace.
- Package installs can legitimately take minutes. Use the package manager implied by the project lockfile or scaffold contract; do not switch package managers just because an install is slow or was interrupted.
- If an install was interrupted or failed after writing `node_modules`, confirm the previous install process has stopped, remove the incomplete `node_modules`, and retry with the same package manager. Preserve committed lockfiles. If intentionally switching package managers before the baseline is committed, remove stale lockfiles from the abandoned manager and commit the chosen manifest and lockfile together.
- If validation reports a missing imported package, inspect the importing file and `package.json`. Install the missing runtime/type dependency explicitly, then commit `package.json` and the lockfile. Do not remove shared UI components just to hide the error unless the design and ownership contract say they are unused.
- If install fails with an opaque package-manager or shell transport error, retry once with the quieter public-registry command and enough time for network work, then validate by running the build:

```bash
rm -rf node_modules
npm install --prefer-offline --no-audit --no-fund
npm run build
```

Greenfield Vite starting point, adapting to the current package manager and current public CLI behavior:

```bash
npm create vite@latest <app-name> -- --template react-ts
cd <app-name>
npm install
```

Then install Tailwind, shadcn/ui, routing, animation, icon, and visualization packages as the design actually requires. Verify each public-registry command against current package output instead of assuming a prebuilt image.

## Bundled Webapp Templates

This skill includes reusable template ZIPs under `assets/templates/`. Use them for greenfield webapps when a template gives the team a better scaffold than a blank Vite app. Each template directory includes:

- `<template-name>.zip`: source scaffold only; no `node_modules`.
- `info.md`: template-specific notes that the scaffold worker should read after extraction.

List available templates:

```bash
resolve_swarm_coding_skill_dir() {
  if [ -n "${KIMI_SKILL_DIR:-}" ]; then printf '%s\n' "$KIMI_SKILL_DIR"; return; fi
  for candidate in \
    "$(pwd)/.agents/skills/swarm-coding" \
    "$(pwd)/.kimi/skills/swarm-coding" \
    "$HOME/.config/agents/skills/swarm-coding" \
    "$HOME/.agents/skills/swarm-coding" \
    "$HOME/.kimi/skills/swarm-coding" \
    "$HOME/.claude/skills/swarm-coding" \
    "$HOME/.codex/skills/swarm-coding"; do
    [ -d "$candidate" ] && { printf '%s\n' "$candidate"; return; }
  done
  printf '%s\n' "$(pwd)/.agents/skills/swarm-coding"
}
SKILL_DIR="$(resolve_swarm_coding_skill_dir)"
bash "$SKILL_DIR/scripts/init-webapp-template.sh" --list
```

Extract a template into a project directory and install dependencies from the public registry:

```bash
SKILL_DIR="$(resolve_swarm_coding_skill_dir)"
bash "$SKILL_DIR/scripts/init-webapp-template.sh" ./app "App Title" 0-origin
```

Safer two-step flow, useful when the shell tool is sensitive to long package-manager subprocesses:

```bash
SKILL_DIR="$(resolve_swarm_coding_skill_dir)"
bash "$SKILL_DIR/scripts/init-webapp-template.sh" ./app "App Title" airlens-style --no-install
cd ./app
npm install --no-audit --no-fund
```

Use `--no-install` when the main agent needs to inspect or patch the scaffold before dependency install, or when a client reports an opaque package-install failure.

Do not assume `KIMI_SKILL_DIR` is exported as a shell environment variable. Some clients expand it as a prompt placeholder only, and some do not expose it to shell commands. Always include the resolver above before invoking bundled scripts. Kimi CLI can discover both project-level skills (`.agents/skills`, `.kimi/skills`, etc.) and user-level skills (`~/.config/agents/skills`, `~/.agents/skills`, `~/.kimi/skills`, etc.); prefer the actual discovered skill directory when known.

If the helper fails after extracting files, do not manually unzip the template into the same target directory. First inspect the target. If `package.json` exists, continue from there with `npm install --no-audit --no-fund` or the package manager implied by the lockfile. If the target contains a nested `<template-name>/` directory from a manual unzip, remove the target and rerun the helper with `--no-install`.

After extraction, read `template-info.md` in the generated project and follow any template-specific configuration notes. Commit the scaffold baseline before creating page or feature branches.

## Webapp Worker Boundaries

Scaffold worker owns:

- Project initialization and dependency install.
- `package.json`, lockfile, build config, Tailwind/shadcn setup.
- `src/App.*`, route stubs, global CSS/theme, shared layout/navigation/footer.
- Base assets directory and home page.

Page workers own:

- Their assigned page components, section components, local hooks, local data fixtures, and page-specific tests.
- Package installs only when needed for their page and compatible with the scaffold.

Page workers must not edit:

- Global routing except route metadata explicitly assigned to them.
- Shared layout/navigation/theme.
- Other pages.
- Existing assets generated or committed by another worker.

## Integration Checklist

Before final response:

- `git status --short` is understood, including unrelated user changes.
- All worker changes have been reviewed.
- Branches/worktrees are merged or deliberately left separate with a reason.
- Build, test, lint, typecheck, or targeted verification has run as appropriate.
- Webapps that need runtime rendering have been opened locally or checked with screenshots/browser automation when the environment supports it.
- The final answer states what changed, where, what was verified, and any residual caveats.
