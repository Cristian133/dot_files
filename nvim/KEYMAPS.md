# Neovim Keymaps

> **Leader key**: `,`

---

## Lazy.nvim (plugin manager)

> Abrir con `:Lazy`. Gestiona la instalación, actualización y carga de todos los plugins.

**Navegación**

| Key | Acción |
|-----|--------|
| `j` / `k` | Moverse entre plugins |
| `gg` / `G` | Ir al primero / último plugin |
| `<CR>` | Expandir/colapsar detalles del plugin |
| `H` | Mostrar ayuda |
| `q` / `<Esc>` | Cerrar el panel |

**Pestañas (filtros)**

| Key | Acción |
|-----|--------|
| `1` / `H` | Home — vista general |
| `2` / `I` | Installed — plugins instalados |
| `3` / `X` | Removed — plugins eliminados |
| `4` / `U` | Update — plugins con actualizaciones |
| `5` / `R` | Runtime — plugins cargados en runtime |
| `6` / `E` | Extras — plugins opcionales |
| `7` / `P` | Profiler — tiempos de carga |
| `8` / `D` | Debug — información de debug |

**Acciones**

| Key | Acción |
|-----|--------|
| `S` | Sync (instalar, actualizar y limpiar) |
| `I` | Instalar plugins pendientes |
| `U` | Actualizar plugins |
| `X` | Limpiar plugins no usados |
| `C` | Verificar actualizaciones disponibles |
| `L` | Ver el log de cambios |
| `R` | Restaurar plugins al estado del lockfile |
| `P` | Ver el profiler de tiempos de carga |
| `<C-f>` | Buscar plugin por nombre |

**Comandos**

| Comando | Acción |
|---------|--------|
| `:Lazy` | Abrir el panel |
| `:Lazy sync` | Instalar, actualizar y limpiar |
| `:Lazy update` | Actualizar todos los plugins |
| `:Lazy install` | Instalar plugins pendientes |
| `:Lazy clean` | Eliminar plugins no usados |
| `:Lazy restore` | Restaurar versiones del lockfile |
| `:Lazy log` | Ver log de cambios |
| `:Lazy profile` | Ver tiempos de carga |

---

## Alpha (dashboard de inicio)

> Se muestra al abrir Neovim sin archivo. Usa el tema `startify`.

**Keybindings internos**

| Key | Acción |
|-----|--------|
| `j` / `k` | Moverse entre items del dashboard |
| `Enter` | Abrir el item seleccionado |
| letras resaltadas | Acceso directo al item (ej: `e` → nuevo archivo) |
| `q` | Cerrar el dashboard |

**Comandos**

| Comando | Acción |
|---------|--------|
| `:Alpha` | Volver al dashboard desde cualquier buffer |

---

## Theme (tokyonight.nvim)

> Plugin puramente visual, no tiene keybindings. Colorscheme activo: `tokyonight` (variante `storm` por defecto).

**Variantes disponibles**

| Comando | Variante |
|---------|----------|
| `:colorscheme tokyonight` | Storm (default) |
| `:colorscheme tokyonight-night` | Night (más oscuro) |
| `:colorscheme tokyonight-moon` | Moon (azul suave) |
| `:colorscheme tokyonight-day` | Day (claro) |

---

## General / Editor

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `ññ` | Insert | Salir a Normal mode (ESC) |
| `, ñ` | Normal | Mostrar/ocultar caracteres invisibles |
| `, <CR>` | Normal | Limpiar highlight de búsqueda |
| `, L` | Normal | Toggle word wrap |
| `, J` | Normal | Ver historial de saltos |
| `, N` | Normal | Cambiar estilo de números de línea |
| `, C` | Normal | Toggle highlight columna 80 |
| `, Q` | Normal | Cerrar buffer (no cierra la ventana) |
| `, ?` | Normal | Mostrar keymaps del buffer (which-key) — ver sección Which-key |
| `gI` | Normal | Ir a la última modificación |
| `gi` | Normal | Ir al último lugar en Insert mode |

