# 🧠 SKILLS — Claude AI Skills Library

A curated library of custom Claude skills for legal analysis, case preparation, and professional workflows.

## 📁 Skill Index

| Skill | Description | Status |
|---|---|---|
| `ontario-employment-law/` | Ontario ESA analysis, employee status testing, wage calculations, claim preparation | ✅ v1.0 |

## 🚀 How To Use

Each skill folder contains:
- `SKILL.md` — the skill definition (install this in your Claude project)
- `references/` — deep-dive reference files Claude loads when needed

## 📦 Installing a Skill

1. Copy the skill folder into your Claude Project's skills directory
2. The skill description in `SKILL.md` frontmatter tells Claude when to trigger it
3. Claude will automatically reference the skill for matching tasks

## 🤝 Adding New Skills

Each new skill gets its own folder. Follow the structure of existing skills.
Name: short-kebab-case
Required: SKILL.md with frontmatter (name + description)
Optional: references/ folder for deep content
