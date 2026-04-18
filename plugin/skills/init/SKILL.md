---
name: init
description: "Initialise a project with FigForge — creates or appends to CLAUDE.md with team patterns, spawn protocol, and Figma MCP tool rules. Safe to run on existing projects (appends, never overwrites)."
---

# FigForge Init

## When to Use

- Setting up FigForge in a new Figma project
- Adding FigForge capabilities to an existing project without overwriting its CLAUDE.md
- Enabling team patterns like "spin up the Figma team" or "create a prototype"

## What This Skill Does

This skill configures the current project to use FigForge's agent team by:
1. Creating a `CLAUDE.md` (if none exists) OR appending a FigForge section to an existing one
2. Creating `.sprint/` directory for sprint tracking
3. Initialising Beads (if installed)
4. NOT overwriting any existing content

## Process

### 1. Check for existing CLAUDE.md

```bash
ls CLAUDE.md 2>/dev/null
```

- If exists: append the FigForge section (do NOT overwrite)
- If not: create a new CLAUDE.md with the full template

### 2. Gather project details

Ask the user (only ask what's missing if they've already shared context):

- **Project Name** (required) — e.g., "My App"
- **Description** (required) — one line, e.g., "Mobile app UI design"
- **Figma File URL(s)** (required) — e.g., `https://figma.com/design/abc123/MyApp`
- **Design System name** (optional) — skip if not applicable
- **FigJam Board URL(s)** (optional) — skip if not applicable
- **GitHub Repo URL** (optional) — skip if not applicable

### 3. Build the FigForge section

Create this content to append or write as new CLAUDE.md:

