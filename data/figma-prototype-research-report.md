# Figma-to-Interactive Prototype: Comprehensive Research Report

**Date**: March 18, 2026
**Scope**: Tools, APIs, automation pipelines, and emerging approaches for generating high-fidelity interactive clickable prototypes from Figma designs

---

## Executive Summary

This report covers the full landscape of options for converting Figma designs into interactive, clickable prototypes that can be shared via URL and used on user testing platforms. The key findings are:

1. **Figma's native prototype sharing** (free prototype URLs) works directly with all major user testing platforms (UserTesting, Maze, UserZoom, Lookback).
2. **Figma Make** (native AI feature) can generate interactive React prototypes from design frames or natural language prompts, available on paid Figma plans.
3. **The Figma Plugin API** is the only programmatic way to **create** prototype connections/interactions inside Figma (via `setReactionsAsync`).
4. **The Figma REST API** can **read** prototype interaction data (added September 2024) but **cannot write** it.
5. **Neither the official Figma MCP server nor figma-console-mcp** expose prototype/interaction-related tools.
6. **Code-based prototype generation** (Anima, Locofy, Builder.io, v0.dev, Claude Code) can produce deployable HTML/React applications from Figma designs, yielding shareable URLs.
7. **Automation pipelines** using Figma webhooks, n8n, and GitHub Actions can trigger prototype regeneration on design changes.
8. **AI/LLM-based approaches** (Claude Code + Figma MCP, v0.dev, Figma Make) represent the most promising emerging direction for rapid prototype generation.

---

## 1. Figma-to-Prototype Conversion Tools

### 1.1 Figma Make (Native)

| Attribute | Detail |
|---|---|
| **What it does** | AI-powered interactive prototype generator built into Figma. Generates React code from design frames or natural language prompts. Produces functional prototypes with real interactions, navigation, and transitions. |
| **Shareable via URL** | Yes -- prototypes can be previewed and shared within Figma. As of Jan 2026, Figma Make prototypes can be embedded in Figma Design, FigJam, and Figma Slides. However, Figma Make designs **cannot** be embedded via iframe externally. |
| **Works with user testing platforms** | Partially. Figma Make prototypes are viewable within Figma but have limited external sharing compared to standard Figma prototypes. |
| **Automatable from Figma URL** | No. Requires manual interaction within the Figma editor. |
| **Customizability** | High -- natural language refinement, visual editing, and direct code editing. |
| **Pricing** | Included in paid Figma plans (Professional $15/editor/mo, Organization $45/editor/mo, Enterprise $90/editor/mo). Not reliably available on the free Starter plan. |
| **Limitations** | Cannot be embedded via iframe. Limited external sharing options. Requires Figma paid plan. |

### 1.2 Anima

| Attribute | Detail |
|---|---|
| **What it does** | Figma plugin (1.5M+ installs) that exports designs to production-ready code (HTML/CSS, React, Vue). Also provides direct prototype hosting on animaapp.io with custom domain support. Can publish live websites directly from Figma. |
| **Shareable via URL** | Yes -- hosted prototypes at animaapp.io URLs or custom domains. |
| **Works with user testing platforms** | Yes -- hosted URLs work with any platform that accepts web URLs. |
| **Automatable from Figma URL** | Partially. Export is plugin-driven (manual trigger), but the hosted output is auto-deployed. |
| **Customizability** | High -- supports hover effects, animations, videos, real input fields, embedded custom code. |
| **Pricing** | Starts at $24/mo. Enterprise from $500/mo. Pro plan includes unlimited hosting, custom domains, code export. IBM invested in Feb 2026. |
| **Limitations** | Plugin-driven (not fully API-automatable). Requires Anima account and plan. |

### 1.3 Locofy

| Attribute | Detail |
|---|---|
| **What it does** | AI-powered design-to-code tool. Converts Figma/Penpot designs to code with the widest framework support: React, React Native, HTML/CSS, Flutter, Vue, Angular, Next.js. Two modes: Lightning (one-click AI) and Classic (step-by-step with manual tagging). |
| **Shareable via URL** | Yes -- deploy directly to Netlify, Vercel, or GitHub Pages. Sync to GitHub repos. |
| **Works with user testing platforms** | Yes -- deployed sites produce standard URLs usable on any testing platform. |
| **Automatable from Figma URL** | Partially. Plugin-driven export, but deployment to hosting can be automated via GitHub + CI/CD. |
| **Customizability** | High -- AI tagging, responsive output, data binding to backend APIs, mobile framework support. |
| **Pricing** | Pay-as-you-go at $0.40/LDM token. Starter $399/year. Pro $1,199/year. Enterprise custom. |
| **Limitations** | Token-based pricing can be expensive for large projects. Plugin-driven initial export. |