---

## Teclas de Función

| Tecla | Modo | Descripción |
|-------|------|-------------|
| `F5` | Normal | DAP: Continuar / Iniciar debug |
| `F6` | Normal | DAP: Step over |
| `F7` | Normal | DAP: Step into |
| `F8` | Normal | DAP: Step out |
| `F9` | Normal/Insert | Guardar y compilar (Build) |
| `F10` | Normal/Insert | Eliminar espacios al final de línea |

---

## Which-key

> Se activa automáticamente al pausar tras un prefijo (ej: `,`). También con `, ?` para ver keymaps del buffer actual.

**Keybindings internos (dentro del popup)**

| Key | Acción |
|-----|--------|
| letras / teclas | Ejecutar el keybinding correspondiente |
| `<BS>` | Volver al nivel anterior |
| `<Esc>` | Cerrar sin ejecutar |
| `<C-d>` | Scroll hacia abajo en la lista |
| `<C-u>` | Scroll hacia arriba en la lista |

---

## Ventanas y Buffers

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `Alt-w` | Normal | Movimientos de ventana (equivalente a `Ctrl-w`) |
| `, <Right>` | Normal | Siguiente buffer |
| `, <Left>` | Normal | Buffer anterior |

---

## Bufferline (bufferline.nvim)

> Muestra los buffers abiertos como pestañas en la parte superior.

**Navegación**

| Key | Acción |
|-----|--------|
| `, <Right>` | Siguiente buffer |
| `, <Left>` | Buffer anterior |
| `gb{n}` | Ir al buffer número `n` (ej: `gb1` → primer buffer) |

**Con el mouse**

| Acción | Resultado |
|--------|-----------|
| Click izquierdo en pestaña | Ir a ese buffer |
| Click medio en pestaña | Cerrar ese buffer |
| Scroll sobre la barra | Moverse entre buffers |

**Comandos**

| Comando | Acción |
|---------|--------|
| `:BufferLinePick` | Seleccionar buffer con letra de acceso directo |
| `:BufferLinePickClose` | Cerrar buffer con letra de acceso directo |
| `:BufferLineCloseLeft` | Cerrar todos los buffers a la izquierda |
| `:BufferLineCloseRight` | Cerrar todos los buffers a la derecha |
| `:BufferLineCloseOthers` | Cerrar todos los buffers excepto el actual |

---

## Lualine (lualine.nvim)

> Plugin puramente visual, no tiene keybindings. Muestra la barra de estado con tema `tokyonight`.

**Información mostrada por defecto**

| Sección | Contenido |
|---------|-----------|
| Izquierda | Modo actual, branch git, diff de cambios, diagnósticos |
| Centro | Nombre del archivo y estado (modificado, solo lectura) |
| Derecha | Tipo de archivo, encoding, formato de línea, posición |

**Comandos**

| Comando | Acción |
|---------|--------|
| `:LualineToggle` | Toggle de la barra de estado |

---

## Treesitter (nvim-treesitter)

> Plugin de análisis sintáctico. Activos: `highlight` e `indent`. No tiene keybindings propios en tu config actual.

**Comandos útiles**

| Comando | Acción |
|---------|--------|
| `:TSInstall {lang}` | Instalar parser para un lenguaje |
| `:TSUninstall {lang}` | Desinstalar parser |
| `:TSUpdate` | Actualizar todos los parsers instalados |
| `:TSBufEnable highlight` | Activar highlight en el buffer actual |
| `:TSBufDisable highlight` | Desactivar highlight en el buffer actual |
| `:TSBufToggle highlight` | Toggle de highlight |
| `:InspectTree` | Ver el árbol sintáctico del buffer actual |
| `:Inspect` | Ver los grupos de highlight bajo el cursor |

