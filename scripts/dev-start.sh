#!/bin/bash
# Multi-project tmux workspace (uses dedicated "main" socket)
# Usage: dev-start.sh [claude|codex|bash]
# Default: bash
#
# If the "work" session already exists, just attach to it.
# Only creates a fresh session when none exists.
#
# Customize the PROJECTS array below with your own project directories.

SESSION=work
CMD=${1:-bash}
T="tmux -L main"

# If session already exists, just attach and exit
if $T has-session -t $SESSION 2>/dev/null; then
    exec $T attach -t $SESSION
fi

# ============================================================
# CUSTOMIZE: Define your project directories below.
# Each window is an array of directories for its panes.
# ============================================================

# Window 1 panes (add/remove entries as needed)
WIN1_NAME="dev"
WIN1_PROJECTS=(
    "$HOME/project-a"
    "$HOME/project-b"
    "$HOME/project-c"
)

# Window 2 panes (add/remove entries as needed)
WIN2_NAME="ops"
WIN2_PROJECTS=(
    "$HOME/project-d"
    "$HOME/project-e"
)

# ============================================================
# Create windows and panes (no need to edit below this line)
# ============================================================

# Window 1
$T new-session -d -s $SESSION -n "$WIN1_NAME" -c "${WIN1_PROJECTS[0]}"
for dir in "${WIN1_PROJECTS[@]:1}"; do
    $T split-window -t $SESSION:"$WIN1_NAME" -h -c "$dir"
done
$T select-layout -t $SESSION:"$WIN1_NAME" tiled

# Window 2
if [ ${#WIN2_PROJECTS[@]} -gt 0 ]; then
    $T new-window -t $SESSION -n "$WIN2_NAME" -c "${WIN2_PROJECTS[0]}"
    for dir in "${WIN2_PROJECTS[@]:1}"; do
        $T split-window -t $SESSION:"$WIN2_NAME" -h -c "$dir"
    done
    $T select-layout -t $SESSION:"$WIN2_NAME" tiled
fi

# Launch command in all panes
for win in "$WIN1_NAME" "$WIN2_NAME"; do
    for pane in $($T list-panes -t $SESSION:"$win" -F '#{pane_id}' 2>/dev/null); do
        $T send-keys -t "$pane" "$CMD" Enter
    done
done

# Show project path in pane borders
$T set -t $SESSION pane-border-status top
$T set -t $SESSION pane-border-format " #{pane_current_path} "

# Start on first window
$T select-window -t $SESSION:"$WIN1_NAME"
$T attach -t $SESSION
