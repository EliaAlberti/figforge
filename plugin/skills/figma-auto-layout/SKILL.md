---
name: figma-auto-layout
description: "Intelligently apply auto-layout to existing Figma frame contents where applicable, following best design practices. Use when retrofitting structure onto existing designs."
---

# Figma Auto-Layout

## When to Use
- Retrofitting auto-layout onto absolute-positioned designs
- Making static mockups responsive
- Cleaning up frame structure for developer handoff
- Preparing designs for component extraction

## Prerequisites
- **Local Mode required** — verify with `figma_get_status`
- If Remote Mode: output an auto-layout plan instead of executing

## Process

### 1. Analyse the Frame Structure
`figma_get_file_data` with verbosity "full", depth 10+

Capture a visual reference first:
`figma_take_screenshot` — use as ground truth for before/after comparison.

### 2. Detect Layout Patterns

Examine child positions and dimensions to identify:

**Vertical Stacks** (elements share similar X, increasing Y)
- Navigation lists, form fields, card content, page sections
- Look for: consistent left edge, sequential vertical positioning

**Horizontal Rows** (elements share similar Y, increasing X)
- Button groups, icon rows, tag lists, nav bars
- Look for: consistent top edge, sequential horizontal positioning

**Grids** (rows of horizontal items with vertical repetition)
- Card grids, image galleries, feature sections
- Implement as: vertical auto-layout of horizontal auto-layout rows

**Wrap Layouts** (items that should flow and wrap)
- Tag clouds, filter chips, badge groups
- Use: auto-layout with `wrap` enabled

**No Auto-Layout Needed** (leave as-is)
- Overlapping elements (badges on avatars, floating labels)
- Canvas-style layouts (diagrams, illustrations)
- Single-element frames with deliberate absolute positioning

### 3. Determine Properties for Each Container

For each auto-layout candidate:

| Property | How to Derive |
|----------|--------------|
| **Direction** | Vertical if children stack top-to-bottom; Horizontal if left-to-right |
| **Gap** | Most common spacing between consecutive children (round to nearest token value) |
| **Padding** | Distance from frame edges to nearest child (top, right, bottom, left) |
| **Alignment** | Primary axis: start/center/end/space-between. Counter axis: start/center/end |
| **Sizing** | Children: `fill` if they stretch to frame width, `hug` if intrinsic. Frame: `fill` if it stretches to parent, `fixed` if explicit size |

### 4. Match Spacing to Design Tokens
`figma_get_variables` — find spacing tokens that match detected gaps/padding.

| Detected Value | Nearest Token | Use Token? |
|---------------|--------------|------------|
| 15px | spacing/md (16px) | Yes — likely intended as 16 |
| 24px | spacing/lg (24px) | Yes — exact match |
| 7px | (none) | Flag — possibly unintentional |

Round to token values when the difference is <= 2px (likely design imprecision, not intent).

### 5. Apply Auto-Layout (Local Mode)

Work **inside-out** — deepest children first, then parent containers:

```
Step 1: Leaf groups (button internals, input fields, list items)
Step 2: Mid-level containers (cards, form sections, nav groups)
Step 3: Top-level page sections (header, content, footer)
Step 4: Page frame itself
```

For each container via `figma_execute`:
```js
const node = figma.getNodeById("NODE_ID");

// Apply auto-layout
node.layoutMode = "VERTICAL"; // or "HORIZONTAL"
node.itemSpacing = 16;        // gap
node.paddingTop = 24;
node.paddingRight = 24;
node.paddingBottom = 24;
node.paddingLeft = 24;
node.primaryAxisAlignItems = "MIN";   // start
node.counterAxisAlignItems = "CENTER";

// Set child sizing
for (const child of node.children) {
  child.layoutSizingHorizontal = "FILL"; // or "HUG" or "FIXED"
  child.layoutSizingVertical = "HUG";
}
```

### 6. Handle Edge Cases

**Overlapping elements:**
- Do NOT auto-layout — use absolute position within auto-layout (`layoutPositioning = "ABSOLUTE"`)
- Common: notification badges, floating action buttons, overlay labels

**Mixed directions:**
- Wrap in intermediate frames: a horizontal row inside a vertical stack
- Each intermediate frame gets its own auto-layout

**Unequal spacing:**
- If spacing varies intentionally (e.g., section dividers have more space), use spacer frames or nested auto-layout groups with different gaps
- If spacing varies unintentionally, normalise to the nearest token

**Text elements:**
- Set `textAutoResize = "WIDTH_AND_HEIGHT"` for labels (hug)
- Set `textAutoResize = "HEIGHT"` for paragraphs that should fill width

### 7. Visual Verification
`figma_take_screenshot` — compare against the original screenshot.

Check:
- **No visual shift** — elements should be in the same positions
- **No clipping** — text and images fully visible
- **No collapse** — empty containers should not shrink to 0
- **Correct stretching** — fill-width elements span their container

If visual discrepancies are found:
1. Identify the misaligned element
2. Check sizing mode (fill vs hug vs fixed)
3. Check alignment settings
4. Adjust and re-screenshot (max 3 iterations)

### 8. Documentation
Output a summary of changes:

```markdown
## Auto-Layout Applied — [Frame Name]

### Changes
| Node | Direction | Gap | Padding | Child Sizing | Notes |
|------|-----------|-----|---------|-------------|-------|
| Card | Vertical | 16 (spacing/md) | 24 all (spacing/lg) | Fill-width | Was absolute |
| ButtonRow | Horizontal | 8 (spacing/sm) | 0 | Hug | — |

### Left As-Is
| Node | Reason |
|------|--------|
| AvatarBadge | Overlapping elements — absolute positioning required |

### Spacing Normalised
| Node | Original | Normalised To | Token |
|------|----------|--------------|-------|
| FormFields | 15px | 16px | spacing/md |
```

## Remote Mode Fallback

If Local Mode is unavailable, output the full plan:

```markdown
## Auto-Layout Plan — [Frame Name]

### Recommended Changes (inside-out order)
| # | Node (ID) | Current | Proposed Layout | Direction | Gap | Padding | Rationale |
|---|-----------|---------|----------------|-----------|-----|---------|-----------|
| 1 | InputGroup (12:34) | Absolute | Auto-layout | Vertical | 8px | 0 | Stacked form fields |

### Do Not Modify
| Node (ID) | Reason |
|-----------|--------|
| Badge (56:78) | Intentional overlap on avatar |
```

## Rules
- **Never break visual layout** — the design must look identical after auto-layout
- **Inside-out** — always start from the deepest children
- **Token-first** — use spacing tokens, not arbitrary pixel values
- **Conservative** — only apply auto-layout where it genuinely fits; leave complex overlaps alone
- **Ask before normalising** — if a spacing value is ambiguous, ask the user before rounding
- **Screenshot before and after** — always verify visually
