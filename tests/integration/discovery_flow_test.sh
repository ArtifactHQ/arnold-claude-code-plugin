#!/bin/sh
# Integration tests for the discovery flow.
# These tests validate that the plugin's agent definition, commands, and hooks
# contain the correct guidance for Claude Code to use discovery tools properly.
#
# These are content-based tests — they verify that the right instructions exist
# in the plugin files so that Claude Code will behave correctly when interacting
# with Arnold's discovery MCP tools.
#
# Requires: grep
# Exit 0 on all checks passing, 1 on any failure.

set -e

PLUGIN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
AGENT="$PLUGIN_ROOT/agents/arnold.md"
CMD_NEW="$PLUGIN_ROOT/commands/arnold-new.md"
CMD_STATUS="$PLUGIN_ROOT/commands/arnold-status.md"
CMD_BUILD="$PLUGIN_ROOT/commands/arnold-build.md"
HOOKS="$PLUGIN_ROOT/hooks/hooks.json"
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

check_contains() {
  file="$1"
  pattern="$2"
  label="$3"
  if grep -q "$pattern" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

# =============================================================================
printf "New Product Creation\n"
printf "====================\n\n"

# /arnold:new triggers create_product
check_contains "$CMD_NEW" "create_product" \
  "/arnold:new references create_product tool"

# Product overview is presented conversationally
check_contains "$CMD_NEW" "Personas" \
  "/arnold:new instructs to present personas"
check_contains "$CMD_NEW" "open questions" \
  "/arnold:new instructs to surface open questions"

# Agent handles "I want to build..." naturally
check_contains "$AGENT" "create_product" \
  "Agent references create_product for new product ideas"
check_contains "$AGENT" "I want to build" \
  "Agent recognizes 'I want to build...' as discovery trigger"

# =============================================================================
printf "\nDiscovery Exploration\n"
printf "=====================\n\n"

# After create_product, explore tools are available
check_contains "$AGENT" "explore_persona" \
  "Agent references explore_persona tool"
check_contains "$AGENT" "explore_capability" \
  "Agent references explore_capability tool"
check_contains "$AGENT" "what_if" \
  "Agent references what_if tool"
check_contains "$AGENT" "get_history" \
  "Agent references get_history tool"

# Persona questions trigger explore_persona
check_contains "$AGENT" "Questions about a user type" \
  "Agent maps user type questions to explore_persona"

# Feature questions trigger explore_capability
check_contains "$AGENT" "Questions about a feature" \
  "Agent maps feature questions to explore_capability"

# "What if" triggers what_if
check_contains "$AGENT" "What if" \
  "Agent maps 'what if' to what_if tool"

# History triggers get_history
check_contains "$AGENT" "What did we change" \
  "Agent maps history questions to get_history tool"

# Open questions are woven into conversation
check_contains "$AGENT" "open_questions" \
  "Agent handles open_questions from discovery tools"

# =============================================================================
printf "\nDiscovery to Execution Transition\n"
printf "==================================\n\n"

# "Let's build this" triggers transition
check_contains "$AGENT" "let's build this" \
  "Agent recognizes 'let's build this' as execution trigger"

# describe_product summary before execution
check_contains "$AGENT" "describe_product" \
  "Agent uses describe_product to confirm before building"

# /arnold:build suggests exploring if spec is fresh
check_contains "$CMD_BUILD" "haven't reviewed or refined" \
  "/arnold:build suggests exploration for fresh specs"
check_contains "$CMD_BUILD" "single revision" \
  "/arnold:build checks for single-revision specs"

# =============================================================================
printf "\nStatus During Discovery\n"
printf "=======================\n\n"

# /arnold:status with spec but no tasks shows discovery guidance
check_contains "$CMD_STATUS" "discovery phase" \
  "/arnold:status handles discovery phase (no tasks)"
check_contains "$CMD_STATUS" "continue exploring" \
  "/arnold:status suggests continuing exploration when no tasks"

# =============================================================================
printf "\nSessionStart Scenarios\n"
printf "======================\n\n"

# No product → shows "describe your idea" prompt
check_contains "$HOOKS" "Describe your product idea" \
  "SessionStart: no product → describe idea prompt"

# Product in discovery → shows "continue exploring" prompt
check_contains "$HOOKS" "continue exploring" \
  "SessionStart: product in discovery → continue exploring prompt"

# Product in execution → shows progress
check_contains "$HOOKS" "arnold:status" \
  "SessionStart: product in execution → status prompt"

# =============================================================================
printf "\nRe-entry to Discovery\n"
printf "=====================\n\n"

# User can return to discovery mid-build
check_contains "$AGENT" "return to discovery" \
  "Agent supports re-entering discovery from execution"
check_contains "$AGENT" "pre-build or mid-build" \
  "Agent confirms propose_change works in both phases"

# =============================================================================
printf "\nTone Guidance\n"
printf "=============\n\n"

# Discovery tone is collaborative
check_contains "$AGENT" "brainstorming session" \
  "Agent frames discovery as collaborative brainstorming"
check_contains "$AGENT" "do not rush toward execution" \
  "Agent avoids rushing user through discovery"
check_contains "$AGENT" "tell their story" \
  "Agent presents personas as stories, not data"

# Summary
printf "\n=======================\n"
printf "Results: %d passed, %d failed\n" "$PASS" "$FAIL"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
