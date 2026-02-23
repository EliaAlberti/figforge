# How FigForge Works

## The Three-Layer Architecture

FigForge follows a three-layer architecture where each layer builds on the one below:

### Layer 1: CLAUDE.md (The Brain)

Every Claude Code session — whether solo or as part of an Agent Team — automatically reads `CLAUDE.md` from the project root. This single file contains:

- **Project identity** — what you're designing, which Figma files to work with
- **Figma MCP configuration** — tool selection rules, retry behaviour, mode detection
- **Team spawn protocol** — how to read and use teammate templates
- **Team patterns** — trigger phrases and teammate compositions
- **Communication protocol** — zero-surprises policy
- **Persistence protocol** — Beads CLI integration
- **Task sizing** — 10-15 minute atomic task rule
- **Naming conventions** — layer, variable, and component naming standards
- **Tool reference** — complete figma-console-mcp tool list

### Layer 2: Capabilities

Three capability types sit on top of CLAUDE.md:

**Teammate Templates** (`~/.claude/teammates/`)
- Markdown files that define each teammate's role, tools, workflow, and communication patterns
- The team lead reads these files verbatim and uses them as spawn prompts
- 4 design teammates + 1 FigJam teammate

**Skills** (`~/.claude/skills/`)
- Domain-specific expertise loaded into every session
- 6 skills covering spec extraction, layer organization, variable management, component audits, design handoff, and FigJam diagramming

**Persistence** (Beads CLI + Sprint tracking)
- Beads CLI (`bd`, `bv`) provides cross-session memory
- `.sprint/` directory tracks progress within a session
- Every teammate queries Beads on startup for project context

### Layer 3: Agent Teams (Native Claude Code)

Claude Code's native Agent Teams handles all multi-agent mechanics:
- Spawning teammates from templates
- Direct teammate-to-teammate communication (no relay through lead)
- Shared task list for coordination
- MCP server access (figma-console-mcp) for all teammates

## The Figma MCP Connection

FigForge interacts with Figma through **figma-console-mcp** (by southleft), which has two modes:

### Local Mode (56+ tools)
- Requires the Desktop Bridge plugin running in Figma
- Full read/write access — teammates can create, modify, rename, delete elements directly
- All 5 teammates operate at full capability

### Remote Mode (~19 tools)
- Read-only access via Figma's REST API
- Teammates can inspect, extract specs, audit — but cannot modify
- The figma-builder switches to advisory/spec mode
- The figma-organizer generates plans instead of executing

Every teammate calls `figma_get_status` on startup to detect the active mode and adjust behaviour accordingly.

## Data Flow

```
User: "Spin up the Figma team"
  │
  ▼
Lead reads CLAUDE.md (auto-loaded)
  │
  ▼
Lead reads 4 teammate template files from ~/.claude/teammates/design/
  │
  ▼
Lead spawns 4 teammates with verbatim template content
  │
  ▼
Each teammate:
  1. Receives CLAUDE.md + skills + MCP servers automatically
  2. Runs bv --robot-triage for project context
  3. Calls figma_get_status to detect mode
  4. Checks shared task list for assigned work
  │
  ▼
User provides a task → Lead delegates to appropriate teammate(s)
  │
  ▼
Teammates work, communicate directly, update shared task list
  │
  ▼
On completion: verify → commit → update Beads → REMAIN ON STANDBY
```

## Why This Architecture?

1. **CLAUDE.md is the single source of truth** — no scattered config files
2. **Templates are portable** — install once, use in any project
3. **Skills provide domain expertise** — without bloating CLAUDE.md
4. **Beads provides memory** — teammates know what happened last session
5. **Native Agent Teams** — no custom orchestration code to maintain
6. **Mode-aware** — graceful degradation from Local to Remote mode
