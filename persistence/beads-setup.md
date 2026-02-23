# Beads Setup for FigForge

Beads provides cross-session persistence for FigForge agent teams.

## Install

```bash
# Install Beads CLI
brew install beads

# Install Beads Viewer
brew install beads-viewer
```

## Initialise in a project

```bash
cd your-figma-project
bd init
```

## Key Commands

| Command | Purpose |
|---------|---------|
| `bv --robot-triage` | Full project overview (every teammate runs this on startup) |
| `bv --robot-next` | Next task recommendation |
| `bv --robot-plan` | Planning context, dependency graph |
| `bv --robot-insights` | Architecture patterns |
| `bd create "Task title"` | Create a new task |
| `bd update [ID] --status done` | Mark task complete |
| `bd complete [ID]` | Complete a task |
