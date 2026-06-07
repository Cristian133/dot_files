# dot_files

Entorno de desarrollo personal para Debian/Ubuntu — zsh, neovim, tmux, git, node.

## Requisitos

- Debian / Ubuntu / Xubuntu
- `bash`, `git`, `curl`

## Instalación

```bash
git clone https://github.com/Cristian133/dot_files.git
cd dot_files
./setup_system.sh
```

El script pregunta interactivamente qué componentes instalar. Podés ejecutar cada parte por separado:

| Script | Qué hace |
|--------|----------|
| `env/exports.sh` | Define variables de entorno necesarias (`DEV`, `FONTS_PATH`, versiones de NVM/Node) |
| `sh/install_deps.sh` | Instala paquetes del sistema, Rust |
| `sh/install_dotfiles.sh` | Copia los configs a `$HOME` |
| `sh/install_neovim.sh` | Compila e instala Neovim desde fuente |
| `sh/install_vim.sh` | Compila e instala Vim desde fuente |
| `sh/install_git.sh` | Compila e instala Git desde fuente |
| `sh/install_fonts.sh` | Instala NerdFonts (CascadiaMono) |
| `sh/install_zsh.sh` | Instala Oh My Zsh + Starship |
| `sh/install_tmux.sh` | Instala TPM y plugins de tmux |
| `sh/install_node.sh` | Instala NVM + Node.js |

### Variables de entorno requeridas

Antes de instalar, definir en `env/exports.sh`:

```bash
export DEV="$HOME/dev"
export FONTS_PATH="$HOME/.local/share/fonts/"   # Ubuntu
# export FONTS_PATH="$HOME/.fonts/"             # Debian
export NVM_VERSION="0.40.1"
export NODE_DEFAULT_VERSION="v20.18.1"
```

### Secrets

Los tokens y credenciales **no van en el repo**. Crear `~/.env.local` (no versionado) y poner ahí las variables sensibles. El `.zshrc` lo carga automáticamente al iniciar la shell.

## Qué se instala

### Zsh

- **Oh My Zsh** con plugins: `git`, `history-substring-search`, `colored-man-pages`
- **Starship** como prompt
- NVM con carga lazy (no ralentiza el arranque de la shell)
- Completado de Angular CLI cacheado en `~/.cache/zsh/`

### Neovim

Config basada en Lua con [lazy.nvim](https://github.com/folke/lazy.nvim). Ver [`nvim/README.md`](nvim/README.md) para la lista completa de plugins y [`nvim/KEYMAPS.md`](nvim/KEYMAPS.md) para la referencia de keybindings.

Leader key: `,`

### Tmux

- Prefijo: `Alt-q`
- Plugins: Dracula theme, tmux-resurrect, tmux-continuum (auto-save cada 15 min)
- Clipboard integrado con Wayland (`wl-copy`)
- Navegación vi-style entre panes

### Git

- Pager: `delta` (diff side-by-side con syntax highlight)
- `pull.rebase = true`, `rerere` habilitado
- Aliases útiles: `git s`, `git l`, `git lg`, `git cm`, `git undo`, `git wip`

## Tests

La suite corre sin red ni sudo — todo usa directorios temporales y stubs de red.

```bash
bash tests/run_all.sh
```

| Test file | Tests | Cubre |
|-----------|------:|-------|
| `test_setup_system.sh` | 45 | flujo interactivo, mappings pregunta→script, integración |
| `test_install_dotfiles.sh` | 32 | copia de dotfiles, idempotencia, sobreescritura |
| `test_install_vim.sh` | 56 | vimrc, colorscheme, vim-sml, directorio incorrecto |
| `test_install_fonts.sh` | 11 | wget mockeado, FONTS_PATH, limpieza del zip |
| `test_install_node.sh` | 19 | NVM, versión de Node, paquetes globales, XDG |
| `test_install_tmux.sh` | 8 | git clone TPM, copia condicional de tmux.conf |
| `test_exports.sh` | 12 | valores de env vars, export a subshells |
| `test_extract_all.sh` | 15 | archivos reales zip/tar/gz/bz2/xz |
| `test_move_up.sh` | 11 | mover archivos, limpiar dirs vacíos, cancelación |
| `test_chperm.sh` | 11 | chmod 755 dirs / 644 archivos, recursivo |
| `test_alias_sh.sh` | 18 | aliases, EDITOR, función `l.` |
| `test_cpipe.sh` | 8 | colorización ANSI, TTYONLY, passthrough |
| **Total** | **246** | |

Para correr un test individual:

```bash
bash tests/test_install_dotfiles.sh
```

## Utilidades en `bin/`

| Script | Descripción |
|--------|-------------|
| `extract_all` | Extrae recursivamente archivos comprimidos (zip, rar, tar, gz, bz2, xz) |
| `move_up` | Mueve archivos un nivel arriba en el árbol de directorios |
| `chpermdir` | Asigna permisos 755 a todos los directorios recursivamente |
| `chpermfile` | Asigna permisos 644 a todos los archivos recursivamente |
