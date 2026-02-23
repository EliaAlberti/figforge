# CLAUDE.md — FigForge

> This file is the single source of truth for Figma design work in this project.
> Every Claude Code session and every Agent Teams teammate reads this automatically.
> All decisions, patterns, and context live here. Obey it completely.

---

## 1. Project Identity

- **Project Name:** [YOUR PROJECT NAME]
- **Description:** [WHAT ARE YOU DESIGNING]
- **Design System:** [NAME OF YOUR DESIGN SYSTEM, IF ANY]
- **Figma File(s):** [URLS TO YOUR MAIN FIGMA FILES]
- **FigJam Board(s):** [URLS TO YOUR FIGJAM BOARDS, IF ANY]
- **Repository:** [GITHUB URL]

---

## 2. Figma MCP Configuration

FigForge uses **figma-console-mcp** (by southleft) to interact with Figma.

### Mode Detection

On every session start, call `figma_get_status` to determine the active mode:

- **Local Mode (56+ tools):** Full read/write. Teammates can directly create, modify, rename, and delete elements in Figma. Requires the Desktop Bridge plugin running in Figma.
- **Remote Mode (~19 tools):** Read-only. Teammates can inspect files, extract specs, read variables. Cannot modify. Teammates generate actionable reports/plans instead.

### Critical Tool Selection Rules

These rules are NON-NEGOTIABLE. They prevent the most common failures:

| Need | Correct Tool | WRONG Tool |
|------|-------------|------------|
| Inspecting a screen/frame | `figma_get_file_data` with verbosity "full", depth 5+ | ~~figma_get_component_image~~ (only works for library components, NOT frames) |
| Getting exact measurements | `figma_get_file_data` targeting specific node IDs | ~~Reading exported PNGs~~ (PNGs are reference only) |
| Extracting design tokens | `figma_get_variables` | Manual reading |
| Visual reference screenshot | `figma_get_screenshot` | — |
| Creating new elements | `figma_create_frame`, `figma_create_text`, etc. (Local only) | — |
| Renaming layers | `figma_rename_node` (Local only) | — |
| Managing variables | `figma_create/update/rename/delete_variables` (Local only) | — |
| Connection check | `figma_get_status` | — |

### Retry Rules

- If a Figma MCP call fails, RETRY with different parameters (adjust depth, try parent node, change verbosity)
- NEVER fall back to reading PNGs for measurements
- If a Local Mode tool fails, check `figma_get_status` — you may have lost the Desktop Bridge connection
- Report persistent failures to the user

### Visual Over Structure

Some Figma designs use absolute positioning rather than auto-layout. The Figma layer structure may not reflect intended layout constraints. When interpreting designs, ALWAYS prioritize the visual output (screenshot/PNG) over the Figma node tree. The visual is the spec.

---

## 3. Agent Team Spawn Protocol

When asked to create an agent team, you MUST follow this process exactly:

1. Read the teammate template files in the appropriate `teammates/` subdirectory
2. For EACH teammate, read the FULL content of their template file
3. Use the COMPLETE template content as the spawn prompt for that teammate
4. Do NOT paraphrase, summarise, or modify the templates — pass them VERBATIM
5. Each teammate will also automatically receive this CLAUDE.md, all installed skills, and all MCP servers

Teammate template locations:
- Figma Design teammates: `~/.claude/teammates/design/`
- FigJam teammates: `~/.claude/teammates/figjam/`

---

## 4. Team Patterns

### The Figma Team (DEFAULT)
**Trigger:** "spin up the Figma team" or "Figma team"
**Spawn:**
- figma-inspector (from teammates/design/figma-inspector.md)
- figma-architect (from teammates/design/figma-architect.md)
- figma-organizer (from teammates/design/figma-organizer.md)
- figma-builder (from teammates/design/figma-builder.md)
**Use when:** Any Figma design work. This is the default — when in doubt, spin up the full team.

**Note:** If the figma-builder detects Remote Mode on startup, it will notify the user and operate in advisory/spec mode instead of direct creation. The remaining three teammates work in both modes.

### FigJam Session
**Trigger:** "spin up FigJam" or "FigJam team"
**Spawn:**
- figjam-diagrammer (from teammates/figjam/figjam-diagrammer.md)
**Use when:** Creating diagrams, flowcharts, wireframes, or workshop boards in FigJam.

### Focused Patterns (for when you know exactly what you need)

These are optional — you'll discover when they're useful over time:

| Pattern | Trigger | Teammates | When |
|---------|---------|-----------|------|
| Design Audit | "Figma audit" | inspector + architect | Read-only analysis of a file |
| Design System Sprint | "design system sprint" | architect + organizer + builder | Establishing/overhauling tokens and conventions |
| Spec Extraction | "extract specs" | inspector + architect | Preparing handoff docs for developers |

### Delegation Protocol