> **Nota**: los módulos `textobjects` e `incremental_selection` no están activos. Activarlos añadiría keybindings para seleccionar por función, clase, parámetro, etc.

---

## Mason (mason.nvim)

> Gestor de LSP servers, linters, formatters y DAP adapters. Abrir con `:Mason`.

**Keybindings internos (dentro del panel)**

**Navegación**

| Key | Acción |
|-----|--------|
| `j` / `k` | Moverse entre paquetes |
| `gg` / `G` | Ir al primero / último paquete |
| `<CR>` | Expandir/colapsar detalles del paquete |
| `1`-`6` | Cambiar de pestaña (All, LSP, DAP, Linter, Formatter, Other) |

**Acciones**

| Key | Acción |
|-----|--------|
| `i` | Instalar paquete |
| `u` | Actualizar paquete |
| `X` | Desinstalar paquete |
| `U` | Actualizar todos los paquetes instalados |
| `<C-f>` | Filtrar paquetes (buscar por nombre) |
| `?` | Mostrar ayuda |
| `q` / `<Esc>` | Cerrar el panel |

**Comandos**

| Comando | Acción |
|---------|--------|
| `:Mason` | Abrir el panel de Mason |
| `:MasonInstall {pkg}` | Instalar un paquete directamente |
| `:MasonUninstall {pkg}` | Desinstalar un paquete |
| `:MasonUpdate` | Actualizar todos los paquetes |
| `:MasonLog` | Ver el log de Mason |

> **Paquetes gestionados automáticamente**: `lua_ls`, `ts_ls`, `clangd`, `zls`, `omnisharp`, `angularls`, `coreclr`

---

## Modo Visual

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `*` | Visual | Buscar selección hacia adelante |
| `#` | Visual | Buscar selección hacia atrás |

---

## LSP

### Keybindings globales

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `, K` | Normal | Mostrar documentación (hover) |
| `, bd` | Normal | Ir a definición |
| `, br` | Normal | Ir a referencias |
| `, ca` | Normal | Code actions |
| `, D` | Normal | Mostrar diagnóstico flotante |
| `, <Up>` | Normal | Diagnóstico anterior |
| `, <Down>` | Normal | Diagnóstico siguiente |
| `, F` | Normal | Formatear buffer |
| `, rn` | Normal | Renombrar símbolo |

> LSP instalados: `lua_ls`, `ts_ls`, `clangd`, `zls`, `rust_analyzer`, `omnisharp`, `angularls`

### Keybindings internos

**Ventana de hover (`, K`)**

| Key | Acción |
|-----|--------|
| `K` | Entrar a la ventana flotante para scrollear |
| `q` / `<Esc>` | Cerrar la ventana |

**Ventana de referencias (`, br`)**

| Key | Acción |
|-----|--------|
| `<CR>` | Ir a la referencia seleccionada |
| `q` | Cerrar la quickfix list |

**Ventana de code actions (`, ca`)**

| Key | Acción |
|-----|--------|
| `j` / `k` | Moverse entre acciones |
| `<CR>` | Ejecutar la acción seleccionada |
| `<Esc>` | Cancelar |

**Diagnóstico flotante (`, D`)**

| Key | Acción |
|-----|--------|
| `<Esc>` / `q` | Cerrar |

**Rename (`, rn`)**

| Key | Acción |
|-----|--------|
| escribir nuevo nombre | Editar el nombre en el input |
| `<CR>` | Confirmar el rename |
| `<Esc>` | Cancelar |

---

## Formato y Linting (conform.nvim + nvim-lint)

> **conform.nvim** gestiona el formateo; **nvim-lint** ejecuta linters al guardar. Ambos corren de forma independiente del LSP.

**Keybinding**

| Atajo | Modo | Acción |
|-------|------|--------|
| `, F` | Normal | Formatear el buffer actual (conform, con fallback a LSP) |

**Herramientas activas**

