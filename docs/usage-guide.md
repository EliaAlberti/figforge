# Usage Guide

## First-Time Setup

### 1. Install FigForge

```bash
git clone https://github.com/YOUR_USER/figforge.git
cd figforge
bash scripts/install.sh
```

This installs teammate templates and skills globally to `~/.claude/`.

### 2. Install figma-console-mcp

```bash
claude mcp add figma-console -- npx -y figma-console-mcp
```

For Local Mode (full read/write), install the Desktop Bridge plugin in Figma:
1. Open Figma Desktop
2. Plugins > Development > Import plugin from manifest
3. Point to the figma-console-mcp plugin directory

### 3. Initialise Your Project

```bash
cd your-figma-project
bash path/to/figforge/scripts/init-project.sh
```

This creates:
- `CLAUDE.md` — edit this with your project details
- `.sprint/` — sprint tracking directory
- `scripts/verify.sh` — verification script

### 4. Edit CLAUDE.md

Fill in the Project Identity section with your project details:
```markdown
- **Project Name:** My App
- **Description:** Mobile app UI design and prototyping
- **Design System:** My App DS (if applicable)
- **Figma File(s):** https://figma.com/file/abc123/My-App
- **FigJam Board(s):** https://figma.com/board/xyz789/Planning (if applicable)
- **Repository:** https://github.com/myuser/my-app (if applicable)
```

Only the **Project Name**, **Description**, and **Figma File(s)** are required. The rest are optional — FigForge works for any kind of Figma project: app design, marketing assets, illustrations, prototypes, presentations, or design systems.

## Daily Workflows

### Design Audit

**Trigger:** "Spin up a Figma audit"

This spawns the inspector + architect for read-only analysis:
- Inspector extracts specs from target screens
- Architect identifies inconsistencies and proposes improvements

**Example:**
```
You: Spin up a Figma audit
Lead: [spawns inspector + architect]
Lead: What would you like audited?
You: Audit the onboarding screens for token consistency. Delegate this to the team.
```

### Design System Sprint

**Trigger:** "Spin up a design system sprint"

This spawns architect + organizer + builder for design system work:
- Architect defines token architecture and naming conventions
- Organizer renames layers and variables to match
- Builder creates new components following the conventions

### Spec Extraction for Developers

**Trigger:** "Extract specs"

This spawns inspector + architect for handoff preparation:
- Inspector extracts precise measurements from each screen
- Architect documents token usage and component relationships

### Full Figma Team

**Trigger:** "Spin up the Figma team"

The default — spawns all 4 design teammates for any Figma work.

### FigJam Session

**Trigger:** "Spin up FigJam"

Spawns the diagrammer for creating flowcharts, wireframes, or workshop boards.

## Working with Modes

### Local Mode (Desktop Bridge active)

All teammates work at full capability:
- Inspector reads specs
- Architect creates/modifies tokens
- Organizer renames layers directly
- Builder creates components and layouts

### Remote Mode (no Desktop Bridge)

Teammates adapt automatically:
- Inspector reads specs (unchanged)
- Architect reads tokens, proposes changes in docs
- Organizer generates rename plans (tables) for manual execution
- Builder notifies user and outputs detailed specs instead

You'll see a notification at startup if a teammate detects Remote Mode.

## Task Flow

1. **Trigger a team pattern** — e.g., "spin up the Figma team"
2. **Provide a task** — describe what you need, end with "Delegate this to the team"
3. **Teammates work** — they communicate directly with each other
4. **Review and approve** — teammates share screenshots and proposals for your approval
5. **More tasks or done** — team stays on standby until you say you're done

## Tips

- **Be specific about Figma files** — include URLs when possible
- **One task at a time** — let the team complete before giving the next task
- **Trust the spec, not the PNG** — specs come from `figma_get_file_data`, not screenshots
- **Approve design decisions** — the architect will always ask before implementing
- **Use sprint tracking** — check `.sprint/progress.md` to see what was done
