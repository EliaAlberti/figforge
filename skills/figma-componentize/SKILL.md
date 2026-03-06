---
name: figma-componentize
description: "Create fully-fledged components and component sets from any Figma frame's design elements, with optional SVG export. Use when converting existing designs into reusable component libraries."
---

# Figma Componentize

## When to Use
- Converting one-off designs into reusable components
- Building a component library from existing screens
- Extracting repeated patterns into component sets with variants
- Exporting design elements as SVG assets

## Prerequisites
- **Local Mode required** for creation — verify with `figma_get_status`
- If Remote Mode: output a componentization plan instead of executing

## Process

### 1. Analyse the Frame
`figma_get_file_data` with verbosity "full", depth 10+

Identify:
- **Repeated elements** — same structure appearing 2+ times (buttons, cards, list items, icons)
- **State variations** — elements that differ only by colour, text, or icon (hover, active, disabled)
- **Atomic elements** — smallest indivisible units (icons, badges, tags, avatars)
- **Composite elements** — groups of atomic elements forming a pattern (card, nav item, form field)

### 2. Plan the Component Hierarchy

Work bottom-up:
```
Atoms (smallest)     → Icon, Badge, Avatar, Divider
Molecules            → Button, Input, Tag, Chip
Organisms            → Card, ListItem, NavBar, FormGroup
Templates            → Full sections composed of organisms
```

For each candidate component, determine:
- **Name**: Follow project naming convention or `[Category]/[Name]`
- **Variants**: Which properties vary? (size, state, type, theme)
- **Properties**: Boolean toggles (showIcon, hasSubtitle), instance swaps, text overrides

### 3. Cross-Reference Existing Components
`figma_search_components` — check if similar components already exist.
- If a match exists: **do not duplicate** — note it and use the existing one
- If a partial match: extend the existing component with new variants

### 4. Cross-Reference Design Tokens
`figma_get_variables` — ensure all colours, spacing, and typography reference tokens.
- Never hardcode hex values if a token exists
- Flag missing tokens for the architect

### 5. Create Components (Local Mode)

For each component:
1. Create the base frame with auto-layout
2. Apply correct fills, strokes, effects using tokens
3. Convert to component: `figma_execute` with `figma.currentPage.selection = [node]; figma.createComponentFromNode(node)`
4. Add variant properties if component set is needed
5. Set component description with `figma_set_description`

For component sets (multiple variants):
1. Create each variant as a separate component
2. Combine into component set using `figma_arrange_component_set`
3. Verify all variant properties are correctly labelled

### 6. SVG Export (Optional)

When SVG export is requested:
```js
// Via figma_execute
const node = figma.getNodeById("NODE_ID");
const svg = await node.exportAsync({ format: "SVG" });
// Returns SVG string for each component
```

Export guidelines:
- Flatten unnecessary groups before export
- Outline strokes if stroke alignment matters
- Remove hidden layers
- Ensure boolean operations are flattened

### 7. Visual Verification
`figma_take_screenshot` — compare the new components against the original frame.
- Layout should match
- Colours should match
- Spacing should match
- No missing elements

### 8. Documentation
For each created component, output:

```markdown
## Component: [Name]
- **Type**: Atom / Molecule / Organism
- **Variants**: [list of variant properties and values]
- **Properties**: [boolean, text, instance swap properties]
- **Tokens Used**: [list of design tokens referenced]
- **SVG Exported**: Yes/No
```

## Remote Mode Fallback

If Local Mode is unavailable, output a componentization plan:

```markdown
## Componentization Plan — [Frame Name]

### Components to Create
| # | Name | Type | Variants | Properties | Based On (Node ID) |
|---|------|------|----------|------------|---------------------|
| 1 | Button/Primary | Molecule | size: sm/md/lg, state: default/hover/disabled | hasIcon: bool | 12:34 |

### Existing Components to Reuse
| Component | Node ID | Usage |
|-----------|---------|-------|
| Icon/Arrow | 56:78 | Used in Button, Card |

### Missing Tokens
| Value | Suggested Token Name |
|-------|---------------------|
| #E10600 | color/brand/accent |
```

## Rules
- **Never duplicate** an existing component — extend it
- **Always use auto-layout** inside components
- **Always reference tokens** — no hardcoded values
- **Ask the user** before making aesthetic decisions about variant structure
- **Component-first hierarchy**: atoms before molecules, molecules before organisms
