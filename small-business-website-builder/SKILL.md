---
name: small-business-website-builder
description: The most comprehensive small-business website and UI/UX build skill — enforces a 10/10 quality floor (baselined on the Bright Star Auto build) covering brand-philosophy discovery, signature visual devices, Framer Motion orchestration, moving tabs, maps/local SEO, mobile-first engineering, and a strict anti-generic-AI-slop audit (no emoji icons, real logos only, no shitty boxes, no templated layouts, no lazy fonts). Use whenever building, redesigning, or polishing a marketing/UI site for a small or local business.
---

# Small Business Website & UI/UX Builder (Baseline: Bright Star Auto — 10/10 Standard)

## When to activate
Activate when the user asks to design, build, redesign, or "polish" a website or web app UI for a small business, local service business, or business-facing marketing site — e.g. "build me a website for [business]," "redesign my site to look premium," "make this look custom-built, not templated," or when they invoke `/small-business-website-builder`. Also activate when a user references wanting quality "as good as" a prior premium build, or asks for a site that needs to convert visitors into leads/customers (bookings, quotes, calls).

This skill treats the `ultimate-frontend-design` / `ui-ux-pro-max` skills as **one component layer inside it** (Layer 2, Visual & Motion System, below) — not a replacement. Load those skills too when this one is active; this skill is the outer discipline that also covers information architecture, SEO, conversion strategy, maps/local-business integration, a strict anti-generic-AI enforcement pass, and a hard non-negotiable QA gate that those skills don't enforce on their own.

## When NOT to use
- Do not use for pure backend/API work, CLI tools, or non-visual logic with no UI surface.
- Do not use for large enterprise SaaS product design systems (use a dedicated design-system skill) — this is calibrated for small-business/local-service marketing sites (auto shops, clinics, restaurants, contractors, salons, professional services, etc.) where the deliverable is a small number of pages that must look premium and convert.
- Do not skip straight to code. Every project run through this skill starts with the Discovery step below, even if brief.

## The Baseline (read this first, every time)

The reference quality bar for this skill is the **Bright Star Auto Ltd website** (North York auto bodyshop, React + TypeScript + Vite + Tailwind v4 + shadcn/ui + Framer Motion + wouter). That build is **floor, not ceiling** — every project run through this skill must meet or exceed it on every axis below. Never ship something a small business owner would describe as "just a template with their logo swapped in."

What made that baseline a 10/10 rather than a generic template, distilled into transferable rules:

1. **A documented brand system exists before any component is coded** — the project had an `ideas.md` design philosophy doc (positioning, color rationale, layout paradigm, brand voice rules with explicit correct/incorrect copy examples, signature elements, accessibility standards, performance targets) written *before* implementation. Reproduce this discipline for every project (see Layer 0).
2. **Signature visual devices, not stock components** — bracket-style "corner accents" on stat blocks/forms/quote cards, a gold "signature underline" eyebrow above every section heading, animated "quality bar" fills tied to real metrics, custom numbered markers instead of default list bullets. A 10/10 site has at least 3-4 *named, reusable, brand-specific* visual devices like this that a generic shadcn/Tailwind template would never have out of the box.
3. **Every section earns its place with a conversion or trust purpose** — hero (promise + proof), marquee/ticker (breadth of service), services (bento, not uniform grid), why-us (quantified trust signals with animated proof), process (removes anxiety about "what happens next"), gallery (visual proof of quality), reviews (social proof, real language), contact (low-friction conversion). No section is decorative filler.
4. **Copy is rewritten, never left generic** — no "Welcome to our website," no "Submit," no "Best service." Every headline follows Verb + Outcome + (implied or explicit) removal of a pain point. Every CTA names the specific benefit ("Get My Free Estimate," not "Send").
5. **Motion has restraint and purpose** — scroll reveals, hover lift + glow, tactile button press, parallax on hero — but animation-only-on-`transform`/`opacity`, full `prefers-reduced-motion` support, and nothing animates just because it can.
6. **Nothing off-brand slips through** — that project's 404 page was audited and found off-brand (light background, generic blue button, default shadcn Card) and was rebuilt to match. Audit *every* route/state (404, empty states, loading states, error boundaries) against the brand system, not just the homepage.
7. **It typechecks and builds clean before it's called done.** Not aesthetic polish alone — `tsc --noEmit` and the production build both pass with zero errors as a hard gate.

