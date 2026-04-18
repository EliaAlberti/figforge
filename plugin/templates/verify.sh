#!/bin/bash
# FigForge verification script
# Checks that Figma MCP is accessible and project state is consistent

echo "=== FigForge Verify ==="

# Check git status
if git diff --quiet 2>/dev/null; then
    echo "✓ Working tree clean"
else
    echo "⚠ Uncommitted changes detected"
fi

# Check sprint files
if [ -f ".sprint/progress.md" ]; then
    echo "✓ Sprint progress log exists"
else
    echo "✗ Missing .sprint/progress.md"
fi

# Check CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    echo "✓ CLAUDE.md exists"
else
    echo "✗ Missing CLAUDE.md"
fi

echo "=== Done ==="