| Herramienta | Tipo | Lenguaje |
|-------------|------|----------|
| `stylua` | Formatter | Lua |
| `cpplint` | Linter | C / C++ (solo si el binario está disponible) |

**Comandos útiles**

| Comando | Acción |
|---------|--------|
| `:ConformInfo` | Ver formatters activos en el buffer actual |

---

## Telescope

### Keybindings globales

| Atajo | Descripción |
|-------|-------------|
| `, zf` | Buscar archivos |
| `, zg` | Live grep (buscar en contenido) |
| `, zb` | Lista de buffers abiertos |
| `, zh` | Buscar en help tags |
| `, zr` | Ver registros |
| `, zd` | Diagnósticos LSP |
| `, zt` | Símbolos Treesitter |
| `, zj` | Jump list |
| `, zm` | Marks |
| `, zs` | Historial de búsquedas |
| `, zc` | Historial de comandos |
| `, zgc` | Git commits |
| `, zgb` | Git branches |
| `, zgs` | Git status (cambios) |
| `, zgt` | Git stash |

### Keybindings internos (dentro del picker)

**Navegación**

| Key | Modo | Acción |
|-----|------|--------|
| `j` / `k` | Normal | Moverse entre resultados |
| `Ctrl-n` / `Ctrl-p` | Insert | Moverse entre resultados |
| `Ctrl-u` / `Ctrl-d` | Insert | Scroll en preview |
| `gg` / `G` | Normal | Ir al primero / último resultado |

**Selección y apertura**

| Key | Acción |
|-----|--------|
| `Enter` | Abrir en ventana actual |
| `Ctrl-s` | Abrir en split horizontal |
| `Ctrl-v` | Abrir en split vertical |
| `Ctrl-t` | Abrir en nueva pestaña |
| `Tab` | Seleccionar múltiple (toggle) |
| `Shift-Tab` | Deseleccionar múltiple (toggle) |

**Otros**

| Key | Acción |
|-----|--------|
| `Ctrl-c` / `Esc` | Cerrar picker |
| `Ctrl-/` | Mostrar keybindings de ayuda |
| `Ctrl-q` | Enviar resultados al quickfix list |
| `Ctrl-l` | Enviar seleccionados al quickfix list |

---

## Explorador de Archivos (Neo-tree)

### Keybindings globales

| Atajo | Descripción |
|-------|-------------|
| `, f` | Sidebar: filesystem |
| `, ff` | Float: filesystem |
| `, bb` | Float: buffers abiertos |
| `, gg` | Float: git status |

### Keybindings internos (dentro del panel)

**Navegación**

| Key | Acción |
|-----|--------|
| `Enter` / `l` | Abrir archivo / expandir carpeta |
| `h` | Colapsar carpeta |
| `<BS>` | Subir al directorio padre |
| `H` | Mostrar/ocultar archivos ocultos |

**Gestión de archivos**

| Key | Acción |
|-----|--------|
| `a` | Crear archivo (terminar con `/` para carpeta) |
| `d` | Eliminar |
| `r` | Renombrar |
| `y` | Copiar nombre |
| `Y` | Copiar ruta relativa |
| `c` | Copiar archivo |
| `m` | Mover archivo |
| `p` | Pegar |

**Abrir en ventanas**

| Key | Acción |
|-----|--------|
| `s` | Abrir en split vertical |
| `S` | Abrir en split horizontal |
| `t` | Abrir en nueva pestaña |
| `w` | Abrir con selector de ventana |

**Otros**

| Key | Acción |
|-----|--------|
| `R` | Refrescar |
| `q` | Cerrar |
| `?` | Mostrar ayuda completa |

---

## Git (Fugitive + Gitsigns + Diffview)

### Keybindings globales

