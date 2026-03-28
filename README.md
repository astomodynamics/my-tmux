# my-tmux

Tmux configuration with session persistence and VS Code isolation.

## Features

- **Session persistence**: Auto-saves every 15 min via tmux-resurrect + continuum
- **OOM protection**: `tmux-safe` wrapper lowers OOM score so the kernel kills other processes first
- **VS Code isolation**: Uses a dedicated socket (`-L main`) so VS Code terminals can't interfere
- **Multi-project workspace**: `dev-start.sh` creates a configurable layout (attaches if session exists)
- **Better terminal ergonomics**: focus events, larger history, current-directory splits, and clipboard-friendly copy helpers
- **Yazi integration**: popup file manager binding plus tmux passthrough settings so Yazi previews can work inside tmux

## Install

```bash
git clone https://github.com/<your-username>/my-tmux.git ~/github/my-tmux
cd ~/github/my-tmux
./install.sh
```

Then open tmux and press `prefix + I` to install TPM plugins.
Edit `scripts/dev-start.sh` with your own project paths, then start the workspace manually with `devstart`.

## Files

| File | Description |
|------|-------------|
| `.tmux.conf` | Main tmux config with plugins and keybindings |
| `scripts/tmux-safe` | Wrapper that uses dedicated socket + OOM protection |
| `scripts/dev-start.sh` | Multi-project workspace launcher (attaches if session exists) |
| `install.sh` | Symlinks configs and adds bashrc integration |

## Key Bindings

| Binding | Action |
|---------|--------|
| `Alt + Arrow` | Switch panes (no prefix) |
| `Shift + Arrow` | Switch windows (no prefix) |
| `prefix + "` / `prefix + -` | Split vertically in the current directory |
| `prefix + %` / `prefix + \|` | Split horizontally in the current directory |
| `prefix + f` | Open Yazi in a popup in the current directory |
| `prefix + y` | Copy the current command line to the system clipboard |
| `prefix + Y` | Copy the current pane working directory |
| `prefix + P` | Toggle pane logging |
| `prefix + M-p` | Save visible pane text |
| `prefix + M-P` | Save full pane history |
| `prefix + Space` | Hint-select paths, SHAs, URLs, and similar tokens |
| `prefix + Ctrl-s` | Manual save session |
| `prefix + Ctrl-r` | Manual restore session |

## Yazi Notes

Yazi isn't installed by this repo, but the tmux config is ready for it.
If `yazi` is on your `PATH`, `prefix + f` opens it in a popup rooted at the current pane directory.
The tmux config also enables passthrough and preserves `TERM` / `TERM_PROGRAM`, which Yazi needs for image preview support inside tmux.
