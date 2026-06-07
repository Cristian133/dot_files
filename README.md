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

## Utilidades en `bin/`

| Script | Descripción |
|--------|-------------|
| `extract_all` | Extrae recursivamente archivos comprimidos (zip, rar, tar, gz, bz2, xz) |
| `move_up` | Mueve archivos un nivel arriba en el árbol de directorios |
| `chpermdir` | Asigna permisos 755 a todos los directorios recursivamente |
| `chpermfile` | Asigna permisos 644 a todos los archivos recursivamente |
