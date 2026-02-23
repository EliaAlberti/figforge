#!/bin/bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${CYAN}${BOLD}FigForge — Install${NC}"
echo -e "${CYAN}==================${NC}"
echo ""

# Prerequisites
echo -e "${BOLD}Checking prerequisites...${NC}"

command -v claude >/dev/null 2>&1 || { echo -e "${RED}✗ Claude Code not found. Install: https://code.claude.com${NC}"; exit 1; }
echo -e "${GREEN}✓${NC} Claude Code"

command -v git >/dev/null 2>&1 || { echo -e "${RED}✗ git not found${NC}"; exit 1; }
echo -e "${GREEN}✓${NC} git"

# Check for Beads
if command -v bv >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Beads CLI"
else
    echo -e "${YELLOW}⚠ Beads CLI not found. Install with: brew install beads${NC}"
    echo -e "${YELLOW}  Persistence will use .sprint/ fallback${NC}"
fi

echo ""

# Enable Agent Teams
echo -e "${BOLD}Enabling Agent Teams...${NC}"
claude config set env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS 1 2>/dev/null || true
echo -e "${GREEN}✓${NC} Agent Teams enabled"

echo ""

# Install teammates
echo -e "${BOLD}Installing Figma Design teammates...${NC}"
mkdir -p "$HOME/.claude/teammates/design"
cp teammates/design/*.md "$HOME/.claude/teammates/design/"
echo -e "${GREEN}✓${NC} $(ls teammates/design/*.md | wc -l | tr -d ' ') design teammates installed"

echo -e "${BOLD}Installing FigJam teammates...${NC}"
mkdir -p "$HOME/.claude/teammates/figjam"
cp teammates/figjam/*.md "$HOME/.claude/teammates/figjam/"
echo -e "${GREEN}✓${NC} $(ls teammates/figjam/*.md | wc -l | tr -d ' ') FigJam teammates installed"

echo ""

# Install skills
echo -e "${BOLD}Installing skills...${NC}"
for skill_dir in skills/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$HOME/.claude/skills/$skill_name"
    cp "$skill_dir"SKILL.md "$HOME/.claude/skills/$skill_name/"
    echo -e "${GREEN}✓${NC} $skill_name"
done

echo ""

# Check for figma-console-mcp
echo -e "${BOLD}Checking Figma MCP...${NC}"
if claude mcp list 2>/dev/null | grep -qi "figma"; then
    echo -e "${GREEN}✓${NC} Figma MCP server detected"
else
    echo -e "${YELLOW}⚠ figma-console-mcp not detected. Install with:${NC}"
    echo -e "${YELLOW}  claude mcp add figma-console -- npx -y figma-console-mcp${NC}"
    echo -e "${YELLOW}  For Local Mode (full capabilities): also install the Desktop Bridge plugin${NC}"
fi

echo ""
echo -e "${GREEN}${BOLD}FigForge installed successfully!${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. cd into your Figma project directory"
echo -e "  2. Run: bash $(dirname "$0")/init-project.sh"
echo -e "  3. Open Claude Code: claude"
echo -e "  4. Say: \"spin up the Figma team\""
echo ""
