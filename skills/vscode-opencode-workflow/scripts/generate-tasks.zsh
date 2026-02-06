#!/usr/bin/env zsh
set -eu
setopt pipefail

############################################
# generate-tasks.zsh
#
# Purpose:
#   Generate canonical VS Code tasks for
#   VS Code + OpenCode workflows.
#
# Behavior:
#   - Creates .vscode/tasks.json
#   - Fails if file already exists
#   - Does NOT modify existing files
#
# Scope:
#   Deterministic, editor-first workflows
############################################

VSCODE_DIR=".vscode"
TASKS_FILE="$VSCODE_DIR/tasks.json"

# --- Contract: Standardized Exit Codes ---
EXIT_SUCCESS=0
EXIT_VALIDATION=1
EXIT_EXEC=3

if [[ -f "$TASKS_FILE" ]]; then
  echo "ERROR: $TASKS_FILE already exists." >&2
  echo "Edit it manually if changes are needed." >&2
  exit "$EXIT_VALIDATION"
fi

mkdir -p "$VSCODE_DIR"

cat <<'EOF' > "$TASKS_FILE"
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "OpenCode: Detect Project",
      "type": "shell",
      "command": "scripts/detect-project.zsh",
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "clear": true
      },
      "problemMatcher": []
    },
    {
      "label": "OpenCode: Generate Project Context",
      "type": "shell",
      "command": "scripts/generate-context.zsh",
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "clear": true
      },
      "problemMatcher": []
    },
    {
      "label": "OpenCode: Validate Project Context",
      "type": "shell",
      "command": "scripts/validate-context.zsh",
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "clear": true
      },
      "problemMatcher": []
    },
    {
      "label": "OpenCode: Select Workflow Example",
      "type": "shell",
      "command": "scripts/select-example.zsh",
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated",
        "clear": true
      },
      "problemMatcher": []
    },
    {
      "label": "OpenCode: Full Preflight (Detect + Validate)",
      "dependsOrder": "sequence",
      "dependsOn": [
        "OpenCode: Detect Project",
        "OpenCode: Validate Project Context"
      ],
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
EOF

echo "✔ VS Code tasks generated at $TASKS_FILE"
echo "Use: Cmd/Ctrl + Shift + P → Tasks: Run Task"
