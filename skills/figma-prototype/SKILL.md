---
name: figma-prototype
description: "Create interactive clickable prototypes by programmatically wiring up Figma frames with prototype connections, transitions, and flows. Use when building user-testable prototypes from existing designs."
---

# Figma Prototype

## When to Use
- Creating interactive prototypes from existing screen designs
- Wiring up user flows for user testing (usertesting.com, Maze, etc.)
- Adding navigation, overlays, and transitions between frames
- Automating prototype creation after the builder finishes screens
- Updating prototype connections after design changes

## Prerequisites
- **Local Mode required** — verify with `figma_get_status`
- If Remote Mode: output a prototype flow plan instead of executing
- Screens/frames must already exist in Figma (this skill connects them, doesn't create them)

## Process

### 1. Analyse the Design

`figma_get_file_data` with verbosity "full", depth 5+

Capture a visual reference first:
`figma_take_screenshot` — use as ground truth for verification after wiring.

Identify all top-level frames that represent "screens" (typically direct children of the page).

For each screen, identify interactive elements using these detection strategies:

**Component-based**: Instances of components named Button/\*, Link/\*, Tab/\*, NavItem/\*, Card/\*

**Name-based**: Layers containing "button", "btn", "cta", "link", "tab", "nav", "back", "close", "menu", "arrow"

**Structural**: Elements with fills + text children (likely buttons), navigation bars (horizontal auto-layout at top/bottom), tab bars, cards

**Variant-based**: Elements that have hover/pressed/active sibling variants nearby

### 2. Read Existing Connections

Check for existing prototype connections before creating new ones.

Via `figma_execute`:
```js
const frame = figma.getNodeById("FRAME_ID");
function getReactions(node, results = []) {
  if (node.reactions && node.reactions.length > 0) {
    results.push({ id: node.id, name: node.name, reactions: node.reactions });
  }
  if ("children" in node) {
    for (const child of node.children) {
      getReactions(child, results);
    }
  }
  return results;
}
JSON.stringify(getReactions(frame));
```

Report existing connections and ask: keep, modify, or replace?

### 3. Propose the Flow Map

Analyse screens and infer connections:

- **Screen name matching**: Button "Go to Settings" -> frame named "Settings"
- **Sequential flow**: Screens named "Step 1", "Step 2", "Step 3" -> linear flow
- **Hierarchical flow**: Dashboard -> sub-screens, each with "back" to Dashboard
- **Tab navigation**: Tab bar items -> corresponding screens
- **Modal patterns**: Settings icon -> overlay, close button -> CLOSE action

Present the proposed flow to the user for confirmation:

```markdown
## Proposed Prototype Flow

### Screens Detected: 5
1. Login (start)
2. Dashboard
3. Profile
4. Settings
5. Onboarding

### Connections
| # | Source Screen | Element | Action | Target Screen | Transition |
|---|-------------|---------|--------|--------------|------------|
| 1 | Login | "Sign In" button | Navigate | Dashboard | Smart Animate, 300ms |
| 2 | Dashboard | Tab: Profile | Navigate | Profile | Smart Animate, 200ms |
| 3 | Dashboard | Settings icon | Overlay | Settings | Slide Up, 250ms |
| 4 | Settings | Close button | Close | — | Dissolve, 200ms |
| 5 | All screens | Back arrow | Back | — | Slide Right, 300ms |

Adjust anything before I create these connections?
```

### 4. Create Prototype Connections

Via `figma_execute`, create reactions using `setReactionsAsync`.
Process connections in order, one screen at a time.

**Navigate (screen-to-screen):**
```js
const source = figma.getNodeById("SOURCE_ELEMENT_ID");
await source.setReactionsAsync([{
  trigger: { type: "ON_CLICK" },
  actions: [{
    type: "NODE",
    destinationId: "TARGET_FRAME_ID",
    navigation: "NAVIGATE",
    transition: {
      type: "SMART_ANIMATE",
      easing: { type: "EASE_IN_AND_OUT" },
      duration: 0.3
    },
    preserveScrollPosition: false
  }]
}]);
```

**Overlay (modal/sheet):**
```js
const trigger = figma.getNodeById("TRIGGER_ELEMENT_ID");
await trigger.setReactionsAsync([{
  trigger: { type: "ON_CLICK" },
  actions: [{
    type: "NODE",
    destinationId: "OVERLAY_FRAME_ID",
    navigation: "OVERLAY",
    transition: {
      type: "MOVE_IN",
      direction: "BOTTOM",
      matchLayers: false,
      easing: { type: "EASE_OUT" },
      duration: 0.25
    },
    preserveScrollPosition: false
  }]
}]);
```

**Close overlay:**
```js
const closeBtn = figma.getNodeById("CLOSE_BUTTON_ID");
await closeBtn.setReactionsAsync([{
  trigger: { type: "ON_CLICK" },
  actions: [{ type: "CLOSE" }]
}]);
```

**Back navigation:**
```js
const backBtn = figma.getNodeById("BACK_BUTTON_ID");
await backBtn.setReactionsAsync([{
  trigger: { type: "ON_CLICK" },
  actions: [{ type: "BACK" }]
}]);
```

**Tab switching (swap):**
```js
const tab = figma.getNodeById("TAB_ELEMENT_ID");
await tab.setReactionsAsync([{
  trigger: { type: "ON_CLICK" },
  actions: [{
    type: "NODE",
    destinationId: "TARGET_FRAME_ID",
    navigation: "NAVIGATE",
    transition: {
      type: "SMART_ANIMATE",
      easing: { type: "EASE_IN_AND_OUT" },
      duration: 0.2
    },
    preserveScrollPosition: false
  }]
}]);
```

**Hover state (interactive component):**
```js
const element = figma.getNodeById("ELEMENT_ID");
await element.setReactionsAsync([{
  trigger: { type: "ON_HOVER" },
  actions: [{
    type: "NODE",
    destinationId: "HOVER_VARIANT_ID",
    navigation: "CHANGE_TO",
    transition: {
      type: "SMART_ANIMATE",
      easing: { type: "EASE_IN_AND_OUT" },
      duration: 0.15
    }
  }]
}]);
```

**Auto-advance (splash/onboarding):**
```js
const splash = figma.getNodeById("SPLASH_FRAME_ID");
await splash.setReactionsAsync([{
  trigger: { type: "AFTER_TIMEOUT", timeout: 2000 },
  actions: [{
    type: "NODE",
    destinationId: "NEXT_FRAME_ID",
    navigation: "NAVIGATE",
    transition: {
      type: "DISSOLVE",
      easing: { type: "EASE_IN_AND_OUT" },
      duration: 0.5
    }
  }]
}]);
```

**Open URL:**
```js
const link = figma.getNodeById("LINK_ELEMENT_ID");
await link.setReactionsAsync([{
  trigger: { type: "ON_CLICK" },
  actions: [{
    type: "URL",
    url: "https://example.com"
  }]
}]);
```

### 5. Set Flow Starting Points

```js
figma.currentPage.flowStartingPoints = [
  { nodeId: "START_FRAME_ID", name: "Main Flow" }
];
```

Multiple flows can be set for different test scenarios (happy path, error path, etc.).

### 6. Generate the Prototype Link

The shareable prototype URL format:
```
https://www.figma.com/proto/{fileKey}/{fileName}?node-id={startNodeId}&starting-point-node-id={startNodeId}
```

- Construct `fileKey` from the file URL the user provided (the segment after `/design/` or `/file/`)
- The user must set file sharing to "Anyone with the link can view" for testing platforms to access it

### 7. Verification

- `figma_take_screenshot` — verify the prototype connections visually (blue connector lines should be visible in design mode)
- Output a summary of all connections created
- List the shareable prototype link

## Transition Presets

| Pattern | Transition | Duration | Easing | Notes |
|---------|-----------|----------|--------|-------|
| Standard navigation | Smart Animate | 300ms | Ease In Out | Forward navigation |
| Back navigation | Smart Animate | 300ms | Ease In Out | Reverse of forward |
| Modal/overlay open | Move In (Bottom) | 250ms | Ease Out | Bottom sheet pattern |
| Modal/overlay close | Move Out (Bottom) | 200ms | Ease In | Dismissal |
| Tab switching | Smart Animate | 200ms | Ease In Out | Instant feel |
| Onboarding carousel | Slide In (Left) | 300ms | Ease In Out | Horizontal swipe |
| Splash auto-advance | Dissolve | 500ms | Ease In Out | Timed transition |
| Hover state | Smart Animate | 150ms | Ease In Out | Subtle feedback |
| Drill-down (detail) | Push (Right) | 300ms | Ease In Out | iOS-style push |
| Fade transition | Dissolve | 300ms | Ease In Out | Subtle page change |

## Customisation
- User can override default transitions: "Use dissolve for all navigation"
- User can specify device frame: "iPhone 15 Pro"
- User can set prototype background colour
- User can add/remove individual connections after creation
- User can create multiple flows for different test scenarios

## Testing Platform Tips
- **usertesting.com**: Set file to "Anyone with the link can view", disable hotspot hints
- **Maze**: Native Figma integration, auto-syncs on design changes, provides heatmaps
- **UserZoom**: Use prototype share link from Figma's share modal
- **Lookback**: Paste prototype URL in auto-open URL field

## Remote Mode Fallback

If Local Mode is unavailable, output the full flow plan:

```markdown
## Prototype Flow Plan — [File Name]

### Flow: [Flow Name]
Starting Screen: [Name]

### Connections (manual creation order)
| # | Source Screen | Source Element | Trigger | Target Screen | Navigation | Transition |
|---|-------------|---------------|---------|--------------|------------|------------|
| 1 | Login | Sign In btn | On Click | Dashboard | Navigate | Smart Animate 300ms |

### Setup Steps
1. Select [element] on [screen]
2. Drag prototype connector to [target screen]
3. Set trigger: On Click
4. Set action: Navigate to
5. Set transition: Smart Animate, 300ms, Ease In Out
```

## Rules
- **Always propose the flow first** — never create connections without user confirmation
- **Check existing connections** — don't overwrite without asking
- **Smart Animate requires matching layer names** — warn the user if layers across frames don't share names
- **One flow at a time** — don't create all flows simultaneously, let the user verify each
- **Screenshot after creation** — always verify the prototype works visually
- **Local Mode only for creation** — Remote Mode gets a detailed plan instead
