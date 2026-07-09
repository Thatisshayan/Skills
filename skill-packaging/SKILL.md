---
name: skill-packaging
description: Package, register, and publish a new Hermes skill from an existing reference or adapted workflow. Use when the user asks to create a skill, convert a workflow into a skill, or publish a skill to a skills repo.
---

# Skill Packaging

## Purpose
Turn a reusable workflow, reference skill, or adapted pattern into a first-class Hermes skill and make it available locally and in the configured skills repo.

## Workflow

1. Identify the source material
   - Existing skill file (`.skill` or `SKILL.md`)
   - Repo skill directory
   - User-provided description/requirements

2. Adapt and generalize the source
   - Remove hardcoded values, URLs, and brand assumptions unless explicitly required.
   - Expand applicability beyond the original domain when requested.
   - Add frontmatter: `name`, `description`, and optional `category`.
   - Keep the skill actionable: include triggers, layers, gates, or checklists.

3. Validate the skill structure
   - Confirm the skill is discoverable with `skills_list`.
   - Confirm the file path follows Hermes skill conventions.
   - Keep markdown concise and scannable.

4. Register locally
   - Write to `C:\Users\AgentDev\AppData\Local\hermes\skills\<skill-name>\SKILL.md`.
   - Verify with `skills_list` after writing.

5. Publish to the skills repo when requested
   - Copy into the skills repo working tree.
   - Stage, commit, and push.
