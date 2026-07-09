---
name: ui-ux-for-apps
description: Editor-level app/software UI/UX design and implementation skill — applies brand-system discipline, tokenized visual language, motion, anti-template audit, and QA across desktop apps, internal tools, dashboards, local-first apps, SaaS UIs, admin panels, and other app surfaces that need premium quality without hardcoded colors/logo/brand assumptions.
---

# UI/UX for Apps

## When to activate
Activate when the user asks to design, redesign, polish, review, or implement UI for an application or software product: desktop app, internal tool, dashboard, local-first app, admin panel, SaaS interface, or app-like surface.

Also activate when they ask for premium app UI quality and explicitly want to avoid generic template output.

## When NOT to use
- Do not use for website/marketing-only workflows such as SEO, structured data, local NAP, or public landing-page strategy, unless the app surface explicitly includes that surface.
- Do not use for pure backend/API/CLI work with no user-facing UI surface.
- Do not skip Layer 0 Discovery, even for fast jobs — keep it brief but explicit.

---

## Core Principles
1. Brand-first decisions, never default-first.
2. Tokens over hardcoded colors — semantic tokens first; literal values are allowed only as token definitions.
3. Motion with purpose and restraint, never decoration-first.
4. Every component should earn its presence.
5. No emoji as UI iconography.
6. No placeholder logos in production.
7. No template smell: layout choices should make sense for *this* app.
8. Build, typecheck, and lint must pass before reporting done.

---

## Layer 0: Discovery (must be brief but explicit)
Before designing or coding, confirm:
- What the app does and who uses it.
- **Primary job-to-be-done** by screen.
- Main actions on each screen: primary vs secondary.
- Personality/feeling: 2-3 adjectives tied to the product context.
- Any explicit reference/showroom mood, palette fondness, or anti-patterns.
- Whether content/assets are real or placeholders.

Output a short **design direction summary**, saved in-repo as `IDEAS.md` or `DESIGN.md`. Use this as the source of truth for later decisions.

---

## Layer 1: Information Architecture & Flow
App UI is for task completion, not passive browsing.
- Map each user goal to primary screens and primary actions.
- Define the primary action and one secondary action per screen where practical.
- Prefer minimal, intentional layout density over decorative sections.
- Keep known patterns for navigation, settings, forms, tables, status areas, and empty/error/loading states.

---

## Layer 2: Visual System

### 2A: Tokens, Color & Typography
- Semantic design tokens should be used for color, typography, spacing, radius, elevation, and motion.
- Do not hardcode literal colors inside components. Literal values are allowed only inside token definitions.
- Choose display + body typography deliberately and tie the pairing to app personality.
- Use fluid type scaling where it improves readability and cohesion.

### 2B: Signature Visual Devices
Reusable brand patterns improve recognition and reduce template feel:
- Card or container language with consistent treatment.
- Accent treatment that signals hierarchy and scan order.
- Selected/active state treatment that is visually unambiguous.
- At least 2–3 named reusable patterns so the UI doesn’t read as default components everywhere.

### 2C: Motion & Feedback
- Use motion for feedback and orientation, not decoration.
- Keep animated properties limited mostly to `transform` and `opacity`.
- Cover core states: hover, focus, active, loading, empty, error, success.
- Respect reduced-motion preferences as a first-class behavior.

### 2D: Navigation & State
- Persistent layout only where it helps continuity.
- Navigation and tabs should always show active state clearly.
- Transitions between states should avoid jarring full resets when a persistent shell can maintain context.

---

## Layer 3: Implementation Quality
- Build passes before reporting done: typecheck, lint, and production build where applicable.
- Keyboard navigation, focus visibility, and semantic structure where the platform expects it.
- Platform-aware affordances: desktop vs mobile/touch behavior, window chrome, and system conventions when relevant.

---

## Layer 4: Anti-Template Audit
Run this before claiming the UI is ready.
- Emoji/icons sweep: no emoji used as UI iconography.
- Logo audit: real assets only; unresolved placeholders must be flagged explicitly in the next report.
- Card/container audit: repeated containers should carry recognizable, intentional treatment.
- Layout audit: could this UI be mistaken for another app after only a logo and color swap?
- Font audit: deliberate pairing, real loading behavior confirmed, weights intentional.

---

## Layer 5: QA Gate
Do not report completion until:
- Build/typecheck/lint pass.
- Primary flows have been verified conceptually or locally when possible.
- Empty, error, and loading states exist and match the design direction.
- Layer 4 anti-template audit is clean.