### 1.4 Builder.io (Visual Copilot)

| Attribute | Detail |
|---|---|
| **What it does** | AI-powered Figma-to-code plugin trained on 2M+ data points. Generates responsive code for React, Angular, Svelte, Vue, Qwik, HTML. Combines code generation with a headless visual CMS. Visual Copilot 2.0 adds "Design to Interactive" capability. |
| **Shareable via URL** | Yes -- via Builder.io CMS hosting or self-deployed code. |
| **Works with user testing platforms** | Yes -- deployed sites produce standard URLs. |
| **Automatable from Figma URL** | Partially. Plugin-driven, but Builder.io CMS has API for deployment automation. |
| **Customizability** | Very high -- CMS integration, A/B testing built in, Tailwind/Styled Components/Emotion support. |
| **Pricing** | Free: $0/user/mo (20 code generations, 4K context). Basic: $19/user/mo (500 generations, 128K context). Growth: $39/user/mo (2,500 generations). |
| **Limitations** | Best suited for marketing/content teams. CMS dependency adds complexity. |

### 1.5 TeleportHQ

| Attribute | Detail |
|---|---|
| **What it does** | Collaborative front-end builder that exports Figma designs to clean, dependency-free code for React, Vue, Next.js, Angular, and HTML. Includes AI-driven code generation. |
| **Shareable via URL** | Yes -- publish to TeleportHQ subdomain or custom domain. |
| **Works with user testing platforms** | Yes -- published sites produce standard URLs. |
| **Automatable from Figma URL** | No. Requires importing designs into TeleportHQ's editor (extra step vs. competitors). |
| **Customizability** | Medium -- visual editor for refinement, but the import step adds friction. |
| **Pricing** | Free: 3 projects, 10 code views, free hosting. Paid: $9/editor/mo. |
| **Limitations** | Extra import step (not direct from Figma). Less direct than Anima/Locofy. |

### 1.6 ProtoPie

| Attribute | Detail |
|---|---|
| **What it does** | High-fidelity prototyping tool that imports Figma designs and adds dynamic, conditional interactions beyond what Figma's native prototyping supports. Automatically converts Figma frame interactions into ProtoPie Jump responses. |
| **Shareable via URL** | Yes -- public shareable links for prototypes. |
| **Works with user testing platforms** | Yes -- UserTesting specifically supports ProtoPie. Shareable links work with all platforms. |
| **Automatable from Figma URL** | No. Requires manual import via ProtoPie Figma plugin or legacy import. |
| **Customizability** | Very high -- the most advanced interaction design (sensors, variables, conditions, multi-device). |
| **Pricing** | Starts at $67/mo. Free trial available. |
| **Limitations** | Expensive. Not automatable. Separate tool from Figma. |

### 1.7 Framer

| Attribute | Detail |
|---|---|
| **What it does** | Design and publishing platform. Imports Figma designs via plugin or copy-paste. Produces live, responsive websites with interactions. |
| **Shareable via URL** | Yes -- published sites get Framer URLs or custom domains. Share button produces prototype preview links. |
| **Works with user testing platforms** | Yes -- UserTesting fully supports Framer prototypes (including mobile on iOS/Android with full-screen mode). |
| **Automatable from Figma URL** | No. Manual import process with potential layout rebuild needed. |
| **Customizability** | High -- CMS, animations, responsive design, but Figma import requires clean Auto Layout. |
| **Pricing** | Free tier available. Paid plans start at $5/mo (Mini), $15/mo (Basic site). |
| **Limitations** | Figma import quality depends heavily on clean Auto Layout structure. May require rebuilding. |

### 1.8 v0.dev (Vercel)

| Attribute | Detail |
|---|---|
| **What it does** | AI-powered UI builder that generates React components, pages, and full web apps from prompts or Figma screenshots. Uses shadcn/ui + Tailwind CSS. One-click deploy to Vercel. |
| **Shareable via URL** | Yes -- shareable preview links + one-click deploy to Vercel with production URL. |
| **Works with user testing platforms** | Yes -- deployed Vercel URLs work with any testing platform. |
| **Automatable from Figma URL** | Partially. Can accept screenshots/designs as input. Vercel deployment is automated. |
| **Customizability** | High -- prompt-based iteration, code editing, shadcn/ui components. |
| **Pricing** | Free tier available. Premium: $20/mo (required for Figma import). |
| **Limitations** | Figma import on Premium only. Quality depends on design complexity. Component library locked to shadcn/ui. |

