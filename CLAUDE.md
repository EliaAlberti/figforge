# CLAUDE.md — FigForge Repository

> This file is for developing FigForge itself. It is NOT the template CLAUDE.md
> that gets copied into projects — that lives at `templates/CLAUDE.md`.

## Repository Structure

```
figforge/
├── templates/          ← CLAUDE.md template + verify.sh + sprint config
├── teammates/
│   ├── design/         ← 4 Figma Design teammate templates
│   └── figjam/         ← 1 FigJam teammate template
├── skills/             ← 6 skills (one SKILL.md each)
├── persistence/        ← Beads + sprint + task sizing docs
├── scripts/            ← install.sh + init-project.sh
└── docs/               ← Documentation files
```

## Development Rules

- **No iOS references** — this is a Figma-only framework
- **No marketing content** — that belongs in SwiftForge
- **Every teammate must handle Remote Mode gracefully** — Local Mode is not guaranteed
- **Templates are verbatim** — they get passed as spawn prompts without modification
- **Skills are self-contained** — each SKILL.md must work independently

## Testing Changes

After editing templates or teammates, verify with:
```bash
bash scripts/install.sh   # Reinstall globally
```
Then test in a project with `"spin up the Figma team"`.