When the user wants a team to work on a task, the flow is:
1. User sends the trigger phrase
2. Team lead spawns teammates from templates
3. Team lead asks what to work on
4. User provides the task, ending with "Delegate this to the team"

**CRITICAL SPAWN RULES:**
- Do NOT write "Show me the plan first" — this triggers plan mode on the lead agent instead of delegating.
- Always spawn agents with full permissions. Agents must be able to read, write, and execute without waiting for permission approval.
- If the user sends a trigger phrase AND a task in the same message, STILL spawn the team first, THEN pass the task to the appropriate teammate.

**CRITICAL PERSISTENCE RULE:**
When a team is spun up, **REMAIN ON STANDBY** after each task is completed. Do NOT shut down teammates between tasks. After reporting task completion, ask the user if there are more tasks. Only shut down when the user explicitly says they are done.

---

## 5. Communication Protocol

**Non-negotiable. Applies at ALL times, to ALL teammates.**

- **ALWAYS ask the user when something is unclear.** Never guess. Never assume.
- **ALWAYS ask before making design decisions** — even if you think the answer is obvious.
- **Proactively flag risks** — surface potential issues before acting.
- **Never silently skip** a requirement. Ask for help instead.
- **Never silently "fix" design intent** — if something looks inconsistent, ask.

The goal is zero surprises.

---

## 6. Persistence Protocol

Every teammate MUST follow this on startup:
1. Run `bv --robot-triage` to get current project state
2. If Beads is not initialised, read `.sprint/progress.md` for context
3. Check the shared task list for assigned or available tasks

On task completion:
1. Verify output (screenshot, re-read file data, confirm changes applied)
2. Commit: `git add -A && git commit -m "[task-id] Brief description"`
3. Update Beads: `bd complete [task-id]`
4. Append to `.sprint/progress.md`

---

## 7. Task Sizing

- All tasks MUST be 10-15 minutes of work maximum
- Always include `time_estimate` when creating or claiming tasks
- If a task feels bigger than 15 minutes, STOP and break it down first
- One git commit per task (atomic commits)
- One page/frame cleanup = one task
- One spec extraction per screen = one task
- Variable reorganisation for one collection = one task

---

## 8. Naming Conventions

### Layer Naming
```
[Type]/[Category]/[Name]—[State]

Examples:
  Button/Primary/CTA—Default
  Button/Primary/CTA—Hover
  Button/Primary/CTA—Disabled
  Icon/Navigation/Back—24
  Card/Race/Summary—Expanded
```

### Variable Naming
```
[scope]/[category]/[property]

Examples:
  color/background/primary
  color/background/secondary
  color/text/primary
  color/brand/accent
  spacing/padding/small
  spacing/padding/medium
  radius/card/default
  typography/heading/large
```

### Component Naming
```
[Category]/[Name]

Examples:
  Buttons/Primary
  Buttons/Secondary
  Cards/ProductCard
  Navigation/TabBar
  Input/SearchField
```

These are defaults. The figma-architect can propose project-specific conventions for user approval.

---

## 9. Figma MCP Tool Reference

### Read Operations (Remote + Local)

| Tool | Purpose |
|------|---------|
| `figma_get_status` | Check connection mode and available tools |
| `figma_get_file_data` | Get node tree with full properties (THE primary tool) |
| `figma_get_variables` | List all design variables/tokens |
| `figma_get_styles` | List shared styles (colours, text, effects) |
| `figma_get_components` | List all components with properties |
| `figma_get_screenshot` | Capture visual screenshot of canvas/node |
| `figma_get_comments` | Read comment threads on the file |

### Write Operations (Local Mode ONLY — requires Desktop Bridge)

| Tool | Purpose |
|------|---------|
| `figma_create_frame` | Create frames and layouts |
| `figma_create_text` | Add text elements |
| `figma_create_rectangle` | Create shapes and backgrounds |
| `figma_create_component` | Build reusable components |
| `figma_create_instance` | Instantiate library components |
| `figma_rename_node` | Rename any layer/frame/group |
| `figma_set_properties` | Set component properties and variants |
| `figma_set_fill` | Apply colours and gradients |
| `figma_set_stroke` | Apply borders |
| `figma_set_effect` | Apply shadows and blurs |
| `figma_set_corner_radius` | Round corners |
| `figma_set_auto_layout` | Configure auto-layout |
| `figma_group_nodes` | Group related layers |
| `figma_ungroup_nodes` | Flatten unnecessary groups |
| `figma_move_node` | Reorder layers |
| `figma_create_variables` | Create new design tokens |
| `figma_update_variables` | Modify existing tokens |
| `figma_rename_variable` | Rename tokens |
| `figma_delete_variables` | Remove unused tokens |
| `figma_post_comment` | Add comments to the file |
| `figma_delete_comment` | Remove comments |

---

## 10. Skill Override Notes

<!-- Customise per project if needed -->