```markdown
# [PROJECT NAME] — FigForge Configuration

## Project Identity

- **Project Name:** [PROJECT_NAME]
- **Description:** [DESCRIPTION]
- **Figma File(s):** [FIGMA_URLS]
- **Design System:** [DESIGN_SYSTEM or "—"]
- **FigJam Board(s):** [FIGJAM_URLS or "—"]
- **Repository:** [REPO_URL or "—"]

## Figma MCP Configuration

FigForge uses **figma-console-mcp** (by southleft) for Figma operations.

On every session start, call `figma_get_status` to determine mode:
- **Local Mode:** Full read/write. Agents can create, modify, rename, delete.
- **Remote Mode:** Read-only. Agents inspect files and generate plans.

### Critical Tool Selection Rules

| Need | Correct Tool | WRONG Tool |
|------|-------------|------------|
| Inspecting a frame | `figma_get_file_data` verbosity "full", depth 5+ | ~~figma_get_component_image~~ (components only, not frames) |
| Exact measurements | `figma_get_file_data` with node IDs | ~~PNG screenshots~~ (reference only) |
| Design tokens | `figma_get_variables` | Manual reading |
| Creating elements | `figma_create_frame`, `figma_create_text`, etc. (Local only) | — |
| Prototype connections | `figma_execute` with `setReactionsAsync` (Local only) | — |
| Connection check | `figma_get_status` | — |

### Retry Rules

- On failure, retry with different parameters (depth, node, verbosity)
- NEVER fall back to PNGs for measurements
- If Local tool fails, check `figma_get_status` — Desktop Bridge may have disconnected
- Report persistent failures to the user

### Visual Over Structure

When Figma designs use absolute positioning, the layer structure may not reflect layout intent. ALWAYS prioritise the visual screenshot over the node tree. The visual is the spec.

## Agent Team Spawn Protocol

FigForge agents are provided by the FigForge plugin. Available agents:

- **figma-inspector** — Extracts specs, measurements, tokens
- **figma-architect** — Plans design systems, token hierarchies, conventions
- **figma-organizer** — Renames layers, enforces conventions, cleans files
- **figma-builder** — Creates elements, components, layouts (Local Mode only)
- **figma-prototyper** — Creates interactive prototypes and flows (Local Mode only)
- **figjam-diagrammer** — Creates diagrams and boards in FigJam

When user triggers a team pattern, use the Agent tool to spawn the listed agents.

## Team Patterns

### The Figma Team (DEFAULT)

**Trigger:** "spin up the Figma team" or "Figma team"
**Spawn:** figma-inspector, figma-architect, figma-organizer, figma-builder
**Use for:** Any Figma design work

### FigJam Session

**Trigger:** "spin up FigJam" or "FigJam team"
**Spawn:** figjam-diagrammer
**Use for:** Creating diagrams, flowcharts, wireframes, or workshop boards

### Focused Patterns

| Pattern | Trigger | Agents | When |
|---------|---------|--------|------|
| Design Audit | "Figma audit" | inspector + architect | Read-only analysis |
| Design System Sprint | "design system sprint" | architect + organizer + builder | Tokens and conventions |
| Spec Extraction | "extract specs" | inspector + architect | Developer handoff docs |
| Prototype Sprint | "create prototype" | inspector + prototyper | Interactive prototypes for testing |

### Delegation Protocol

1. User sends a trigger phrase
2. Spawn all listed agents in parallel
3. Ask user what to work on
4. User provides task, ending with "Delegate this to the team"

**Critical rules:**
- Spawn agents with full permissions
- After task completion, keep agents on standby (don't shut down)
- Only shut down when user says they're done

## Communication Protocol

Non-negotiable. Applies to ALL agents:

- **ALWAYS ask when unclear** — never guess
- **ALWAYS ask before design decisions** — even obvious ones
- **Proactively flag risks** before acting
- **Never silently skip** a requirement
- **Never silently "fix" design intent** — if inconsistent, ask

Goal: zero surprises.

## Persistence Protocol

Every agent MUST on startup:
1. Run `bv --robot-triage` for project state (if Beads installed)
2. Otherwise read `.sprint/progress.md`
3. Check shared task list

On task completion:
1. Verify output (screenshot, re-read file data)
2. Commit: `git add -A && git commit -m "[task-id] Brief description"`
3. Update Beads: `bd complete [task-id]`
4. Append to `.sprint/progress.md`

## Task Sizing

- Max 10-15 minutes per task
- One git commit per task
- Break down anything larger

## Naming Conventions

### Layers
`[Type]/[Category]/[Name]—[State]`
Examples: `Button/Primary/CTA—Default`, `Card/Product/Summary—Expanded`

### Variables
`[scope]/[category]/[property]`
Examples: `color/background/primary`, `spacing/padding/medium`

### Components
`[Category]/[Name]`
Examples: `Buttons/Primary`, `Cards/ProductCard`

The figma-architect may propose project-specific conventions.
```

### 4. Write or append

- If CLAUDE.md does NOT exist: write the above as the entire file
- If CLAUDE.md EXISTS: append the above to the end, with a clear divider (`---`) above it

### 5. Create supporting files

```bash
mkdir -p .sprint

# Only create progress.md if not exists
if [ ! -f ".sprint/progress.md" ]; then
  echo "# Sprint Progress

**Started:** $(date +%Y-%m-%d)

---
" > .sprint/progress.md
fi

# Initialize Beads if available
command -v bd >/dev/null 2>&1 && [ ! -d ".beads" ] && bd init 2>/dev/null || true
```

### 6. Confirm and next steps

Tell the user:
- What was created or appended
- What to do next: "Open Claude Code and say 'spin up the Figma team'"
- If they chose to add to existing CLAUDE.md, remind them to review the appended section

## Rules

- **NEVER overwrite an existing CLAUDE.md** — always append
- **ASK for required fields** — don't fabricate values
- **SKIP optional fields** if the user doesn't provide them — don't fill with placeholders
- **SHOW DIFF** if appending to existing CLAUDE.md — user should see what's being added
- **NO destructive operations** — this skill only adds files, never removes
