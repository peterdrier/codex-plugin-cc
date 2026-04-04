#!/bin/bash
# PreToolUse hook: block direct "codex" CLI invocations and redirect to the plugin.

# jq is expected but not a hard dependency — pass through if unavailable.
command -v jq &>/dev/null || exit 0

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Match bare "codex" at the start of the command or after a pipe/semicolon/&&
# "codex-companion" won't match because \s requires whitespace after "codex".
if echo "$COMMAND" | grep -qE '(^|[;&|]\s*)codex\s'; then
  echo "Do not call the codex CLI directly. Use the codex plugin instead: /codex:rescue for tasks, /codex:review for reviews, /codex:status for status, /codex:result for results." >&2
  exit 2
fi

exit 0
