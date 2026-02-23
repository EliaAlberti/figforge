#!/bin/bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo -e "${CYAN}${BOLD}FigForge — Init Project${NC}"
echo -e "${CYAN}=======================${NC}"
echo ""

# Copy CLAUDE.md template
if [ -f "CLAUDE.md" ]; then
    echo -e "CLAUDE.md already exists. Overwrite? (y/n)"
    read -r answer
    if [ "$answer" != "y" ]; then
        echo "Skipping CLAUDE.md"
    else
        cp "$REPO_DIR/templates/CLAUDE.md" ./CLAUDE.md
        echo -e "${GREEN}✓${NC} CLAUDE.md created"
    fi
else
    cp "$REPO_DIR/templates/CLAUDE.md" ./CLAUDE.md
    echo -e "${GREEN}✓${NC} CLAUDE.md created"
fi

# Create sprint directory
mkdir -p .sprint
if [ ! -f ".sprint/current.json" ]; then
    cp "$REPO_DIR/templates/sprint/current.json" .sprint/
    echo -e "${GREEN}✓${NC} Sprint tracking initialised"
fi

if [ ! -f ".sprint/progress.md" ]; then
    cat > .sprint/progress.md << EOF
# Sprint Progress

**Started:** $(date +%Y-%m-%d)

---

EOF
    echo -e "${GREEN}✓${NC} Progress log created"
fi

# Copy verify script
mkdir -p scripts
if [ ! -f "scripts/verify.sh" ]; then
    cp "$REPO_DIR/templates/verify.sh" scripts/
    chmod +x scripts/verify.sh
    echo -e "${GREEN}✓${NC} verify.sh created"
fi

# Init Beads if available
if command -v bd >/dev/null 2>&1; then
    if [ ! -d ".beads" ]; then
        bd init 2>/dev/null || true
        echo -e "${GREEN}✓${NC} Beads initialised"
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}Project initialised!${NC}"
echo ""
echo -e "Edit CLAUDE.md to fill in your project details, then:"
echo -e "  claude"
echo -e "  \"spin up the Figma team\""
echo ""