| Atajo | Plugin | Descripción |
|-------|--------|-------------|
| `<leader>gd` | Diffview | Abrir panel de archivos modificados + diff |
| `<leader>gD` | Diffview | Cerrar panel Diffview |
| `<leader>gF` | Diffview | Historial de commits del archivo actual |
| `<leader>gh` | Fugitive | Diff horizontal split |
| `<leader>gv` | Fugitive | Diff vertical split |
| `<leader>gp` | Gitsigns | Preview hunk |
| `<leader>gb` | Gitsigns | Toggle blame de línea actual |
| `<leader>gg` | Neo-tree | Panel flotante git status |
| `<leader>zgs` | Telescope | Lista de archivos modificados |

---

### Diffview — keybindings internos

> Se abre con `<leader>gd`. Panel izquierdo: lista de archivos modificados. Panel derecho: diff lado a lado.

**Navegación entre archivos**

| Key | Acción |
|-----|--------|
| `Tab` | Siguiente archivo en el panel |
| `Shift-Tab` | Archivo anterior en el panel |
| `Enter` | Abrir el diff del archivo seleccionado |
| `j` / `k` | Moverse en la lista de archivos |

**Navegación en el diff**

| Key | Acción |
|-----|--------|
| `]c` / `[c` | Siguiente / anterior diferencia |
| `<C-w>h` / `<C-w>l` | Moverse entre los paneles del diff |

**Acciones**

| Key | Acción |
|-----|--------|
| `s` | Stage archivo |
| `u` | Unstage archivo |
| `X` | Descartar cambios del archivo |
| `R` | Refrescar la lista |
| `g<C-x>` | Cambiar el layout del diff |
| `q` | Cerrar Diffview |
| `?` | Mostrar ayuda completa |

---

### Fugitive — keybindings internos

> Abrir con `:Git` o `:G` para ver el panel de estado.

**Panel de estado (`:Git`)**

| Key | Acción |
|-----|--------|
| `s` | Stage archivo / hunk |
| `u` | Unstage archivo / hunk |
| `=` | Toggle diff inline del archivo |
| `dd` | Diff del archivo (`:Gdiffsplit`) |
| `dv` | Diff vertical split |
| `dh` | Diff horizontal split |
| `cc` | Crear commit (abre editor de mensaje) |
| `ca` | Amend del último commit |
| `cw` | Reword del último commit |
| `ce` | Amend sin editar mensaje |
| `X` | Descartar cambios del archivo |
| `[c` / `]c` | Hunk anterior / siguiente |
| `o` | Abrir archivo en ventana actual |
| `O` | Abrir archivo en nueva pestaña |
| `gO` | Abrir archivo en split vertical |
| `R` | Refrescar |
| `g?` | Mostrar ayuda completa |
| `q` | Cerrar panel |

**En vista de diff (`:Gdiffsplit`)**

| Key | Acción |
|-----|--------|
| `do` | Obtener cambio del otro lado (`diffget`) |
| `dp` | Poner cambio en el otro lado (`diffput`) |
| `]c` / `[c` | Siguiente / anterior diferencia |
| `:diffupdate` | Actualizar la vista de diff |

**Comandos útiles**

| Comando | Descripción |
|---------|-------------|
| `:Git blame` | Blame del archivo actual |
| `:Git log` | Log del repositorio |
| `:Git push` | Push al remoto |
| `:Git pull` | Pull del remoto |
| `:GBrowse` | Abrir archivo en GitHub/GitLab |

---

### Gitsigns — comandos en el buffer

> Gitsigns no tiene panel propio; opera directamente sobre el buffer.

**Navegación entre hunks**

| Key | Acción |
|-----|--------|
| `]c` | Siguiente hunk |
| `[c` | Hunk anterior |

**Acciones sobre hunks**

| Key | Modo | Acción |
|-----|------|--------|
| `:Gitsigns stage_hunk` | Normal | Stagear hunk bajo el cursor |
| `:Gitsigns reset_hunk` | Normal | Descartar cambios del hunk |
| `:Gitsigns stage_buffer` | Normal | Stagear todo el buffer |
| `:Gitsigns reset_buffer` | Normal | Descartar todos los cambios del buffer |
| `:Gitsigns undo_stage_hunk` | Normal | Deshacer stage del último hunk |
| `:Gitsigns diffthis` | Normal | Diff del archivo contra HEAD |

