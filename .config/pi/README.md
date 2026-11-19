# Pi Configuration

This directory contains configuration files for the [Pi coding agent](https://github.com/earendil-works/pi-coding-agent).

## Files

- `settings.json` - User preferences (theme, changelog version, etc.)
- `models-store.json` - Cached model metadata from various LLM providers

## Symlinks

The `~/.pi/agent/` directory contains symlinks to these files:
- `~/.pi/agent/settings.json` → `~/.dotfiles/.config/pi/settings.json`
- `~/.pi/agent/models-store.json` → `~/.dotfiles/.config/pi/models-store.json`

This allows versioning of user preferences while keeping the installation directory clean.

## Notes

- `auth.json` is NOT versioned (kept only in `~/.pi/agent/`) as it contains credentials
- The original `settings.json` and `models-store.json` files are backed up as `.bak` files in `~/.pi/agent/`