If a deliverable doesn't clear all seven, it is not done, regardless of how much visual work went in.

---

## Non-Negotiables (violating any one of these fails the deliverable outright, no exceptions)

These are called out separately from the Layers below because they are the fastest way a build gets flagged as "AI slop" by a client, and the fastest way to lose the pitch. Check these on every single component, not just once at the end.

1. **No emoji as UI iconography, ever.** Not in buttons, not in feature lists, not in stat cards, not as a stand-in for a logo, not "just as a placeholder to replace later." Emoji render inconsistently across OS/browser, look like a hobby project, and are the single most common tell of an unpolished AI-generated site. Use a real icon library (Lucide, Phosphor, Heroicons, Font Awesome, or custom SVGs) instead — see Layer 2A.
2. **Use real logos everywhere a logo/brand mark belongs — never a generic icon or emoji standing in for one.** Payment method badges (Visa/Mastercard/Amex/PayPal/Apple Pay), tech/platform badges, insurance-partner or certification badges, social platform icons (real brand-mark SVGs, not a generic "share" glyph), review-platform badges (actual Google/Yelp/Facebook marks when displaying "as seen on" or aggregated review scores). If the real logo asset isn't available yet, flag it explicitly to the user as a placeholder that must be swapped before launch — do not silently ship a fake or generic substitute and call it done.
3. **No "shitty boxes."** A "shitty box" is: a plain `<div>` or default shadcn `Card` with a thin gray border, flat background, uniform padding, and zero brand personality, repeated identically for every card on the page. Every card/container in a shipped build must carry at least one deliberate brand treatment (see Layer 2A's Signature Visual Devices) — a custom shadow language, an accent border/corner treatment, intentional asymmetry, a background texture/gradient, or a hover state that does more than a generic lift. If you can swap the client's brand for a competitor's and the card looks identical, it's a shitty box — rebuild it.
4. **No generic-AI-template look, full stop.** This means: no uniform 3-column icon-over-heading-over-paragraph grids repeated for every section, no stock "gradient blob" backgrounds copy-pasted from every SaaS landing page template, no interchangeable hero ("Big Bold Headline / Subheading / Two Buttons / Stock Photo") that could belong to literally any business, no default shadcn component styling left untouched anywhere a user will actually look. Every section must have a layout decision that was made *for this brand specifically* — asymmetry, an unusual grid split, a signature device — not defaulted into.
5. **No shitty fonts.** This means: no un-inspected default font stacks (`font-sans` left as whatever Tailwind ships), no overused, tell-tale "AI template" pairings picked without thought (e.g. Poppins-for-everything, or Inter-for-everything with zero display-font contrast). Pick a deliberate display font + body font pairing that matches the brand personality from Layer 0, load them properly (self-hosted or Google Fonts with `font-display: swap`, subset to the weights actually used), and verify the pairing renders as intended — check real glyph contrast, x-height match, and that the display font doesn't look thin/generic at the weight chosen. If a font choice can't be justified in one sentence tied to the brand, it's the wrong font.

---

## Instructions — The Layered Build Process

Each layer below is a discrete, checkable pass. Do not collapse layers together or skip ahead — a later layer assumes the artifact from the one before it exists and was reviewed.

### Layer 0: Discovery (never skip, even for a quick job)
Ask (or infer from context, but state your inference back to the user for confirmation) before writing code:
1. **Business identity**: what does the business actually do, who's the customer, what's the geographic service area (critical for local SEO/maps)?
2. **Positioning & personality**: 2-3 adjectives (e.g. "Professional, Trustworthy, Innovative"). What does the business want people to feel in the first 3 seconds?
3. **Primary conversion goal**: phone call, booking form, quote request, walk-in, newsletter signup? Design every CTA around this one goal — don't split focus across five different asks.
4. **Competitive/inspiration reference**: any sites they admire or explicitly want to avoid looking like?
5. **Content inventory**: do real photos, testimonials, pricing, and service descriptions exist yet, or do they need to be drafted as placeholders clearly marked for client replacement?

Output of this layer: a short **design philosophy doc** (`ideas.md` or `BRAND.md`) in the repo root, modeled directly on the Bright Star Auto template below. This is not optional — it is the artifact that keeps every subsequent decision consistent and is what you hand to the client to justify design choices.

```markdown
# [Business Name] - Design Philosophy

## Design Direction: [e.g. "Dark Premium Automotive" / "Warm Coastal Hospitality" / "Clinical Minimal Trust"]

### Brand Essence
**Positioning:** [one sentence — what they are, to whom, better than alternatives]
**Personality:** [2-3 adjectives]

### Design Movement
[Name a real design tradition/movement this draws from, and why it fits the business category]

### Core Principles
[3-5 named principles, e.g. "Dark Sophistication", "Gold Precision", "Cinematic Depth", "Motion-First"]

### Color Philosophy
[OKLCH values for background/primary/accent/text, WITH the rationale — what does this color combination signal, and to whom, in this industry?]

### Layout Paradigm
[Named layout approach: e.g. "Asymmetric Hero + Modular Sections", bento grids vs uniform grids, alternating section backgrounds for rhythm]

### Signature Elements
[3-5 named, specific, reusable visual devices unique to this brand — not generic shadcn defaults]

### Interaction Philosophy
[Hover behavior, button feedback, scroll reveal behavior, transition easing curve — be specific with cubic-bezier values]

### Animation Guidelines
[Entrance duration/stagger, hover duration/scale, counter animation duration/trigger, reduced-motion policy]

### Typography System
[Display font + body font + rationale, letter-spacing, line-height, full h1-body clamp() scale]

### Brand Voice
**Headlines:** [style] — two real examples / two anti-examples
**CTAs:** [style] — two real examples / two anti-examples
**Microcopy:** [style] — two real examples / two anti-examples

### Signature Brand Color
[The one color that IS this brand — where exactly it appears, listed]

### Visual Assets
[What kind of photography/imagery is needed — hero, service shots, gallery, logo treatment]

### Accessibility Standards
[WCAG AA contrast, focus-visible, form labels, keyboard nav, reduced-motion, alt text, semantic HTML — check every box]

### Performance Targets
[LCP/FID/CLS targets, animation-property restriction, image format/lazy-load policy]

### Responsive Breakpoints
[Mobile/tablet/desktop/large-desktop ranges, and confirm clamp()-based fluid scaling is used instead of breakpoint-jump layouts]

### Style Decisions
[A running numbered list of specific, sometimes counterintuitive decisions and why — "No rounded corners on hero: sharp edges convey precision," etc. This is what prevents "generic AI template" drift six components in.]
```

### Layer 1: Information Architecture & Content Strategy
- Map every page and section to the **single primary conversion goal** from Discovery. If a section doesn't move the visitor toward that goal (trust-building, objection-removal, or direct conversion), cut it or justify it.
- Standard high-converting section set for a small-business site (adapt, don't cargo-cult): Hero (promise+proof) → Services/Offerings (bento, not uniform grid) → Why Choose Us (quantified trust signals) → Process/How It Works (removes "what happens next" anxiety) → Gallery/Portfolio (visual proof) → Reviews/Testimonials (real language, not paraphrased) → Location/Map (if physical business) → Contact/Conversion form → Footer (NAP consistency — Name/Address/Phone must match Google Business Profile exactly for local SEO).
- Write real headline and CTA copy now, in the brand voice defined in Layer 0 — never leave lorem ipsum or "Your Headline Here" in a build a client will see.
- Every page needs a defined **primary CTA above the fold** and a **secondary, lower-commitment CTA** (e.g. "Call Now" as primary, "See Our Work" as secondary).

### Layer 2: Visual & Motion System (this is where `ultimate-frontend-design`/`ui-ux-pro-max` plug in as one sub-layer)
Load and apply those skills' full design-science + animation-mastery + optimization references here, constrained by the brand philosophy doc from Layer 0. Additional rules specific to small-business sites, on top of what those skills already cover:

#### Layer 2A: Color, Type & Iconography (the "no shitty fonts / no emoji / no generic template" layer)
- OKLCH color system, always — perceptually uniform, easy to adjust lightness/chroma without hue drift when a client wants "a bit brighter."
- Pick ONE signature accent color that becomes shorthand for the brand (like the gold in the baseline) and use it with intention — CTAs, hover glow, key stat highlights, logo badge — never scatter 4 accent colors.
- **Typography, chosen deliberately, never defaulted:** a display font for headings + a highly-legible body font, fluid `clamp()` scale from h1 down to body/microcopy — no fixed px sizes with media-query breakpoint jumps. Justify the pairing in one sentence against the brand personality from Layer 0 (e.g. "a condensed industrial display face for automotive precision, paired with a humanist sans for warmth"). Self-host or load via `<link rel="preload">` with `font-display: swap`, subset to only the weights used. Reject any pairing that reads as an unexamined default.
- **Iconography is always a real icon system or custom SVG, never emoji.** Standardize on one icon library for the whole build (Lucide/Phosphor/Heroicons/Font Awesome, or bespoke SVGs matching the brand's line weight) and use it consistently — mixing icon styles (some emoji, some SVG, some inline unicode glyphs) is itself a tell of an unpolished build.
- **Every logo/brand-mark placement uses the real asset.** Business logo, payment method badges, social platform icons, certification/partner/insurance badges, "as featured on"/review-platform badges — always the actual brand SVG/PNG at correct aspect ratio and clearspace, sourced from the official brand kit when possible. Never substitute a generic icon, an emoji, or a redrawn approximation. If an asset is genuinely unavailable at build time, mark it inline as `<!-- PLACEHOLDER: needs official [X] logo asset before launch -->` and flag it to the user directly — do not let it slip into a "final" delivery unflagged.

**Signature Visual Devices (mandatory — pick and build at least 3-4 per project, don't reuse the exact ones below verbatim, adapt to the brand — this is what eliminates "shitty boxes")**
- A framing/accent treatment for high-value elements (stat blocks, forms, testimonial cards) — e.g. corner brackets, signature border animation, custom card shadow language. Every card in the build should carry this treatment or a variant of it — a plain bordered box with no brand fingerprint is a failed component, rebuild it.
- An "eyebrow" treatment above section headings that's more distinctive than plain uppercase gray text — a colored rule, an icon+line combo, a numbered tag.
- Data/metric storytelling — animated counters AND a secondary device (progress bar fill, radial gauge, ticking odometer-style number) so trust stats don't just sit static.
- Custom list/step numbering instead of default browser bullets or plain shadcn list styling.
- A recognizable, named container/card language applied consistently (e.g. "the bracket card," "the ribbon card") so that a client or reviewer could point at any card on the site and know it belongs to this brand's system specifically — genericness hides in cards that have no name.

#### Layer 2B: Motion Orchestration
- Scroll-triggered reveal (fade+slide) on every section, staggered children within a section (~0.1s stagger).
- Hover: lift + border/shadow glow (never both scale up AND lift simultaneously — pick one lift language and stay consistent).
- Button feedback: scale down (~0.95-0.97) on active/press.
- Marquee/ticker patterns for continuous-motion trust signals (service lists, client logos — real logo SVGs if it's a "trusted by" strip, never generic placeholder blocks) — must pause on hover/focus and respect reduced-motion.
- Hero parallax via scroll-linked transform (Framer Motion `useScroll`/`useTransform`) where it fits the brand tone — restrained, not gimmicky.
- **Hard rule**: animate only `transform` and `opacity` for anything running on scroll or frequently. Full `@media (prefers-reduced-motion: reduce)` fallback that collapses all durations to near-zero.

#### Layer 2C: Interactive Navigation Patterns
- Sticky/responsive navbar, mobile hamburger with a proper focus-trapped drawer (not a naive absolute-positioned div).
- "Moving tabs" pattern where relevant (services/pricing tiers, before/after toggles): use a shared-layout animated indicator (Framer Motion `layoutId`) that slides between tab positions rather than an abrupt visibility swap.
- Route transitions should never hard-flash white/unstyled between pages — use a lightweight client-side router (wouter, React Router) with a persistent app shell.

#### Layer 2D: Maps & Local Business Integration
- Embed an interactive map (Google Maps embed/iframe minimum; Mapbox/Google Maps JS API for a custom-styled map matching the brand palette when budget allows) in the footer or a dedicated location section.
- Ensure NAP (Name/Address/Phone) is identical in the footer, contact section, and any structured data — inconsistency actively hurts local SEO.
- Add a "Get Directions" CTA linking directly to Google Maps with the business's place ID/address pre-filled, using the real Google Maps/Waze logo on the button, not a generic pin emoji.
- If multi-location, build a location picker/selector pattern, not a static single map.

### Layer 3: Engineering, SEO & Performance

**Tech stack baseline** (proven in the reference build; deviate only with a reason): React + TypeScript + Vite, Tailwind v4 (`@theme inline` + OKLCH custom properties), shadcn/ui as the accessible primitive layer (never left un-customized — see Signature Visual Devices above), Framer Motion for orchestration, wouter or React Router for routing, deployed to Netlify or Vercel.

**SEO (mandatory checklist, every page)**
- Unique `<title>` and meta description per route, written for humans first (click-through, not keyword-stuffed).
- `LocalBusiness` (or more specific: `AutoRepair`, `Restaurant`, `HealthAndBeautyBusiness`, etc.) JSON-LD structured data with NAP, hours, geo-coordinates, price range, and review aggregate if available.
- Open Graph + Twitter Card meta tags with a real social preview image (never a placeholder).
- Semantic HTML landmarks (`<header>`, `<nav>`, `<main>`, `<footer>`), one `<h1>` per page, logical heading hierarchy — never skip levels for visual sizing reasons (use CSS for size, semantics for structure).
- `sitemap.xml` and `robots.txt` present and correct.
- Alt text on every image describing content/purpose, not filenames.
- Canonical URLs set to prevent duplicate-content issues.

**Mobile-first (mandatory, verify don't assume)**
- Design and build from the smallest viewport up — the mobile layout is the primary layout, desktop is the enhancement, not the reverse.
- Touch targets minimum 44x44px, adequate spacing between adjacent interactive elements.
- Test actual tap/scroll behavior — sticky elements, mobile nav drawers, and forms must be verified on a real mobile viewport (or emulated), not just assumed responsive because Tailwind classes exist.
- No horizontal scroll at any breakpoint — verify explicitly on 320px width.
- Fluid `clamp()`-based spacing/typography so there's no jarring jump at breakpoints.

**Performance targets** (match or beat the baseline)
- LCP < 2.5s, FID/INP < 100ms/200ms, CLS < 0.1.
- Images: modern format (WebP/AVIF), properly sized (no serving a 4000px image into a 400px slot), lazy-loaded below the fold, hero image preloaded.
- Fonts preloaded/subset, `font-display: swap`.
- Code-split routes; don't ship one monolithic bundle for a 4-page marketing site.

**Accessibility (mandatory, WCAG AA minimum)**
- 4.5:1 text contrast minimum — verify with the actual OKLCH values chosen, don't assume "dark theme = automatically fine."
- Focus-visible outlines on every interactive element, visible against the brand background.
- Form labels programmatically associated with inputs (not placeholder-as-label).
- Full keyboard navigation — tab order matches visual order, no keyboard traps in modals/drawers.
- `prefers-reduced-motion` fully respected (see Layer 2B).

### Layer 4: Anti-Slop Audit (run this pass explicitly, after the build looks "done" and before QA)

This layer exists solely to catch the failure modes named in the Non-Negotiables section, because they're easy to let slip in once components pile up. Go component by component, screen by screen:

1. **Emoji sweep** — grep the entire codebase for emoji characters used as icons/UI content (not inside real user-generated text like a testimonial quote). Any hit in a button, badge, stat, nav item, or feature list is a failure — replace with the real icon system from Layer 2A.
2. **Logo audit** — list every place a brand mark, payment badge, social icon, or partner/certification badge appears. Confirm each one is the real official asset, not a generic stand-in. Flag any unresolved placeholders to the user by name.
3. **Shitty-box sweep** — screenshot or mentally walk every card/container on every page. For each one, name the specific brand treatment it carries (per Layer 2A's Signature Visual Devices). If you can't name one, it's a shitty box — go back and give it the brand's card language.
4. **Template-smell check** — look at the page as a whole, zoomed out. Does the layout, section rhythm, and hero read as something that could be reskinned for a totally different business with just a color/logo swap? If yes, it's still templated — introduce asymmetry, a signature device, or a layout decision tied specifically to this brand until the answer is no.
5. **Font audit** — confirm the display/body pairing was a deliberate choice justified in Layer 0/2A, confirm both fonts are actually loading (not silently falling back to system-ui), and confirm weights/sizes match the brand's intended personality (a "premium" brand should never render its headings in a thin, generic weight by accident).

Do not proceed to Layer 5 until this audit is clean.

### Layer 5: Final QA Gate — do not report the work as complete until all of these pass:
1. `tsc --noEmit` (or equivalent typecheck) — zero errors.
2. Production build completes with zero errors.
3. Every route audited against the brand philosophy doc — including 404, empty states, loading states, form validation/error states. (This is the exact miss caught in the baseline project — the 404 page was off-brand and had to be rebuilt.)
4. Lighthouse (or equivalent) run for Performance, Accessibility, Best Practices, SEO — investigate anything below 90.
5. Manual pass at 320px, 768px, 1280px, 1920px viewports — no horizontal scroll, no overlapping/clipped content, no illegible text.
6. Every CTA click-tested — does it actually go where it claims (real phone `tel:` link, real mailto/form endpoint, real map link).
7. Layer 4's Anti-Slop Audit confirmed clean — no emoji-as-UI, no missing/fake logos, no unnamed "shitty box" cards, no template-smell, no unjustified fonts.

## Example

**User:** "Build me a website for a family-owned Italian restaurant, warm and authentic, main goal is getting people to book a table or order takeout online."

**Response shape (abbreviated):**
1. Discovery confirmed: positioning = "Third-generation family trattoria, handmade pasta, no shortcuts"; personality = Warm, Authentic, Unhurried; primary conversion goal = table reservations (secondary: takeout order link); reference styling = wants to avoid "corporate chain restaurant" look.
2. Produced `ideas.md`: Design Direction "Warm Trattoria Craft" — deep terracotta/cream OKLCH palette, hand-lettered-style display font paired with a warm serif body font, signature elements = a hand-drawn-style divider between sections, an animated "today's fresh pasta" ticker, a corner-accent frame around the reservation widget matching the baseline's bracket pattern adapted in terracotta instead of gold.
3. IA: Hero (reservation CTA above fold + "Order Takeout" secondary) → Our Story (family history, builds authenticity trust) → Menu Highlights (bento grid, not uniform) → Gallery (real food/interior photography) → Reviews (real Google review text) → Reservation/Location (embedded map, NAP-consistent footer) → Footer.
4. Built with the standard stack, `LocalBusiness`/`Restaurant` JSON-LD schema with menu/hours/geo data, mobile-first with a sticky "Reserve a Table" bar on mobile scroll, scroll-reveal + hover-lift motion matching the philosophy doc, reduced-motion respected throughout. Real icon set used for menu category markers (no fork/pizza emoji), real payment-badge logos in the footer, real Google/Yelp logos next to the review scores.
5. Layer 4 anti-slop audit run: no emoji found, every card carries the terracotta corner-accent or ribbon treatment (none left as a plain bordered box), the layout has enough asymmetry that it doesn't read as a generic restaurant template, the serif/display pairing is confirmed loading and matches the "warm, unhurried" personality.
6. Layer 5 QA gate run: typecheck clean, build clean, every route (including 404 and empty "no reviews yet" state) styled on-brand, Lighthouse ≥90 across all four categories, tested at 320/768/1280/1920px, reservation and takeout CTAs both click-verified to real endpoints.