**Dentro del preview de hunk (`, gp`)**

| Key | Acción |
|-----|--------|
| `j` / `k` | Moverse entre líneas del hunk |
| `q` / `<Esc>` | Cerrar preview |

---

## Diagnósticos (Trouble)

### Keybindings globales

| Atajo | Descripción |
|-------|-------------|
| `, xx` | Todos los diagnósticos del proyecto |
| `, xb` | Diagnósticos del buffer actual |
| `, xs` | Símbolos del archivo |
| `, xr` | Referencias LSP |

### Keybindings internos (dentro del panel)

**Navegación**

| Key | Acción |
|-----|--------|
| `j` / `k` | Moverse entre items |
| `gg` / `G` | Ir al primero / último item |
| `<CR>` | Ir al item y cerrar Trouble |
| `o` | Ir al item sin cerrar Trouble |
| `p` | Preview del item en ventana de código |
| `{` / `}` | Item anterior / siguiente |
| `]]` / `[[` | Siguiente / anterior grupo (por archivo) |

**Acciones**

| Key | Acción |
|-----|--------|
| `q` / `<Esc>` | Cerrar el panel |
| `r` | Actualizar (refresh) |
| `s` | Ordenar por distintos criterios (toggle) |
| `zM` | Colapsar todos los grupos |
| `zR` | Expandir todos los grupos |
| `zo` / `zc` | Expandir / colapsar grupo actual |

---

## Markdown (render-markdown.nvim)

> Solo activo en archivos `.md`

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `, M` | Normal | Toggle renderizado Markdown |

---

## Comentarios (Comment.nvim)

> Detecta automáticamente el tipo de comentario según el lenguaje del buffer.

**Keybindings**

| Key | Modo | Acción |
|-----|------|--------|
| `, cc` | Normal | Comentar/descomentar la línea actual |
| `, cb` | Normal | Comentar/descomentar como bloque |
| `, c{motion}` | Normal | Comentar/descomentar con motion (ej: `, cj` → línea siguiente) |
| `, b{motion}` | Normal | Comentar/descomentar bloque con motion |
| `, c` | Visual | Comentar/descomentar la selección (línea) |
| `, b` | Visual | Comentar/descomentar la selección (bloque) |

---

## Autoclose (autoclose.nvim)

> No tiene keybindings propios — actúa de forma transparente en Insert mode.

**Comportamiento por defecto**

| Acción | Resultado |
|--------|-----------|
| Escribir `(` | Inserta `()` y deja el cursor adentro |
| Escribir `[` | Inserta `[]` y deja el cursor adentro |
| Escribir `{` | Inserta `{}` y deja el cursor adentro |
| Escribir `"` | Inserta `""` y deja el cursor adentro |
| Escribir `'` | Inserta `''` y deja el cursor adentro |
| Escribir `` ` `` | Inserta ` `` ` y deja el cursor adentro |
| Escribir `)` sobre `)` | Salta por encima sin duplicar |
| `<BS>` sobre par vacío `()` | Borra ambos caracteres |

---

## Marks (marks.nvim)

> Opera directamente en el buffer. Marks builtin activas: `.` `<` `>` `^`

### Keybindings globales

| Atajo | Descripción |
|-------|-------------|
| `, mm` | Listar marks del buffer |
| `, mj` | Saltar a la próxima línea con mark |
| `, mk` | Saltar a la línea anterior con mark |
| `, md` | Borrar todas las marks del buffer |

### Default mappings (en el buffer)

**Crear y borrar**

| Key | Acción |
|-----|--------|
| `mx` | Poner mark `x` (cualquier letra a-z / A-Z) |
| `m,` | Poner siguiente mark alfabética disponible |
| `m;` | Alternar la siguiente mark disponible en la línea |
| `dmx` | Borrar mark `x` |
| `dm-` | Borrar todas las marks de la línea actual |
| `dm<Space>` | Borrar todas las marks del buffer |
| `m]` | Mover mark al siguiente carácter disponible |

**Navegación**

| Key | Acción |
|-----|--------|
| `'x` | Saltar a la línea de la mark `x` |
| `` `x `` | Saltar a la posición exacta de la mark `x` |
| `]'` | Próxima línea con mark |
| `['` | Línea anterior con mark |
| `` ]` `` | Próxima mark (posición exacta) |
| `` [` `` | Mark anterior (posición exacta) |

