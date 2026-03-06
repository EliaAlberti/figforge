<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Optimized-5A67D8?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xMiAyQzYuNDggMiAyIDYuNDggMiAxMnM0LjQ4IDEwIDEwIDEwIDEwLTQuNDggMTAtMTBTMTcuNTIgMiAxMiAyem0wIDE4Yy00LjQxIDAtOC0zLjU5LTgtOHMzLjU5LTggOC04IDggMy41OSA4IDgtMy41OSA4LTggOHoiLz48L3N2Zz4=&logoColor=white" alt="Claude Code Optimized" />
  <img src="https://img.shields.io/badge/Version-1.1.0-green?style=for-the-badge" alt="Version 1.1.0" />
  <img src="https://img.shields.io/badge/Figma-Ecosystem-F24E1E?style=for-the-badge&logo=figma&logoColor=white" alt="Figma Ecosystem" />
  <img src="https://img.shields.io/badge/Skills-8%20Available-blue?style=for-the-badge" alt="8 Skills" />
  <img src="https://img.shields.io/badge/Teammates-5-orange?style=for-the-badge" alt="5 Teammates" />
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="MIT License" />
</p>

<h1 align="center">FigForge</h1>

<p align="center">
  <strong>A unified capability layer for Claude Code's native Agent Teams, purpose-built for the Figma ecosystem.</strong>
</p>

<p align="center">
  Makes Agent Teams smarter (via skills and teammate templates) and persistent (via Beads CLI)<br/>
  for Figma Design, FigJam, and Figma Make work.
</p>

<p align="center">
  <a href="#prerequisites">Prerequisites</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#team-patterns">Teams</a> •
  <a href="#teammates">Teammates</a> •
  <a href="#skills">Skills</a> •
  <a href="#documentation">Docs</a>
</p>

---

## Prerequisites

