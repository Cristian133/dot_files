local opt = vim.opt

opt.encoding="utf-8"
opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

-- Files, backups and undo
opt.swapfile = true
opt.backup = true
opt.writebackup = true
opt.undofile = true

local root = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
opt.undodir = { root .. "/nvim/.undo//" }
opt.backupdir = { root .. "/nvim/.bkp//" }
opt.directory = { root .. "/nvim/.swp//" }

-- Expand tabs to spaces.
opt.expandtab = true
-- Number of spaces to use for each step of indent.
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
-- Ignore case when searching
opt.ignorecase = true
opt.cursorline = true
-- Show line numbers
opt.number = true
-- Set to auto read when a file is changed from the outside
opt.autoread = true
-- Use intelligent case while searching.
-- (If search string contains an upper case letter, disable ignorecase.)
opt.smartcase = true
-- Also switch on highlighting the last used search pattern
opt.hlsearch = true
-- Makes search act like search in modern browsers
opt.incsearch = true
-- Invisible characters
opt.showbreak="↪ "
opt.listchars="eol:↲,trail:•,space:␣,tab:→ ,"
 -- uses the clipboard register for all operations except yank
opt.clipboard = "unnamedplus"
 -- Copy indent from current line when starting a new line.
opt.autoindent = true