**Bookmarks (mark tipo `m0`)**

| Key | Acción |
|-----|--------|
| `m0` | Toggle bookmark en la línea actual |
| `]0` | Siguiente bookmark |
| `[0` | Bookmark anterior |
| `dm0` | Borrar bookmark de la línea |

---

## Surround (nvim-surround)

**Agregar surrounding**

| Key | Modo | Acción |
|-----|------|--------|
| `ys{motion}{char}` | Normal | Rodear con motion (ej: `ysiw"` → rodea palabra con `"`) |
| `yss{char}` | Normal | Rodear la línea completa |
| `S{char}` | Visual | Rodear la selección |
| `gS{char}` | Visual | Rodear la selección en líneas separadas |

**Eliminar surrounding**

| Key | Modo | Acción |
|-----|------|--------|
| `ds{char}` | Normal | Eliminar el surrounding más cercano (ej: `ds"`) |
| `dst` | Normal | Eliminar tag HTML más cercano |

**Cambiar surrounding**

| Key | Modo | Acción |
|-----|------|--------|
| `cs{old}{new}` | Normal | Cambiar surrounding (ej: `cs"'` → cambia `"` por `'`) |
| `cst{char}` | Normal | Cambiar tag HTML por otro carácter |
| `csth` | Normal | Cambiar tag HTML por otro tag (pide el nuevo) |

**Chars especiales**

| Char | Resultado |
|------|-----------|
| `(` | espacio interior: `( texto )` |
| `)` | sin espacio: `(texto)` |
| `{` | espacio interior: `{ texto }` |
| `}` | sin espacio: `{texto}` |
| `[` | espacio interior: `[ texto ]` |
| `]` | sin espacio: `[texto]` |
| `t` | tag HTML (pide el tag a escribir) |
| `f` | función (pide el nombre de función) |

---

## Indent (indent-blankline.nvim)

> Plugin puramente visual, no tiene keybindings. Muestra guías de indentación en el buffer automáticamente.

**Comandos disponibles**

| Comando | Acción |
|---------|--------|
| `:IBLEnable` | Activar las guías de indentación |
| `:IBLDisable` | Desactivar las guías de indentación |
| `:IBLToggle` | Toggle de las guías |
| `:IBLEnableScope` | Activar resaltado del scope actual |
| `:IBLDisableScope` | Desactivar resaltado del scope actual |
| `:IBLToggleScope` | Toggle del resaltado de scope |

---

## Autocompletado (nvim-cmp + LuaSnip)

**Activación y cierre**

| Key | Modo | Acción |
|-----|------|--------|
| `Alt-Space` | Insert | Forzar apertura del menú |
| `Alt-e` | Insert | Cancelar y cerrar menú |
| `Enter` | Insert | Confirmar selección actual |

**Navegación en el menú**

| Key | Modo | Acción |
|-----|------|--------|
| `Ctrl-n` / `Ctrl-p` | Insert | Siguiente / anterior item |
| `Ctrl-y` | Insert | Confirmar selección (alternativa a Enter) |
| `Alt-f` | Insert | Scroll en documentación (abajo) |
| `Alt-b` | Insert | Scroll en documentación (arriba) |

**Snippets (LuaSnip)**

