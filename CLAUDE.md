# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dotfiles for a Debian/Xubuntu development environment. Covers zsh, neovim, vim, tmux, git, node, npm, and fonts. Target OS: Ubuntu/Xubuntu (with some Debian notes in comments).

## Installation

Full setup (interactive, prompts for each component):
```bash
./setup_system.sh
```

Individual scripts in `sh/`:
```bash
bash sh/install_deps.sh      # system packages + rust
bash sh/install_dotfiles.sh  # copy configs to $HOME
bash sh/install_neovim.sh    # compile & install neovim
bash sh/install_vim.sh       # compile & install vim
bash sh/install_zsh.sh       # install oh-my-zsh + starship
bash sh/install_tmux.sh      # install tmux + TPM plugins
bash sh/install_fonts.sh     # install NerdFonts to ~/.local/share/fonts/
bash sh/install_node.sh      # NVM + node
bash sh/install_git.sh       # compile git from source
```

Environment variables needed before installing (see `env/exports.sh`):
- `DEV` — base development path
- `FONTS_PATH` — `~/.local/share/fonts/` (Ubuntu) or `~/.fonts/` (Debian)
- `NVM_VERSION` — currently `0.40.5`
- `NODE_DEFAULT_VERSION` — currently `v22.22.3` (LTS Jod)

## How dotfiles are deployed

`sh/install_dotfiles.sh` **copies** (not symlinks) files to `$HOME`. Editing files in the repo does not affect the live config — you must re-run the install script or copy manually. Tracked files and their destinations:

| Repo path | Destination |
|-----------|-------------|
| `git/gitconfig` | `~/.gitconfig` |
| `nano/nanorc` | `~/.nanorc` |
| `zsh/zshrc` | `~/.zshrc` |
| `zsh/alias.sh` | `~/.alias.sh` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `htop/htoprc` | `~/.config/htop/htoprc` |

The `nvim/` directory is meant to be placed at `~/.config/nvim/`.

## Neovim architecture

Entry point: `nvim/init.lua` — loads `lazy.nvim`, then requires `keymaps`, `options`, two legacy vimscript files (`functions.vim`, `keymaps.vim`), and sets up plugins.

Plugin structure:
- `nvim/lua/plugins/` — one file per plugin (lazy.nvim spec format)
- `nvim/lua/keymaps.lua` — **single source of truth for all keymaps** (leader = `,`)
- `nvim/lua/options.lua` — editor options (4-space tabs, swapfile/backup/undo in `~/.config/nvim/.swp/`, `.bkp/`, `.undo/`)
- `nvim/lua/functions.vim` / `nvim/lua/keymaps.vim` — legacy vimscript helpers

Plugin manager: **lazy.nvim** (`:Lazy` to open). Active plugins:
`alpha`, `autoclose`, `bufferline`, `nvim-cmp` + `luasnip`, `conform`, `nvim-lint`, `nvim-dap` + `dap-ui`, `fugitive`, `gitsigns`, `indent-blankline`, `LSP` (mason + lspconfig), `lualine`, `render-markdown`, `marks`, `neo-tree`, `nvim-surround`, `telescope`, `tokyonight`, `treesitter`, `trouble`, `which-key`, `Comment.nvim`

LSP servers (managed by Mason): `lua_ls`, `ts_ls`, `clangd`, `zls`, `rust_analyzer`, `omnisharp`, `angularls`  
Formatters (conform): `stylua` (Lua). Linters (nvim-lint): `cpplint` (C/C++)  
DAP adapter: `coreclr` (C# / .NET via `netcoredbg`)

Key neovim shortcuts (leader = `,`):
- `,zf` — find files, `,zg` — live grep (Telescope)
- `,f` — Neo-tree sidebar, `,ff` — Neo-tree float
- `,F` — format buffer (conform), `,ca` — code actions
- `,xx` — project diagnostics (Trouble), `,db` — toggle breakpoint
- `F5`/`F6`/`F7`/`F8` — DAP continue/step-over/step-into/step-out
- Full keymap reference: `nvim/KEYMAPS.md`

## Zsh setup

`zsh/zshrc` uses **Oh My Zsh** with plugins: `git history-substring-search colored-man-pages`, and **Starship** as the prompt (`eval "$(starship init zsh)"`).

History: `HISTSIZE=50000`, deduplication via `HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY`.

NVM is lazy-loaded (not sourced on shell start) — first invocation of `nvm`, `node`, `npm`, `npx`, `yarn`, or `pnpm` triggers the load.

Angular CLI completion is cached to `~/.cache/zsh/ng-completion.zsh` and only regenerated when the `ng` binary changes.

Bun and Deno are sourced at shell start if installed (`~/.bun` / `~/.deno`).

Secrets (tokens, credentials) must go in `~/.env.local` (not versioned). The zshrc loads it automatically at the end if the file exists.

## Tmux setup

Prefix: `Alt-q` (replaces default `Ctrl-b`)  
Plugin manager: TPM (`~/.tmux/plugins/tpm`)  
Plugins: `dracula/tmux` (theme, shows cpu/ram), `tmux-resurrect`, `tmux-continuum` (auto-save every 15 min, auto-restore)  
Clipboard: Wayland (`wl-copy` / `wl-paste`)  
Pane navigation: `prefix + h/j/k/l` or arrow keys  
Window navigation: `Alt-left/right` or `Alt-h/Alt-l` (no prefix needed)  
Splits: `prefix + |` (horizontal), `prefix + -` (vertical), both open in current pane's directory

## Git config highlights

- Pager: `delta` (side-by-side diff, line numbers, `base16` syntax theme)
- `pull.rebase = true`, `rebase.autoSquash = true`, `rebase.autoStash = true`
- `rerere.enabled = true` — remembers conflict resolutions
- `fetch.all = true`, `fetch.prune = true`
- Credential cache: 8 hours (`--timeout=28800`)
- Common aliases: `git s`, `git l`/`git lg` (pretty log), `git cm`, `git co`, `git undo` (reset HEAD~1 --mixed), `git cane` (amend no-edit), `git wip`

## Utility scripts in `bin/`

- `extract_all` — recursively extracts zip/rar/tar/gz/bz2/xz archives in the current directory
- `move_up` — moves files up one directory level
- `chpermdir` / `chpermfile` — bulk permission fixers (755 dirs / 644 files)
- `colors.sh` — terminal color test
- `cpipe` — clipboard pipe helper
