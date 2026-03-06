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
│  Lead reads   │     │  8 Figma skills   │     │  Beads CLI (bd)   │
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

FigForge ships with 8 skills that can be invoked standalone or by any teammate.

### figma-spec-extraction

Extract precise design specifications from Figma frames — measurements, colours, typography, spacing, and component properties.

**Example:**
> "Extract the full spec for the Login screen in my Figma file — I need exact padding, font sizes, colours, and which tokens are used."

The skill reads the frame's node tree at full depth, extracts every dimension, maps values to design tokens, and outputs a structured spec sheet ready for implementation.

---

### figma-layer-organization

Rename, reorganise, and clean up Figma layers to follow naming conventions and prepare files for handoff.

**Example:**
> "Clean up all the layer names on the Dashboard page — there are a bunch of 'Frame 47' and 'Rectangle 12' names that need proper labels."

The skill audits every layer against your naming convention (e.g., `[Type]/[Category]/[Name]—[State]`), generates a rename table, and executes in Local Mode or outputs the plan in Remote Mode.

---

### figma-variable-management

Create, audit, rename, and organise Figma design variables and tokens. Build or maintain a full token system.

**Example:**
> "Audit all design variables in this file and tell me which ones don't follow the primitive > semantic > component hierarchy."

The skill reads all variables, categorises them by type, identifies naming violations and orphaned tokens, and proposes a reorganisation plan with proper hierarchy.

---

### figma-component-audit

Audit your Figma component library for consistency, completeness, and proper variant setup.

**Example:**
> "Check all my components — are the variants set up correctly? Are there any using hardcoded colours instead of tokens?"

The skill lists every component, checks naming conventions, validates variant properties are consistent across similar components, flags hardcoded values, and outputs an audit report with actionable findings.

---

### figma-design-handoff

Prepare Figma files for developer handoff — the "preflight checklist" that orchestrates multiple other skills.

**Example:**
> "This design is ready for dev. Run the full handoff prep — naming, tokens, specs, assets, everything."

The skill runs a complete checklist: layer naming compliance, token documentation, component audit, spec extraction for each screen, asset inventory, and state/variant documentation. Outputs a handoff package.

---

### figjam-diagramming

Create diagrams, flowcharts, wireframes, and workshop boards in FigJam.

**Example:**
> "Create a user journey flowchart in FigJam for our onboarding flow: sign up > verify email > choose plan > setup workspace > invite team."

The skill creates the diagram directly in FigJam (Local Mode) with proper shapes, connectors, and labels, or generates a Mermaid/text representation in Remote Mode. Supports flowcharts, architecture diagrams, wireframes, and workshop boards.

---

### figma-componentize

Convert flat designs into fully-fledged, reusable components and component sets, with optional SVG export.

**Example:**
> "Look at this Product Card frame — there are 6 variations of it across the file. Turn it into a proper component set with size and state variants, and export the icon elements as SVG."

The skill analyses the frame to identify repeated elements, plans a bottom-up component hierarchy (atoms > molecules > organisms), cross-references existing components to avoid duplication, creates components with proper variant properties, and optionally exports elements as SVG. In Remote Mode, it outputs a detailed componentization plan.

---

### figma-auto-layout

Intelligently apply auto-layout to existing Figma frame contents where applicable, turning static mockups into responsive, structured designs.

**Example:**
> "This landing page was designed with absolute positioning. Apply auto-layout everywhere it makes sense so it's responsive and clean for handoff."

The skill screenshots the frame as ground truth, analyses child positions to detect vertical stacks, horizontal rows, grids, and wrap layouts, matches spacing to design tokens (rounding within 2px tolerance), then applies auto-layout inside-out — deepest children first. Overlapping elements are preserved as absolute-positioned. A before/after screenshot comparison ensures zero visual regression. In Remote Mode, it outputs a full auto-layout plan with node IDs and recommended properties.

## Documentation

- [How It Works](docs/how-it-works.md) — Architecture deep dive
- [Usage Guide](docs/usage-guide.md) — Practical walkthroughs
- [Team Patterns](docs/team-patterns.md) — All team compositions
- [Figma MCP Reference](docs/figma-mcp-reference.md) — Complete tool reference

## License

MIT
