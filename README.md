# dotfiles

Configuration for `nushell`, `helix`, and `tmux`, plus some other utilities.

## Install
Installed in the user's home directory:

```bash
cd ~
git init -b main
git remote add origin https://github.com/varuniyer/dotfiles.git
git pull origin main
```

## File tree
```
~
├─ .config/
│  ├─ nushell/
│  │  ├─ config.nu — Nushell config: auto-start tmux, vi mode and keybindings, aliases, venv auto-activation, starship init, helpers (yank, restic, regex replace).
│  │  └─ kube.nu — kubectl wrappers and pod/YAML completions.
│  ├─ helix/
│  │  ├─ config.toml — helix editor settings and keymaps.
│  │  ├─ languages.toml — Language setup for cpp, python, rust, LSPs like clangd, ruff, basedpyright, and formatting.
│  │  └─ themes/
│  │     └─ catppuccin_mocha_transparent.toml — Transparent Catppuccin theme override.
│  ├─ io.datasette.llm/
│  │  └─ extra-openai-models.yaml — Extra model definitions for the `llm` CLI.
│  └─ starship.toml — starship prompt with Catppuccin palette and segmented modules.
│
├─ .tmux.conf — tmux settings and key bindings.
├─ .restic-excludes.txt — Exclude patterns for restic backups.
├─ .gitignore — Ignore all except whitelisted configs.
├─ .gitattributes — Language overrides for GitHub Linguist.
├─ LICENSE
└─ README.md
```

## Helpers
Defined in `config.nu` (replacing the former `.python_scripts/`):

- `r b|s|p|f [extra]` — restic backup / snapshots / prune / forget.
- `yf <files>` / `yg` — Concatenate files (or all git-tracked files) and copy to the tmux clipboard.
- `yi` — Copy stdin to the tmux clipboard.
- `rp <pattern> <repl>` — Interactive regex replace across git-tracked files.
- `u` — Upgrade brew packages and uv tools.
- `hxn` / `hxs` / `hxk` — Edit `config.nu` / `secrets.nu` / `kube.nu`, then reload the shell.

## Notes
- `config.nu` sources `~/.config/nushell/secrets.nu` for machine-specific environment (`RESTIC_REPOSITORY`, `KUBE_NS`, `NET_ID`). It is gitignored.
- Set the kube namespace once per context with `kns`; the wrappers then inherit it.
- Common tools referenced: `kubectl`, `restic`, `uv`, `starship`, `tmux`.