### 1.9 Supernova.io

| Attribute | Detail |
|---|---|
| **What it does** | Design system platform that imports Figma design tokens and components, generates production-ready code for React, React Native, Flutter, SwiftUI, Android Compose. Includes documentation hosting. |
| **Shareable via URL** | Yes -- published documentation sites. Code export for self-hosting. |
| **Works with user testing platforms** | Indirectly -- generates code that can be deployed, not interactive prototypes. |
| **Automatable from Figma URL** | Partially -- Figma sync is automated, code generation can be CI/CD integrated. |
| **Customizability** | High -- custom exporters, design token transformation, multi-platform output. |
| **Pricing** | Free tier available. Paid plans vary. |
| **Limitations** | Focused on design systems, not interactive prototype generation. |

---

## 2. Figma Plugin API for Prototyping

### 2.1 Reactions Property (Read + Write)

The Figma Plugin API provides **full read and write access** to prototype connections via the `reactions` property on nodes.

**Reading reactions:**
```javascript
// Each node has a reactions array
const reactions = node.reactions; // ReadonlyArray<Reaction>
```

**Writing reactions (via setReactionsAsync):**
```javascript
await node.setReactionsAsync([
  {
    action: {
      type: "NODE",
      destinationId: "2:1",
      navigation: "NAVIGATE",
      transition: {
        type: "SMART_ANIMATE",
        easing: { type: "EASE_OUT" },
        duration: 0.3
      },
      preserveScrollPosition: false
    },
    trigger: {
      type: "ON_CLICK"
    }
  }
]);
```

### 2.2 Supported Action Types

| Action Type | Description |
|---|---|
| `NODE` | Navigate to another frame (with transition options) |
| `SET_VARIABLE` | Update variable values |
| `CONDITIONAL` | Execute actions based on variable conditions |

### 2.3 Supported Triggers

- `ON_CLICK`
- `ON_HOVER` (implicit from documentation)
- `ON_DRAG`
- `MOUSE_ENTER` / `MOUSE_LEAVE`
- `AFTER_TIMEOUT`
- Additional trigger types per Figma's prototyping model

### 2.4 Transition Options

- **type**: `DISSOLVE`, `SMART_ANIMATE`, `MOVE_IN`, `MOVE_OUT`, `PUSH`, `SLIDE_IN`, `SLIDE_OUT`
- **easing**: `EASE_IN`, `EASE_OUT`, `EASE_IN_AND_OUT`, `LINEAR`, `CUSTOM_BEZIER`
- **duration**: Numeric value in seconds
- **preserveScrollPosition**: Boolean

### 2.5 Important Implementation Notes

- The `action` and `trigger` objects are **readonly** -- you must clone the entire `reactions` array before modifying.
- Multiple actions per reaction are supported (via the `actions` field).
- Advanced prototyping types (SET_VARIABLE, CONDITIONAL) are supported.
- If the manifest contains `"documentAccess": "dynamic-page"`, reactions become **read-only**.

### 2.6 Existing Plugins for Auto-Generating Prototype Flows

| Plugin | What It Does |
|---|---|
| **Miles Play: Fastest Prototype** | Quickly connects selected frames for rapid user flows. Remove all prototype links in a single action. |
| **Autoflow** | Draws flow arrows between frames (visual documentation, not prototype connections). Free up to 50 flows/file. |
| **FlowAuto** | Turns frames into tidy, attached userflows with auto-adjust connectors. |
| **Freeflow** | Auto-adjust connectors that update dynamically as elements move. |
| **Figma AI "Make interactions"** | Native Figma AI feature that automatically creates interactions between frames in a selection. |

### 2.7 Example Plugin Repository

