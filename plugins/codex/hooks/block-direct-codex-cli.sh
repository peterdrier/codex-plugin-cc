#!/bin/bash
# PreToolUse hook: block direct "codex" CLI invocations and redirect to the plugin.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Match bare "codex" at the start of the command or after a pipe/semicolon/&&
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)codex\s'; then
  # Allow calls that go through the plugin's own companion script
  if echo "$COMMAND" | grep -q 'codex-companion\.mjs'; then
    exit 0
  fi
  echo "Do not call the codex CLI directly. Use the codex plugin instead: /codex:rescue for tasks, /codex:review for reviews, /codex:status for status, /codex:result for results." >&2
  exit 2
fi

exit 0