| Key | Modo | Acción |
|-----|------|--------|
| `Ctrl-f` | Insert/Select | Avanzar al siguiente campo del snippet |
| `Ctrl-b` | Insert/Select | Retroceder al campo anterior del snippet |

---

## Debug (DAP + DAP UI)

### Keybindings globales

| Atajo | Descripción |
|-------|-------------|
| `, db` | Toggle breakpoint |
| `, dB` | Breakpoint condicional (pide condición) |
| `, du` | Toggle panel DAP UI |
| `F5` | Continuar / Iniciar sesión de debug |
| `F6` | Step over (siguiente línea, sin entrar) |
| `F7` | Step into (entrar al método) |
| `F8` | Step out (salir del método actual) |

> El panel DAP UI se abre y cierra automáticamente al iniciar/terminar una sesión.

### Keybindings internos (dentro del panel DAP UI)

**En cualquier elemento del panel**

| Key | Acción |
|-----|--------|
| `Enter` | Expandir/colapsar elemento |
| `e` | Editar valor de variable |
| `r` | Ir a la definición del elemento en REPL |
| `d` | Eliminar watchpoint |
| `t` | Toggle punto de control |
| `<Space>` | Toggle visualización del elemento |

**En el panel de Call Stack**

| Key | Acción |
|-----|--------|
| `Enter` | Ir al frame seleccionado |
| `o` | Abrir frame en ventana de código |

**En el REPL (consola interactiva)**

| Key | Acción |
|-----|--------|
| `Enter` | Ejecutar expresión |
| `Ctrl-c` | Limpiar la línea actual |
| `Ctrl-n` / `Ctrl-p` | Navegar historial de comandos |

---

## Flujo de trabajo: Debug de C# con Neovim

### Requisitos previos
- `netcoredbg` instalado vía Mason (`:MasonInstall coreclr`)
- Proyecto compilado en modo Debug

---

### Paso 1 — Compilar en modo Debug

```bash
dotnet build --configuration Debug
```

O desde Neovim con `F9` (si el proyecto tiene configurado el comando Build).

---

### Paso 2 — Poner breakpoints

Navegar al archivo y línea donde querés pausar, luego:

```
, db        → breakpoint normal
, dB        → breakpoint condicional (te pide la expresión)
```

Los breakpoints se marcan en el gutter con un símbolo rojo.

---

### Paso 3 — Iniciar la sesión de debug

Presionar `F5`. Aparece un picker de Telescope para elegir el adaptador. Seleccionar **coreclr**.

Luego pide la ruta al ejecutable — ingresar el path al `.dll` publicado, por ejemplo:

```
/home/cristian/dev/physis/phy2services/publish/WebApi.dll
```

La aplicación arranca y el panel DAP UI se abre automáticamente con:
- **Variables** (locales, `this`, etc.)
- **Call Stack**
- **Breakpoints activos**
- **Console / Output**

---

### Paso 4 — Navegar durante el debug

| Acción | Atajo |
|--------|-------|
| Continuar hasta el próximo breakpoint | `F5` |
| Step over (siguiente línea) | `F6` |
| Step into (entrar al método) | `F7` |
| Step out (salir del método) | `F8` |

Para inspeccionar una variable: posicionarse sobre ella y presionar `, K` (hover del LSP, también funciona en modo debug).

---

### Paso 5 — Terminar la sesión

Dejar correr la app hasta que finalice, o terminarla desde el proceso. El panel DAP UI se cierra automáticamente.

Para cerrar/reabrir el panel manualmente en cualquier momento: `, du`.

---

### Tips

- **Breakpoint condicional**: `, dB` → ingresar la condición en C# (ej: `id == 5`)
- **Ver todos los breakpoints activos**: `, xb` o `, xx` (Trouble)
- Si el picker no aparece al presionar `F5`, revisar que `netcoredbg` esté instalado: `:Mason` → buscar `coreclr`
