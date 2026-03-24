#!/bin/bash
# Install tmux config, scripts, and plugins
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing tmux config..."

# Symlink .tmux.conf
ln -sf "$REPO_DIR/.tmux.conf" ~/.tmux.conf

# Install scripts
mkdir -p ~/.local/bin
ln -sf "$REPO_DIR/scripts/tmux-safe" ~/.local/bin/tmux-safe
ln -sf "$REPO_DIR/scripts/dev-start.sh" ~/.local/bin/dev-start.sh
chmod +x "$REPO_DIR/scripts/tmux-safe" "$REPO_DIR/scripts/dev-start.sh"

# Install TPM if not present
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Add bashrc integration if not present
if ! grep -q "tmux-safe" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'BASHRC'

# Auto-start tmux workspace (skip in VS Code and other IDE terminals)
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$PS1" ] \
    && [ -z "$VSCODE_RESOLVERAUTHORITY" ] && [ -z "$TERM_PROGRAM_VERSION" ] \
    && [ "$TERM_PROGRAM" != "vscode" ]; then
    tmux -L main attach-session -t work 2>/dev/null || ~/.local/bin/dev-start.sh
fi

# Protect tmux from OOM killer
alias tmux="tmux-safe"
BASHRC
    echo "Added tmux auto-start to ~/.bashrc"
fi

echo "Done! Start tmux with: tmux-safe"
echo "Or run: ~/.local/bin/dev-start.sh"
echo ""
echo "NOTE: Open tmux and press prefix + I to install plugins."
