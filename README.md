# dotfiles

Configuration for `fish`, `helix`, and `tmux`, plus some other utilities.

## Install
Installed in the user's home directory:

```bash
cd ~
git init
git remote add origin https://github.com/varuniyer/dotfiles.git
git pull
```

## File tree
```
~
├─ .config/
│  ├─ fish/
│  │  ├─ config.fish — Fish shell config: auto-start tmux, env vars, fzf bindings, aliases, venv auto-activation, starship init, helpers.
│  │  └─ functions/
│  │     └─ kube_functions.fish — kubectl wrappers and completions for pods and YAML.
│  ├─ helix/
│  │  ├─ config.toml — helix editor settings and keymaps.
│  │  ├─ languages.toml — Language setup for cpp, python, rust, LSPs like clangd, ruff, basedpyright, and formatting.
│  │  └─ themes/
│  │     └─ catppuccin_mocha_transparent.toml — Transparent Catppuccin theme override.
│  └─ starship.toml — starship prompt with Catppuccin palette and segmented modules.
│
├─ .python_scripts/
│  ├─ pyproject.toml — Local Python package meta and tooling config.
│  ├─ rp.py — Interactive regex replace across git-tracked files.
│  ├─ yf.py — Concatenate files and copy via OSC52 through fish function yi.
│  └─ yg.py — Copy all git-tracked files via OSC52.
│
├─ .restic-excludes.txt — Exclude patterns for restic backups.
├─ .gitignore — Ignore all except whitelisted configs and scripts.
└─ .gitmodules — Definitions for tmux plugin dependencies.
```

## Notes
- `config.fish` sources `~/.config/fish/env.fish` for machine-specific environment.
- Common tools referenced: `fzf`, `kubectl`, `restic`, `uv`.

