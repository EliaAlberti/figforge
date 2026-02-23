---
name: figma-spec-extraction
description: "Extract precise design specifications from Figma frames — measurements, colours, typography, spacing, component properties. Use when converting designs to implementation-ready specs."
---

# Figma Spec Extraction

## When to Use
- Creating design handoff documents
- Extracting measurements for implementation
- Auditing visual consistency across screens

## Process

### 1. Get Node Tree
`figma_get_file_data` with verbosity "full", depth 5+

### 2. NEVER Use for Measurements
- `figma_get_component_image` — only works for COMPONENTS, not frames
- PNG screenshots — reference only
- Guessing from visual appearance

### 3. Extraction Order
1. Frame dimensions + padding
2. Auto-layout properties (direction, gap, padding, alignment)
3. Background fills (colour, opacity, gradient)
4. Typography (family, weight, size, line-height, letter-spacing)
5. Spacing between elements
6. Corner radii
7. Shadows and effects
8. Strokes/borders

### 4. Cross-Reference Tokens
`figma_get_variables` — map values to design tokens

### 5. Handle Quirks
- **Visual > Structure:** Trust the screenshot over the layer tree
- **Absolute Positioning:** Note it, recommend auto-layout equivalents
- **Responsive:** Note flexible vs fixed elements
