# FigForge

A unified capability layer for Claude Code's native Agent Teams, purpose-built for the Figma ecosystem. Makes Agent Teams smarter (via skills and teammate templates) and persistent (via Beads CLI) for Figma Design, FigJam, and Figma Make work.

## Prerequisites

- **Claude Code** — [code.claude.com](https://code.claude.com)
- **figma-console-mcp** — `claude mcp add figma-console -- npx -y figma-console-mcp`
  - Local Mode (full read/write): requires the [Desktop Bridge plugin](https://github.com/southleft/figma-console-mcp) running in Figma
  - Remote Mode (read-only): works without the plugin
- **Beads CLI** (optional) — `brew install beads` for cross-session persistence

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LAYER 1: CLAUDE.md (The Brain)                    │
│  Auto-loaded by every session and every teammate.                    │
│  Contains: spawn protocol, team patterns, rules, persistence config  │
└─────────────────────────────────┬───────────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        ▼                         ▼                         ▼
┌───────────────┐     ┌───────────────────┐     ┌───────────────────┐
│  LAYER 2:     │     │  LAYER 2:         │     │  LAYER 2:         │
│  Teammate     │     │  Skills           │     │  Persistence      │
│  Templates    │     │  (auto-loaded)    │     │  (Beads + Sprint) │
│               │     │                   │     │                   │
│  Lead reads   │     │  6 Figma skills   │     │  Beads CLI (bd)   │
│  these files  │     │                   │     │  Beads-Viewer(bv) │
│  and uses as  │     │                   │     │  .sprint/ dir     │
│  spawn prompts│     │                   │     │  verify.sh        │
└───────────────┘     └───────────────────┘     └───────────────────┘
        │                         │                         │
        └─────────────────────────┼─────────────────────────┘
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│              LAYER 3: Agent Teams (Native Claude Code)               │
│  Lead spawns teammates → each gets CLAUDE.md + MCP + skills          │
│  Teammates communicate directly with each other                      │
│  Shared task list for coordination                                   │
│  figma-console-mcp for all Figma operations                         │
└─────────────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Install globally (one time)

```bash
git clone https://github.com/YOUR_USER/figforge.git
cd figforge
bash scripts/install.sh
```

### 2. Initialise a project

```bash
cd your-figma-project
bash path/to/figforge/scripts/init-project.sh
```

### 3. Spin up a team

```bash
claude
```

Then say: **"Spin up the Figma team"**

## Team Patterns

| Pattern | Trigger | Teammates |
|---------|---------|-----------|
| The Figma Team (default) | "Figma team" | inspector, architect, organizer, builder |
| FigJam Session | "FigJam team" | diagrammer |
| Design Audit | "Figma audit" | inspector, architect |
| Design System Sprint | "design system sprint" | architect, organizer, builder |
| Spec Extraction | "extract specs" | inspector, architect |

## Teammates

| Teammate | Role | Modes |
|----------|------|-------|
| figma-inspector | Extracts design specs, measurements, tokens | Remote + Local |
| figma-architect | Plans design systems, token hierarchies, naming conventions | Remote + Local |
| figma-organizer | Renames layers, enforces conventions, cleans up files | Remote (plans) + Local (executes) |
| figma-builder | Creates elements, components, layouts in Figma | Local only |
| figjam-diagrammer | Creates diagrams, flowcharts, boards in FigJam | Remote + Local |

## Skills

| Skill | Purpose |
|-------|---------|
| figma-spec-extraction | Extract precise design specs from frames |
| figma-layer-organization | Rename and clean up Figma layers |
| figma-variable-management | Create, audit, and organise design tokens |
| figma-component-audit | Audit component library for consistency |
| figma-design-handoff | Prepare files for developer handoff |
| figjam-diagramming | Create diagrams and boards in FigJam |

## Documentation

- [How It Works](docs/how-it-works.md) — Architecture deep dive
- [Usage Guide](docs/usage-guide.md) — Practical walkthroughs
- [Team Patterns](docs/team-patterns.md) — All team compositions
- [Figma MCP Reference](docs/figma-mcp-reference.md) — Complete tool reference

## License

MIT
