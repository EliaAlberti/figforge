# Team Patterns

## Default Pattern: The Figma Team

**Trigger:** "spin up the Figma team" or "Figma team"

| Teammate | Role |
|----------|------|
| figma-inspector | Extracts design specs, measurements, tokens |
| figma-architect | Plans design systems, token hierarchies, conventions |
| figma-organizer | Renames layers, enforces conventions, cleans up files |
| figma-builder | Creates elements, components, layouts (Local Mode only) |

**When to use:** Any Figma design work. This is the default — when in doubt, spin up the full team.

**Note:** If the figma-builder detects Remote Mode, it will notify you and operate in advisory/spec mode. The other three teammates work in both modes.

---

## FigJam Session

**Trigger:** "spin up FigJam" or "FigJam team"

| Teammate | Role |
|----------|------|
| figjam-diagrammer | Creates diagrams, flowcharts, wireframes, workshop boards |

**When to use:** Creating visual diagrams or collaborative boards in FigJam.

---

## Focused Patterns

These are smaller teams for specific needs:

### Design Audit

**Trigger:** "Figma audit"

| Teammate | Role |
|----------|------|
| figma-inspector | Extracts specs for analysis |
| figma-architect | Identifies inconsistencies, proposes improvements |

**When to use:** Read-only analysis of a Figma file. No modifications made.

**Example tasks:**
- "Audit the onboarding screens for token consistency"
- "Check if all components follow our naming convention"
- "Analyse the colour usage across the app"

### Design System Sprint

**Trigger:** "design system sprint"

| Teammate | Role |
|----------|------|
| figma-architect | Defines token architecture and conventions |
| figma-organizer | Renames and restructures to match conventions |
| figma-builder | Creates new components following conventions |

**When to use:** Establishing or overhauling a design system. Typically a multi-task session.

**Example tasks:**
- "Set up a token hierarchy for our colour system"
- "Create a button component with Primary, Secondary, and Ghost variants"
- "Reorganise all layers in the Settings page to follow our convention"

### Spec Extraction

**Trigger:** "extract specs"

| Teammate | Role |
|----------|------|
| figma-inspector | Extracts precise measurements per screen |
| figma-architect | Documents token usage and component relationships |

**When to use:** Preparing handoff documentation for developers.

**Example tasks:**
- "Extract specs for the Login, Register, and Forgot Password screens"
- "Document all tokens used in the Dashboard"
- "Create a handoff doc for the Settings redesign"

---

## Creating Your Own Patterns

You can define custom patterns by editing the Team Patterns section in your project's `CLAUDE.md`:

```markdown
### My Custom Pattern
**Trigger:** "my custom trigger"
**Spawn:**
- figma-inspector (from teammates/design/figma-inspector.md)
- figma-builder (from teammates/design/figma-builder.md)
**Use when:** [describe your use case]
```

The team lead will recognise the trigger phrase and spawn only the listed teammates.