- **Claude Code** — [code.claude.com](https://code.claude.com)
- **figma-console-mcp** — `claude mcp add figma-console -- npx -y figma-console-mcp`
  - Local Mode (full read/write): requires the [Desktop Bridge plugin](https://github.com/southleft/figma-console-mcp) running in Figma
  - Remote Mode (read-only): works without the plugin
- **Beads CLI** (optional) — `brew install beads` for cross-session persistence

---

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

---

## Quick Start

### 1. Install globally (one time)

```bash
git clone https://github.com/EliaAlberti/figforge.git
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

---

## Team Patterns

| Pattern | Trigger | Teammates |
|---------|---------|-----------|
| The Figma Team (default) | "Figma team" | inspector, architect, organizer, builder |
| FigJam Session | "FigJam team" | diagrammer |
| Design Audit | "Figma audit" | inspector, architect |
| Design System Sprint | "design system sprint" | architect, organizer, builder |
| Spec Extraction | "extract specs" | inspector, architect |

---

## Teammates

| Teammate | Role | Modes |
|----------|------|-------|
| **figma-inspector** | Extracts design specs, measurements, tokens | Remote + Local |
| **figma-architect** | Plans design systems, token hierarchies, naming conventions | Remote + Local |
| **figma-organizer** | Renames layers, enforces conventions, cleans up files | Remote (plans) + Local (executes) |
| **figma-builder** | Creates elements, components, layouts in Figma | Local only |
| **figjam-diagrammer** | Creates diagrams, flowcharts, boards in FigJam | Remote + Local |

---

## Skills

FigForge ships with **8 skills** that can be invoked standalone or by any teammate. Each skill works in Local Mode (executes directly) and falls back to structured plans in Remote Mode.

---

<details>
<summary><strong>figma-spec-extraction</strong> — Extract precise design specifications from frames</summary>

### What it does

Extracts exact measurements, colours, typography, spacing, and component properties from any Figma frame. Maps all values to design tokens and outputs a structured spec sheet ready for implementation.

### When to use

- Creating design handoff documents
- Extracting measurements for implementation
- Auditing visual consistency across screens

### Example

```
You: "Extract the full spec for the Login screen — I need exact padding,
      font sizes, colours, and which tokens are used."

figma-spec-extraction:
├── Reads frame node tree at full depth via figma_get_file_data
├── Extracts all dimensions, padding, gaps, corner radii
├── Maps fills, strokes, and effects to design tokens
├── Documents typography (family, weight, size, line-height, letter-spacing)
└── Outputs structured spec sheet:

## Screen: Login
**Frame Size:** 390 x 844

### Layout (top to bottom)
1. **Logo** — 120 x 40
   - Padding: [64, 0, 32, 0]
2. **Email Input** — 342 x 48
   - Background: color/surface/secondary (#F5F5F5)
   - Corner Radius: 12 (radius/md)
   - Font: Inter, 400, 16/24, -0.2
3. **Password Input** — 342 x 48
   - Gap from previous: 16 (spacing/md)
   ...

### Design Tokens Used
| Token                    | Value   | Usage            |
|--------------------------|---------|------------------|
| color/surface/secondary  | #F5F5F5 | Input backgrounds |
| spacing/md               | 16      | Field gap         |
| radius/md                | 12      | Input corners     |
```

</details>

---

<details>
<summary><strong>figma-layer-organization</strong> — Rename, reorganise, and clean up Figma layers</summary>

### What it does

Audits every layer in a frame or page against your naming convention, generates a rename table, and executes the renames (Local Mode) or outputs the plan (Remote Mode).

### When to use

- Preparing files for developer handoff
- Enforcing naming conventions after a design exploration phase
- Cleaning up generic names like "Frame 47" and "Rectangle 12"

### Example

```
You: "Clean up all the layer names on the Dashboard page — there are
      a bunch of 'Frame 47' and 'Rectangle 12' names."

figma-layer-organization:
├── Audits layer tree at depth 10+ via figma_get_file_data
├── Identifies generic names, inconsistent casing, unnecessary nesting
├── Generates rename table using convention [Type]/[Category]/[Name]—[State]
└── Executes renames (Local) or outputs plan (Remote):

## Layer Rename Plan — Dashboard

| Current Path                    | New Name                        | Reason     |
|---------------------------------|---------------------------------|------------|
| Frame 47 > Rectangle 12        | Card/Revenue/Background         | Convention |
| Frame 47 > Text 3              | Card/Revenue/Title              | Convention |
| Frame 47 > Text 4              | Card/Revenue/Value              | Convention |
| Group 1 > Ellipse 2            | Avatar/User/Image               | Convention |
| Frame 48                        | Section/RecentActivity          | Convention |

Applied: 23 renames, 4 groups flattened, 2 hidden layers flagged.
```

</details>

---

<details>
<summary><strong>figma-variable-management</strong> — Create, audit, and organise design tokens</summary>

### What it does

Reads all Figma variables, categorises them by type, identifies naming violations and orphaned tokens, and proposes or executes a reorganisation following the primitive > semantic > component hierarchy.

### When to use

- Building a token system from scratch
- Auditing existing variables for consistency
- Renaming tokens to follow conventions
- Cleaning up unused variables

### Example

```
You: "Audit all design variables and tell me which ones don't follow
      the primitive > semantic > component hierarchy."

figma-variable-management:
├── Reads all variables via figma_get_variables
├── Categorises by type (colour, number, string)
├── Checks naming against hierarchy convention
└── Outputs audit report:

## Variable Audit — Design Tokens

### Violations Found: 7

| Variable         | Type   | Issue                          | Suggested Name              |
|------------------|--------|--------------------------------|-----------------------------|
| blue-500         | Color  | Primitive missing prefix       | color/palette/blue-500      |
| mainBackground   | Color  | Semantic, camelCase not allowed| color/background/primary    |
| 16               | Number | Raw number, no context         | spacing/md                  |
| btnColor         | Color  | Component token, abbreviated   | button/primary/background   |

### Orphaned Variables: 3
| Variable            | Last Used |
|---------------------|-----------|
| color/old-accent    | Never     |
| spacing/legacy-sm   | Never     |
| color/test-red      | Never     |

Recommendation: Rename 7 variables, delete 3 orphans.
```

</details>

---

<details>
<summary><strong>figma-component-audit</strong> — Audit component library for consistency</summary>

### What it does

Lists every component in your library, checks naming conventions, validates variant properties are consistent across similar components, flags hardcoded values, and outputs an audit report with actionable findings.

### When to use

- Evaluating design system health
- Finding inconsistencies across components
- Preparing for a design system overhaul

### Example

```
You: "Check all my components — are the variants set up correctly?
      Are there any using hardcoded colours instead of tokens?"

figma-component-audit:
├── Lists all components via figma_get_components
├── Checks naming, variants, properties, token usage
└── Outputs audit report:

## Component Audit — 34 Components

### Naming Issues: 5
| Component        | Issue                          | Suggested          |
|------------------|--------------------------------|--------------------|
| btn-primary      | Lowercase with dash             | Button/Primary     |
| card             | Missing category                | Card/Default       |
| inputField       | camelCase not convention        | Input/Text         |

### Variant Issues: 3
| Component        | Issue                                              |
|------------------|----------------------------------------------------|
| Button/Primary   | Missing "disabled" state                            |
| Card/Product     | "size" property inconsistent with Card/Profile      |
| Input/Text       | No "error" variant (Input/Password has one)         |

### Hardcoded Values: 8
| Component        | Property   | Value   | Should Be                |
|------------------|------------|---------|--------------------------|
| Button/Primary   | Fill       | #E10600 | color/brand/accent       |
| Card/Product     | Radius     | 12      | radius/md                |
| Tag/Default      | Padding    | 8, 16   | spacing/sm, spacing/md   |

Health Score: 72/100 — Good foundation, needs token migration.
```

</details>

---

<details>
<summary><strong>figma-design-handoff</strong> — Prepare files for developer handoff</summary>

### What it does

The "preflight checklist" that orchestrates multiple other skills to produce a complete handoff package. Runs layer naming compliance, token documentation, component audit, spec extraction, asset inventory, and state/variant documentation.

### When to use

- Preparing designs for developer implementation
- Final review before development begins
- Creating handoff documentation

### Example

```
You: "This design is ready for dev. Run the full handoff prep —
      naming, tokens, specs, assets, everything."

figma-design-handoff:
├── Step 1: Layer organisation (figma-layer-organization)
│   └── ✓ 47 layers renamed, 0 issues remaining
├── Step 2: Token audit (figma-variable-management)
│   └── ✓ 28 tokens documented, 2 orphans flagged
├── Step 3: Component audit (figma-component-audit)
│   └── ⚠ 3 components missing disabled state
├── Step 4: Spec extraction per screen (figma-spec-extraction)
│   ├── ✓ Login — 24 elements documented
│   ├── ✓ Dashboard — 52 elements documented
│   └── ✓ Settings — 31 elements documented
├── Step 5: Asset inventory
│   ├── icon-arrow.svg (24x24)
│   ├── icon-settings.svg (24x24)
│   ├── logo-full.svg (120x40)
│   └── avatar-placeholder.png (48x48)
└── Step 6: States & variants
    └── ✓ 12 components, 38 states documented

Handoff package ready. 1 warning: 3 components need disabled states.
```

</details>

---

<details>
<summary><strong>figjam-diagramming</strong> — Create diagrams and boards in FigJam</summary>

### What it does

Creates diagrams, flowcharts, wireframes, and workshop boards directly in FigJam. Supports flowcharts, architecture diagrams, wireframes, and workshop/brainstorm boards.

### When to use

- Visualising processes, flows, or architectures
- Creating wireframes for early-stage exploration
- Setting up workshop or brainstorm boards

### Example

```
You: "Create a user journey flowchart in FigJam for our onboarding flow:
      sign up > verify email > choose plan > setup workspace > invite team."

figjam-diagramming:
├── Clarifies scope: linear flow, 5 steps, include decision points?
├── Creates in FigJam (Local Mode):
│   ├── Start node: "User lands on site"
│   ├── Step 1: "Sign Up" (form details)
│   ├── Step 2: "Verify Email"
│   │   └── Decision: "Email verified?"
│   │       ├── Yes → continue
│   │       └── No → "Resend email" (loops back)
│   ├── Step 3: "Choose Plan" (Free / Pro / Enterprise)
│   ├── Step 4: "Setup Workspace" (name, avatar, settings)
│   ├── Step 5: "Invite Team" (optional skip)
│   └── End node: "Dashboard — onboarding complete"
├── Adds connectors with labels between all nodes
├── Screenshots for verification
└── Outputs Mermaid fallback if Remote Mode:

    graph TD
        A[Sign Up] --> B[Verify Email]
        B -->|Verified| C[Choose Plan]
        B -->|Not Verified| B2[Resend Email] --> B
        C --> D[Setup Workspace]
        D --> E[Invite Team]
        E --> F[Dashboard]
```

</details>

---

<details>
<summary><strong>figma-componentize</strong> — Convert flat designs into reusable components</summary>

### What it does

Analyses a Figma frame to identify repeated and reusable elements, plans a bottom-up component hierarchy (atoms > molecules > organisms), cross-references existing components to avoid duplication, creates components with proper variant properties, and optionally exports elements as SVG.

### When to use

- Converting flat/one-off designs into reusable components
- Building a component library from existing screens
- Extracting repeated patterns into component sets with variants
- Exporting design elements as SVG assets

### Example

```
You: "Look at this Product Card frame — there are 6 variations across the file.
      Turn it into a proper component set with size and state variants,
      and export the icon elements as SVG."

figma-componentize:
├── Analyses frame at depth 10+ via figma_get_file_data
├── Identifies repeated elements across file:
│   ├── ProductCard — 6 instances (3 sizes × 2 states)
│   ├── PriceTag — 12 instances (reused in cards + lists)
│   ├── StarRating — 8 instances
│   └── CartIcon — 6 instances
│
├── Cross-references existing components:
│   └── StarRating already exists as component — skip
│
├── Plans hierarchy:
│   ├── Atoms:     PriceTag, CartIcon (new)
│   ├── Molecules: ProductCard (new component set)
│   └── Existing:  StarRating (reuse)
│
├── Creates components (Local Mode):
│   ├── PriceTag
│   │   └── Properties: hasDiscount (bool), currency (text)
│   ├── CartIcon
│   │   └── Properties: state (default/active)
│   └── ProductCard (component set)
│       ├── Variants: size (sm/md/lg), state (default/hover)
│       ├── Properties: hasRating (bool), showCartIcon (bool)
│       └── Uses: PriceTag, StarRating (existing), CartIcon
│
├── SVG export:
│   ├── cart-icon-default.svg (24x24)
│   └── cart-icon-active.svg (24x24)
│
└── Output:

## Created Components
| Name          | Type     | Variants              | Tokens Used | SVG |
|---------------|----------|-----------------------|-------------|-----|
| PriceTag      | Atom     | —                     | 4           | No  |
| CartIcon      | Atom     | state: default/active | 2           | Yes |
| ProductCard   | Molecule | size × state (6)      | 12          | No  |
```

</details>

---

<details>
<summary><strong>figma-auto-layout</strong> — Intelligently apply auto-layout to existing frames</summary>

### What it does

Screenshots the frame as ground truth, analyses child positions to detect layout patterns (vertical stacks, horizontal rows, grids, wrap), matches spacing to design tokens, then applies auto-layout inside-out — deepest children first. Overlapping elements are preserved as absolute-positioned. Before/after screenshot comparison ensures zero visual regression.

### When to use

- Retrofitting auto-layout onto flat/absolute-positioned designs
- Making static mockups responsive
- Cleaning up frame structure for developer handoff
- Preparing designs for component extraction

### Example

```
You: "This landing page was designed with absolute positioning.
      Apply auto-layout everywhere it makes sense so it's responsive."

figma-auto-layout:
├── Screenshots frame as ground truth (before)
├── Analyses child positions at depth 10+:
│   ├── Header:    children share Y=0, increasing X → Horizontal
│   ├── HeroText:  children share X=24, increasing Y → Vertical
│   ├── FeatureRow: 3 cards share Y=400, equal X spacing → Horizontal
│   ├── CardInner:  icon + title + desc stacked → Vertical
│   └── FloatingBadge: overlaps HeroImage → Leave absolute
│
├── Matches spacing to tokens:
│   ├── 15px gap → spacing/md (16px) — rounded (1px diff)
│   ├── 24px padding → spacing/lg (24px) — exact match
│   └── 7px gap → flagged as ambiguous, asking user
│
├── Applies auto-layout inside-out (Local Mode):
│   ├── Step 1: CardInner (Vertical, gap=12, pad=16)
│   ├── Step 2: FeatureRow (Horizontal, gap=24, pad=0)
│   ├── Step 3: HeroText (Vertical, gap=16, pad=24)
│   ├── Step 4: Header (Horizontal, gap=0, space-between, pad=24)
│   ├── Step 5: Page (Vertical, gap=64, pad=0)
│   └── Skip: FloatingBadge → absolute positioning preserved
│
├── Screenshots frame (after) — compares with before
│   └── ✓ No visual shift detected
│
└── Output:

## Auto-Layout Applied — Landing Page

### Changes
| Node        | Direction  | Gap             | Padding         | Sizing     |
|-------------|------------|-----------------|-----------------|------------|
| CardInner   | Vertical   | 12 (spacing/sm) | 16 all (sp/md)  | Fill-width |
| FeatureRow  | Horizontal | 24 (spacing/lg) | 0               | Fill-width |
| HeroText    | Vertical   | 16 (spacing/md) | 24 all (sp/lg)  | Fill-width |
| Header      | Horizontal | space-between   | 24 H (spacing/lg)| Fill-width |
| Page        | Vertical   | 64 (spacing/3xl)| 0               | Fixed 1440 |

### Left As-Is
| Node          | Reason                              |
|---------------|-------------------------------------|
| FloatingBadge | Intentional overlap on hero image   |

### Spacing Normalised
| Node       | Original | Normalised | Token      |
|------------|----------|------------|------------|
| FeatureRow | 15px     | 16px       | spacing/md |
```

</details>

---

## Documentation

| Document | Purpose |
|----------|---------|
| [How It Works](docs/how-it-works.md) | Architecture deep dive |
| [Usage Guide](docs/usage-guide.md) | Practical walkthroughs |
| [Team Patterns](docs/team-patterns.md) | All team compositions |
| [Figma MCP Reference](docs/figma-mcp-reference.md) | Complete tool reference |

---

## Project Structure

```
figforge/
├── CLAUDE.md               # Project brain (loaded every session)
├── README.md               # This file
│
├── templates/              # CLAUDE.md template + verify.sh + sprint config
├── teammates/
│   ├── design/             # 4 Figma Design teammates
│   │   ├── figma-inspector.md
│   │   ├── figma-architect.md
│   │   ├── figma-organizer.md
│   │   └── figma-builder.md
│   └── figjam/             # 1 FigJam teammate
│       └── figjam-diagrammer.md
├── skills/                 # 8 self-contained skills
│   ├── figma-spec-extraction/
│   ├── figma-layer-organization/
│   ├── figma-variable-management/
│   ├── figma-component-audit/
│   ├── figma-design-handoff/
│   ├── figma-componentize/
│   ├── figma-auto-layout/
│   └── figjam-diagramming/
├── persistence/            # Beads + sprint + task sizing docs
├── scripts/                # install.sh + init-project.sh
└── docs/                   # Documentation files
```

---

## License

MIT

---

<p align="center">
  <strong>Structure transforms Figma collaboration from chaos to design system excellence.</strong>
</p>
