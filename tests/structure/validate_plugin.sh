#!/bin/sh
# Validate Arnold Claude Code plugin structure and file integrity.
# Requires: jq
# Exit 0 on all checks passing, 1 on any failure.

set -e

PLUGIN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0
FAIL=0

pass() {
  PASS=$((PASS + 1))
  printf "  PASS: %s\n" "$1"
}

fail() {
  FAIL=$((FAIL + 1))
  printf "  FAIL: %s\n" "$1"
}

check_file_exists() {
  if [ -f "$PLUGIN_ROOT/$1" ]; then
    pass "$1 exists"
  else
    fail "$1 missing"
  fi
}

check_valid_json() {
  if jq empty "$PLUGIN_ROOT/$1" > /dev/null 2>&1; then
    pass "$1 is valid JSON"
  else
    fail "$1 is not valid JSON"
  fi
}

check_json_field() {
  file="$1"
  field="$2"
  value=$(jq -r "$field" "$PLUGIN_ROOT/$file" 2>/dev/null)
  if [ -n "$value" ] && [ "$value" != "null" ]; then
    pass "$file has $field = $value"
  else
    fail "$file missing $field"
  fi
}

# --- Checks ---

printf "Plugin Structure Validation\n"
printf "===========================\n\n"

# plugin.json
printf "plugin.json\n"
check_file_exists "plugin.json"
check_valid_json "plugin.json"
check_json_field "plugin.json" ".name"
check_json_field "plugin.json" ".description"
check_json_field "plugin.json" ".version"

# MCP server config
printf "\nmcp-servers/arnold.json\n"
check_file_exists "mcp-servers/arnold.json"
check_valid_json "mcp-servers/arnold.json"
check_json_field "mcp-servers/arnold.json" ".arnold.command"
check_json_field "mcp-servers/arnold.json" ".arnold.args"

# Agent definition
printf "\nagents/arnold.md\n"
check_file_exists "agents/arnold.md"
if head -1 "$PLUGIN_ROOT/agents/arnold.md" | grep -q "^---"; then
  pass "agents/arnold.md has YAML frontmatter"
else
  fail "agents/arnold.md missing YAML frontmatter"
fi

# Commands
printf "\ncommands/\n"
check_file_exists "commands/arnold-status.md"
check_file_exists "commands/arnold-build.md"
check_file_exists "commands/arnold-drift.md"
check_file_exists "commands/arnold-new.md"
for cmd in arnold-status.md arnold-build.md arnold-drift.md arnold-new.md; do
  if head -1 "$PLUGIN_ROOT/commands/$cmd" | grep -q "^---"; then
    pass "commands/$cmd has YAML frontmatter"
  else
    fail "commands/$cmd missing YAML frontmatter"
  fi
done

# Hooks
printf "\nhooks/hooks.json\n"
check_file_exists "hooks/hooks.json"
check_valid_json "hooks/hooks.json"
check_json_field "hooks/hooks.json" ".hooks[0].matcher"

# Settings
printf "\n.claude/settings.json\n"
check_file_exists ".claude/settings.json"
check_valid_json ".claude/settings.json"
check_json_field ".claude/settings.json" ".permissions.allow[0]"

# README
printf "\nREADME.md\n"
check_file_exists "README.md"

# Agent definition: discovery guidance
printf "\nagents/arnold.md discovery support\n"
if grep -q "Discovery Mode" "$PLUGIN_ROOT/agents/arnold.md"; then
  pass "agents/arnold.md has Discovery Mode section"
else
  fail "agents/arnold.md missing Discovery Mode section"
fi
if grep -q "create_product" "$PLUGIN_ROOT/agents/arnold.md"; then
  pass "agents/arnold.md references create_product tool"
else
  fail "agents/arnold.md missing create_product tool reference"
fi

# plugin.json: min_arnold_version updated for discovery tools
printf "\nplugin.json version check\n"
MIN_VERSION=$(jq -r '.min_arnold_version' "$PLUGIN_ROOT/plugin.json" 2>/dev/null)
if [ "$MIN_VERSION" != "0.1.0" ]; then
  pass "plugin.json min_arnold_version updated ($MIN_VERSION)"
else
  fail "plugin.json min_arnold_version still at 0.1.0 — needs update for discovery tools"
fi

# Cross-reference: commands mentioned in README
printf "\nCross-references\n"
for cmd in arnold:status arnold:build arnold:drift arnold:new; do
  if grep -q "$cmd" "$PLUGIN_ROOT/README.md"; then
    pass "README.md references $cmd"
  else
    fail "README.md missing reference to $cmd"
  fi
done

# Summary
printf "\n===========================\n"
printf "Results: %d passed, %d failed\n" "$PASS" "$FAIL"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