The [figma-plugin-example-prototype-write](https://github.com/adispezio/figma-plugin-example-prototype-write) repository demonstrates programmatic creation of prototype interactions using the Plugin API with TypeScript and the Create Figma Plugin boilerplate.

---

## 3. Figma REST API Prototyping Capabilities

### 3.1 Reading Prototype Data

**Added September 12, 2024**: The REST API now includes the `interactions` field within the `TransitionSourceTrait` attribute, containing full data about prototyping interactions on each node. This is equivalent to the `reactions` field in the Plugin API.

**How to access:**
- Use the `GET /v1/files/:file_key` endpoint
- Or `GET /v1/files/:file_key/nodes?ids=NODE_IDS`
- The response JSON includes `interactions` data on applicable nodes

### 3.2 Writing Prototype Data

**NOT supported.** The REST API is **read-only** for prototype interactions. There is no endpoint to create, modify, or delete prototype connections via the REST API.

### 3.3 Prototype Link Generation

**NOT supported programmatically.** There is no REST API endpoint to generate or retrieve prototype shareable links. Prototype links follow a predictable URL pattern that can be constructed manually:

```
https://www.figma.com/proto/FILE_KEY/FILE_NAME?node-id=NODE_ID&starting-point-node-id=NODE_ID
```

The file key and node IDs can be obtained from the REST API or parsed from Figma URLs.

### 3.4 Figma Embed Kit

Figma prototypes can be embedded via iframe using the Embed Kit:
```html
<iframe
  src="https://www.figma.com/embed?embed_host=YOURAPP&url=PROTOTYPE_URL"
  allowfullscreen>
</iframe>
```

This is how UserTesting's native Figma integration works internally.

### 3.5 Summary of REST API Limitations

| Capability | Supported | Notes |
|---|---|---|
| Read prototype interactions | Yes | Via `interactions` field (since Sept 2024) |
| Write prototype interactions | No | Use Plugin API instead |
| Generate prototype share links | No | Construct URL manually from file key + node ID |
| Export prototype as standalone | No | Use code generation tools instead |
| Access prototype presentation mode | No | `/proto` endpoint not available |
| Embed prototypes | Yes | Via Figma Embed Kit (iframe) |

---

## 4. figma-console-mcp Prototyping Support

### 4.1 Complete Tool Inventory

After reviewing the full documentation at `docs.figma-console-mcp.southleft.com`, figma-console-mcp exposes **57+ tools** across these categories:

**Navigation & Status**: `figma_navigate`, `figma_get_status`, `figma_reconnect`

**Console**: `figma_get_console_logs`, `figma_watch_console`, `figma_clear_console`

**Debugging**: `figma_take_screenshot`, `figma_reload_plugin`

**Design System**: `figma_get_variables`, `figma_get_styles`, `figma_get_component`, `figma_get_component_for_development`, `figma_get_component_image`, `figma_get_file_data`, `figma_get_file_for_plugin`, `figma_get_design_system_kit`, `figma_get_design_system_summary`, `figma_get_token_values`

**Design Creation**: `figma_execute`, `figma_arrange_component_set`, `figma_set_description`

**Components**: `figma_search_components`, `figma_get_library_components`, `figma_get_component_details`, `figma_instantiate_component`, `figma_add_component_property`, `figma_edit_component_property`, `figma_delete_component_property`

**Variables**: `figma_create_variable_collection`, `figma_create_variable`, `figma_update_variable`, `figma_rename_variable`, `figma_delete_variable`, `figma_delete_variable_collection`, `figma_add_mode`, `figma_rename_mode`, `figma_batch_create_variables`, `figma_batch_update_variables`, `figma_setup_design_tokens`

**Design-Code Parity**: `figma_check_design_parity`, `figma_generate_component_doc`

**Comments**: `figma_get_comments`, `figma_post_comment`, `figma_delete_comment`

**Node Manipulation**: `figma_resize_node`, `figma_move_node`, `figma_clone_node`, `figma_delete_node`, `figma_rename_node`, `figma_set_text`, `figma_set_fills`, `figma_set_strokes`, `figma_create_child`

**Image**: `figma_set_image_fill`

**Design Lint**: `figma_lint_design`

### 4.2 Prototype-Related Tools: NONE

**figma-console-mcp does NOT include any tools for:**
- Creating prototype connections/reactions
- Reading prototype interactions
- Managing prototype flows
- Setting transitions or animations
- Generating prototype links

### 4.3 Workaround: figma_execute

The `figma_execute` tool can run arbitrary Figma Plugin API code. This means you **could** theoretically use it to call `setReactionsAsync` and create prototype connections programmatically through figma-console-mcp, but there is no dedicated, documented tool for this purpose.

### 4.4 Deployment Modes

| Mode | Tools Available | Prototype Support |
|---|---|---|
| NPX/Local Git | 59+ tools | None native; `figma_execute` workaround |
| Cloud Mode | 43 tools | None native |
| Remote SSE | 22 tools | None native |

---

## 5. Official Figma MCP Server Prototyping Support

### 5.1 Complete Tool List

The official Figma MCP server (remote at `https://mcp.figma.com/mcp`) exposes **13 tools**:

1. `generate_figma_design` -- Generate design layers from interfaces (remote only)
2. `get_design_context` -- Retrieve design context with framework-specific output
3. `get_variable_defs` -- Get variables and styles (colors, spacing, typography)
4. `get_code_connect_map` -- Retrieve Figma-to-code component mappings
5. `add_code_connect_map` -- Establish Figma-to-code mappings
6. `get_screenshot` -- Take screenshots of selections
7. `create_design_system_rules` -- Create design system rule files
8. `get_metadata` -- Get sparse XML representation of selection
9. `get_figjam` -- Convert FigJam diagrams to XML
10. `generate_diagram` -- Create FigJam diagrams from Mermaid syntax
11. `whoami` -- Return authenticated user info (remote only)
12. `get_code_connect_suggestions` -- Detect Code Connect mappings
13. `send_code_connect_mappings` -- Confirm Code Connect mappings

### 5.2 Prototype-Related Tools: NONE

The official Figma MCP server has **no tools** for creating, reading, or managing prototype interactions, connections, or flows.

---

## 6. Code-Based Prototype Generation

### 6.1 Standalone HTML/CSS/JS Generators

| Tool | Input | Output | CLI/API Support | Deploy Options |
|---|---|---|---|---|
| **Anima** | Figma plugin | HTML/CSS/JS + hosting | Plugin-driven | animaapp.io, custom domain |
| **Locofy** | Figma plugin | HTML/CSS, React, Vue, etc. | Plugin + GitHub sync | Netlify, Vercel, GitHub Pages |
| **Builder.io** | Figma plugin | React, Vue, HTML + CMS | Plugin + CMS API | Builder.io hosting, self-deploy |
| **TeleportHQ** | Import to editor | React, Vue, HTML | Editor-driven | TeleportHQ subdomain, custom domain |
| **Figma Make** | Native in Figma | React (editable) | Manual in editor | Export code for self-deploy |

### 6.2 CLI-Based Tools

**@figma-export/cli (npm)**
- Exports Figma components as SVG, styles as SASS/SCSS, or ES6 modules
- Configurable via `.figmaexportrc.ts`
- Uses Figma REST API with personal access token
- **Does NOT** generate interactive prototypes -- exports assets/styles only

**figma-exporter (npm)**
- Command-line utility for exporting Figma files and projects
- Asset export focused, not prototype generation

### 6.3 React-Based Generators

| Tool | Approach | Quality | Deployment |
|---|---|---|---|
| **Figma Make** | Native AI, prompt-based | High (uses your design system) | Export React code |
| **v0.dev** | AI from screenshots/prompts | High (shadcn/ui) | One-click Vercel deploy |
| **Builder.io Visual Copilot** | AI trained on 2M data points | High (framework-agnostic) | CMS or self-deploy |
| **Locofy** | AI tagging + conversion | High (component-based) | GitHub + deploy |
| **Anima** | Direct conversion | Medium-High | animaapp.io hosting |
| **Tempo** | AI-powered Figma plugin | Medium-High | Code export |
| **Dualite Alpha** | AI analysis + generation | Medium | Code export |

---

## 7. Automation Approaches

### 7.1 Figma Webhooks

Figma supports webhooks for real-time event notifications:

| Event Type | Trigger | Use Case |
|---|---|---|
| `FILE_UPDATE` | File content changes | Trigger prototype rebuild on any change |
| `FILE_VERSION_UPDATE` | New version saved | Trigger rebuild on version publish |
| `FILE_COMMENT` | Comment added/modified | Trigger review workflow |
| `LIBRARY_PUBLISH` | Library published | Trigger design system update |
| `FILE_DELETE` | File deleted | Cleanup automation |

**Setup**: POST to Figma's webhook endpoint with your callback URL. Figma sends a PING event on creation, then sends event payloads to your endpoint.

### 7.2 n8n Workflows

n8n provides native Figma integration with **5 trigger types**:

1. File update trigger
2. Comment trigger
3. Version update trigger
4. Deletion trigger
5. Library publish trigger

**Key workflow patterns:**
- Figma version update --> n8n webhook --> code generation --> deploy to hosting
- Figma file update --> n8n --> export assets --> GitHub PR --> CI/CD deploy
- Figma comment --> n8n --> Slack notification --> review workflow

**MKitFlow** is a Figma plugin that connects APIs and n8n flows directly inside Figma.

### 7.3 GitHub Actions

| Tool | What It Does |
|---|---|
| **Figma Action** (GitHub Marketplace) | Export Figma components to repo with configuration |
| **Continuous Design Plugin** | Run GitHub Actions, Bitbucket Pipelines, or Azure DevOps from within Figma |
| **Run GitHub Actions Workflows** (Figma plugin) | Trigger workflows with selected page/nodes as inputs |
| **figcd (Figma CI/CD)** | CLI tool for integrating Figma state into CI/CD pipelines |

**Example pipeline:**
```
Figma webhook (FILE_VERSION_UPDATE)
  --> GitHub Actions workflow triggered
    --> Fetch Figma file via REST API
    --> Extract frames/assets
    --> Generate code (via Anima CLI / custom script)
    --> Deploy to Vercel/Netlify
    --> Post shareable URL back to Figma comment
```

### 7.4 Make.com (formerly Integromat)

Make.com provides Figma integration with webhook/gateway support for building automated workflows between Figma and other services.

---

## 8. Sharing & Testing Platform Compatibility

### 8.1 UserTesting.com

| Feature | Detail |
|---|---|
| **Figma prototype URLs** | Directly supported. Paste prototype share link as starting URL. |
| **Native Figma integration** | Uses Figma API + Embed Kit. Captures element-level interaction data. |
| **Non-Figma URLs** | Any public URL works (hosted HTML, deployed React apps, etc.) |
| **Mobile testing** | Supported for Figma, Framer, and ProtoPie prototypes |
| **Iframe embedding** | Used internally by the native integration |
| **Secure hosting** | Available for sensitive prototypes |

**Setup steps:**
1. In Figma: Enter presentation view --> Share prototype --> Set "Anyone" + "Can view"
2. Disable hotspot hints, sidebar, and Figma UI
3. Copy prototype URL
4. In UserTesting: Create test --> Prototype type --> Paste URL

**Limitations:**
- Large files cause slow load times
- Smart Animate consumes significant bandwidth
- Contributors may abandon tests with heavy prototypes

### 8.2 Maze

| Feature | Detail |
|---|---|
| **Figma integration** | Native one-click import. Select frames directly from Figma. |
| **Auto-sync** | Updates automatically when Figma file changes |
| **Interactive Components** | Supported for detailed performance metrics |
| **Quantitative data** | Success rates, misclick rates, duration |
| **Heatmaps** | Per-screen heatmaps |
| **Participant recruitment** | Panel of 5M+ participants with demographic filters |
| **Pricing** | Free tier available. Plans up to $30K. Under $10K/year for most teams. |

### 8.3 UserZoom (now part of UserTesting)

| Feature | Detail |
|---|---|
| **Figma prototype URLs** | Supported as Starting (Initial) URL in tasks |
| **Best practices** | Use prototype share link from Figma's share modal |
| **Compatibility** | Full support for Figma prototype interactions |

### 8.4 Lookback

| Feature | Detail |
|---|---|
| **Figma integration** | No direct integration. Use shareable link in auto-open URL. |
| **Approach** | Paste Figma prototype URL in test setup |
| **Compatibility** | Works with any browser-accessible prototype |

### 8.5 Userbrain

| Feature | Detail |
|---|---|
| **Figma support** | Supports Figma prototype testing via share links |
| **Approach** | Standard URL-based testing |

### 8.6 Compatibility Matrix

| Platform | Figma Proto URL | Hosted HTML/React URL | ProtoPie URL | Framer URL | Iframe Embed |
|---|---|---|---|---|---|
| UserTesting | Yes | Yes | Yes | Yes | Internal |
| Maze | Yes (native) | Yes | -- | -- | -- |
| UserZoom | Yes | Yes | -- | -- | -- |
| Lookback | Yes | Yes | Yes | Yes | -- |
| Userbrain | Yes | Yes | -- | -- | -- |

**Key insight**: Any tool that produces a public, shareable URL will work with all user testing platforms. Figma's native prototype URLs have the best out-of-box support.

---

## 9. Emerging & Novel Approaches

### 9.1 Claude Code + Figma MCP Server

**Workflow:**
1. Connect Figma MCP server to Claude Code (or Cursor, Windsurf, VS Code)
2. Select a Figma frame and share the link in a prompt
3. Claude reads design context via `get_design_context` and `get_screenshot`
4. Claude generates a complete HTML/CSS/JS or React prototype
5. Deploy to Vercel/Netlify for a shareable URL

**Notable example from Jane Street**: "I design with Claude more than Figma now" -- engineers generate interactive prototypes from screenshots in ~90 seconds, complete with hover states, transitions, and responsive layout.

| Attribute | Detail |
|---|---|
| **Shareable via URL** | Yes (via manual deploy to Vercel/Netlify) |
| **Automatable** | Partially -- MCP interaction requires a code editor, but deployment can be automated |
| **Quality** | High for standard UI patterns; depends on prompt quality |
| **Cost** | Claude API costs + hosting costs |

### 9.2 Claude Code to Figma ("Code to Canvas")

The reverse workflow -- capture functioning UIs built in Claude Code and convert them into editable Figma frames. This creates a bi-directional pipeline:

```
Figma design --> Claude Code --> Interactive prototype
                                        |
                                        v
                              Code to Canvas (back to Figma)
```

### 9.3 v0.dev + Figma Integration

**Workflow:**
1. Export Figma frames as screenshots or use the Figma import feature ($20/mo Premium)
2. v0 generates React + shadcn/ui components
3. Iterate via natural language prompts
4. Share preview link or deploy to Vercel with one click

**Best for**: Rapid prototype generation with modern React stack.

### 9.4 html.to.design (Reverse Direction)

Converts any website/URL into editable Figma designs. Combined with v0.dev or Claude Code:
```
Prompt --> v0.dev/Claude --> HTML prototype --> html.to.design --> Figma layers
```

### 9.5 Figma AI "Make Interactions"

Native Figma feature (available since 2025) that uses AI to automatically create prototype interactions and connections between frames in a selection. Useful for quickly scaffolding basic prototype flows before refinement.

### 9.6 MCP Servers for Prototyping

**Current state**: No MCP server (official Figma, figma-console-mcp, or third-party) currently exposes dedicated prototyping tools. However:

- **figma-console-mcp's `figma_execute`** can run arbitrary Plugin API code, enabling prototype creation via `setReactionsAsync` as a workaround.
- **The official Figma MCP server's `get_design_context`** can extract design information for code generation, which indirectly enables prototype creation.
- **A custom MCP server** could be built using the Figma Plugin API to expose dedicated prototype creation tools.

### 9.7 Proposed Novel Pipeline: Fully Automated Figma-to-Prototype

```
[Figma File]
    |
    | FILE_VERSION_UPDATE webhook
    v
[n8n / GitHub Actions]
    |
    | Fetch file data via REST API
    | Extract frame screenshots via Image API
    v
[Claude API / v0.dev API]
    |
    | Generate React/HTML prototype code
    v
[GitHub Repository]
    |
    | Push code + trigger CI/CD
    v
[Vercel / Netlify]
    |
    | Auto-deploy
    v
[Shareable URL]
    |
    | Post URL back to Figma via Comments API
    v
[User Testing Platform]
```

This pipeline is technically feasible today using existing tools but would require custom integration work.

---

## 10. Comparative Summary

### 10.1 Best Options by Use Case

| Use Case | Recommended Tool(s) | Why |
|---|---|---|
| **Quick Figma prototype sharing** | Figma native prototype links | Free, works with all testing platforms, zero setup |
| **High-fidelity interactive prototype** | ProtoPie | Most advanced interactions, imports Figma, shareable links |
| **Code-based deployable prototype** | Anima or Locofy | Direct hosting/deploy from Figma, production-ready code |
| **AI-powered rapid prototyping** | Figma Make or v0.dev | Natural language to interactive prototype, fast iteration |
| **Free/budget option** | Figma native + Builder.io free tier | No cost, good enough for most testing needs |
| **Full automation pipeline** | Figma webhooks + Claude API + Vercel | Automatic rebuild on design changes, shareable URLs |
| **Enterprise/design system** | Supernova.io | Multi-platform code generation, documentation hosting |
| **Programmatic prototype creation** | Figma Plugin API (setReactionsAsync) | Only way to create Figma prototype connections via code |

### 10.2 Feature Comparison Matrix

| Tool | Shareable URL | User Testing | Automatable | Customizability | Starting Price |
|---|---|---|---|---|---|
| Figma Native Prototypes | Yes | Yes (all platforms) | No | Medium | Free |
| Figma Make | Limited | Partial | No | High | $15/mo (Figma Pro) |
| Anima | Yes | Yes | Partial | High | $24/mo |
| Locofy | Yes | Yes | Partial | High | $399/yr |
| Builder.io | Yes | Yes | Partial | Very High | Free |
| TeleportHQ | Yes | Yes | No | Medium | Free |
| ProtoPie | Yes | Yes | No | Very High | $67/mo |
| Framer | Yes | Yes | No | High | Free |
| v0.dev | Yes | Yes | Partial | High | Free (Premium $20/mo) |
| Claude Code + MCP | Yes (manual deploy) | Yes | Partial | Very High | API costs |
| Supernova.io | Indirect | Indirect | Partial | High | Free |

---

## 11. Recommendations for FigForge Integration

Given the FigForge framework context, the most promising approaches for automated prototype generation are:

### Immediate (Low Effort)
1. **Use Figma native prototype URLs** -- construct URLs programmatically from file key + node IDs obtained via REST API. These work directly with all testing platforms.
2. **Use `figma_execute` in figma-console-mcp** to run `setReactionsAsync` calls, creating prototype connections between frames programmatically.

### Medium-Term (Moderate Effort)
3. **Build a Claude Code workflow** that reads Figma designs via the MCP server, generates interactive HTML/React prototypes, and deploys to Vercel. Return the shareable URL.
4. **Create an n8n workflow** triggered by Figma webhooks that auto-generates prototypes on design version updates.

### Long-Term (High Effort)
5. **Build a custom MCP server** that wraps the Figma Plugin API's prototyping capabilities (reactions, flows, transitions) and exposes them as dedicated tools.
6. **Create a full automation pipeline** (Figma webhook --> code generation --> deploy --> URL --> testing platform) as described in section 9.7.

---

## Sources

### Figma-to-Prototype Tools
- [Anima Pricing](https://www.animaapp.com/pricing)
- [Locofy Pricing](https://www.locofy.ai/pricing)
- [Builder.io Pricing](https://www.builder.io/m/pricing)
- [TeleportHQ Pricing](https://teleporthq.io/pricing)
- [ProtoPie for Figma](https://www.protopie.io/figma)
- [Figma Make AI Interactive Prototype Generator](https://www.figma.com/solutions/ai-interactive-prototype-generator/)
- [v0.dev - Working with Figma](https://vercel.com/blog/working-with-figma-and-custom-design-systems-in-v0)
- [Figma Plans & Pricing](https://www.figma.com/pricing/)

### Figma API Documentation
- [Figma Plugin API - Reactions](https://developers.figma.com/docs/plugins/api/properties/nodes-reactions/)
- [Figma REST API Changelog](https://developers.figma.com/docs/rest-api/changelog/)
- [Figma REST API File Endpoints](https://developers.figma.com/docs/rest-api/file-endpoints/)
- [Figma Webhooks](https://developers.figma.com/docs/rest-api/webhooks/)
- [Figma Embed Kit](https://www.figma.com/developers/embed)
- [Figma Plugin Example - Prototype Write](https://github.com/adispezio/figma-plugin-example-prototype-write)

### MCP Servers
- [figma-console-mcp Documentation](https://docs.figma-console-mcp.southleft.com/)
- [figma-console-mcp GitHub](https://github.com/southleft/figma-console-mcp)
- [Official Figma MCP Server Tools](https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/)
- [Figma MCP Server Guide](https://github.com/figma/mcp-server-guide)

### User Testing Platforms
- [UserTesting + Figma Integration](https://help.figma.com/hc/en-us/articles/19790203466263-Test-your-prototypes-with-UserTesting)
- [UserZoom + Figma Best Practices](https://help.usertesting.com/hc/en-us/articles/11931097364765-Figma-prototypes-with-UserZoom-Best-practices)
- [Maze + Figma Integration](https://maze.co/integrations/figma/)
- [Maze Pricing](https://maze.co/pricing/)
- [Figma + Maze Help](https://help.figma.com/hc/en-us/articles/360041246514-Test-your-Figma-prototypes-with-Maze)

### Automation
- [n8n Figma Trigger Integration](https://n8n.io/integrations/figma-trigger-beta/)
- [Figma Webhook Types](https://developers.figma.com/docs/rest-api/webhooks-types/)
- [Continuous Design Plugin](https://www.figma.com/community/plugin/977948326423807703/continuous-design-run-ci-from-figma)
- [Figma Action - GitHub Marketplace](https://github.com/marketplace/actions/figma-action)
- [figma-export CLI](https://github.com/marcomontalbano/figma-export)

### AI/Emerging Approaches
- [Claude Code to Figma Blog](https://www.figma.com/blog/introducing-claude-code-to-figma/)
- [Claude Code + Figma MCP Server](https://www.builder.io/blog/claude-code-figma-mcp-server)
- [Jane Street - Designing with Claude](https://blog.janestreet.com/i-design-with-claude-code-more-than-figma-now-index/)
- [html.to.design - From Claude to Figma via MCP](https://html.to.design/blog/from-claude-to-figma-via-mcp/)
- [Figma AI - Make Interactions](https://help.figma.com/hc/en-us/articles/24004778051479-Make-interactions-with-AI)
- [AI Prototyping & UX Tools 2026](https://vibecoding.app/blog/ai-prototyping-ux-tools)
- [Bridging Design and Code with v0](https://vercel.com/blog/bridging-the-gap-between-design-and-code-with-v0)
- [Figma Plugins Comparison](https://www.pixelperfecthtml.com/figma-to-code-plugins-anima-vs-locofy-vs-hand-coding/)
- [Top Figma-to-Code Tools 2026](https://www.softspell.ai/blog/best-figma-to-code-tools)
