# Figma MCP Reference

Complete reference for **figma-console-mcp** (by southleft) — the MCP server that FigForge uses to interact with Figma.

## Installation

### NPX (recommended)

```bash
claude mcp add figma-console -- npx -y figma-console-mcp
```

### For Local Mode

Local Mode requires the Desktop Bridge plugin running in Figma Desktop:

1. Clone the figma-console-mcp repository
2. Open Figma Desktop
3. Go to Plugins > Development > Import plugin from manifest
4. Select the `manifest.json` from the plugin directory
5. Run the plugin — it will show "Bridge Active" when connected

## Modes

### Local Mode (56+ tools)

- **Connection:** Desktop Bridge plugin must be running in Figma
- **Capabilities:** Full read/write — create, modify, rename, delete elements
- **Detection:** `figma_get_status` returns Local Mode with full tool list
- **Best for:** Active design work, component creation, layer organisation

### Remote Mode (~19 tools)

- **Connection:** Figma REST API via personal access token
- **Capabilities:** Read-only — inspect files, extract specs, read variables
- **Detection:** `figma_get_status` returns Remote Mode with limited tool list
- **Best for:** Spec extraction, audits, documentation

## Tool Reference

### Connection & Status

| Tool | Mode | Description |
|------|------|-------------|
| `figma_get_status` | Both | Check connection mode and available tools |

### Reading File Data

| Tool | Mode | Description |
|------|------|-------------|
| `figma_get_file_data` | Both | **THE primary tool.** Get node tree with full properties. Use verbosity "full" and depth 5+ for detailed inspection. |
| `figma_get_screenshot` | Both | Capture visual screenshot of canvas or specific node |
| `figma_get_comments` | Both | Read comment threads on the file |

### Design System Inspection

| Tool | Mode | Description |
|------|------|-------------|
| `figma_get_variables` | Both | List all design variables/tokens with values |
| `figma_get_styles` | Both | List shared styles (colours, text, effects) |
| `figma_get_components` | Both | List all components with their properties and variants |

### Creating Elements

| Tool | Mode | Description |
|------|------|-------------|
| `figma_create_frame` | Local | Create frames and layouts |
| `figma_create_text` | Local | Add text elements |
| `figma_create_rectangle` | Local | Create shapes and backgrounds |
| `figma_create_component` | Local | Build reusable components |
| `figma_create_instance` | Local | Instantiate library components |

### Modifying Elements

| Tool | Mode | Description |
|------|------|-------------|
| `figma_set_properties` | Local | Set component properties and variants |
| `figma_set_fill` | Local | Apply colours and gradients |
| `figma_set_stroke` | Local | Apply borders |
| `figma_set_effect` | Local | Apply shadows and blurs |
| `figma_set_corner_radius` | Local | Round corners |
| `figma_set_auto_layout` | Local | Configure auto-layout |

### Organising Elements

| Tool | Mode | Description |
|------|------|-------------|
| `figma_rename_node` | Local | Rename any layer, frame, or group |
| `figma_group_nodes` | Local | Group related layers |
| `figma_ungroup_nodes` | Local | Flatten unnecessary groups |
| `figma_move_node` | Local | Reorder layers in the tree |

### Variable Management

| Tool | Mode | Description |
|------|------|-------------|
| `figma_create_variables` | Local | Create new design tokens |
| `figma_update_variables` | Local | Modify existing token values |
| `figma_rename_variable` | Local | Rename tokens |
| `figma_delete_variables` | Local | Remove unused tokens |

### Comments

| Tool | Mode | Description |
|------|------|-------------|
| `figma_post_comment` | Local | Add comments to the file |
| `figma_delete_comment` | Local | Remove comments |

## Common Patterns

### Inspecting a Screen

```
1. figma_get_file_data(file_key, node_id, verbosity="full", depth=5)
2. figma_get_screenshot(file_key, node_id)  // for visual reference
3. figma_get_variables(file_key)  // cross-reference tokens
```

### Creating a Component

```
1. figma_create_component(parent_id, name, width, height)
2. figma_create_text(component_id, content, font, size)
3. figma_set_fill(component_id, color)
4. figma_set_auto_layout(component_id, direction, padding, gap)
5. figma_get_screenshot(file_key, component_id)  // verify
```

### Renaming Layers

```
1. figma_get_file_data(file_key, node_id, depth=10)  // read current tree
2. // Parse layer names against conventions
3. figma_rename_node(node_id_1, new_name_1)
4. figma_rename_node(node_id_2, new_name_2)
5. figma_get_file_data(file_key, node_id, depth=10)  // verify
```

### Auditing Tokens

```
1. figma_get_variables(file_key)  // list all
2. // Categorise and check naming
3. figma_rename_variable(var_id, new_name)  // fix naming
4. figma_delete_variables([unused_var_ids])  // clean up
5. figma_get_variables(file_key)  // verify
```

## Troubleshooting

### "Tool not available"
- Check mode with `figma_get_status` — you may be in Remote Mode
- Write tools require Local Mode with Desktop Bridge active

### "Desktop Bridge not connected"
- Open Figma Desktop (not the web version)
- Run the Desktop Bridge plugin from Plugins menu
- Verify the plugin shows "Bridge Active"
- Restart the MCP server if needed

### "File not found" or "Node not found"
- Verify the file key is correct (from the Figma URL)
- Check that the node ID exists (IDs change when elements are deleted)
- Try a parent node with higher depth

### Tool call fails with error
- Retry with different parameters (adjust depth, verbosity, try parent node)
- NEVER fall back to reading PNGs for measurements
- If persistent, check `figma_get_status` for connection issues
- Report to user if tools are consistently failing

## Critical Rules

1. **`figma_get_file_data` is the primary tool** — use it for all spec extraction
2. **`figma_get_component_image` is NOT for frames** — it only works for library components
3. **PNGs are reference only** — never use them for measurements
4. **Visual > Structure** — trust the screenshot over the layer tree for layout intent
5. **Always verify after writes** — re-read or screenshot to confirm changes applied
