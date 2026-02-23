---
name: figma-layer-organization
description: "Rename, reorganise, and clean up Figma layers. Use when preparing files for handoff or enforcing design system naming conventions."
---

# Figma Layer Organisation

## When to Use
- Preparing files for developer handoff
- Enforcing naming conventions
- Post-design-exploration cleanup

## Default Convention
- Layers: `[Type]/[Category]/[Name]—[State]`
- Variables: `[scope]/[category]/[property]`
- Components: `[Category]/[Name]`

## Process
1. Audit: `figma_get_file_data` depth 10+
2. Identify: generic names, inconsistent casing, unnecessary nesting, hidden layers
3. Plan: generate rename table
4. Execute (Local) or report (Remote)
5. Verify: re-read the tree
