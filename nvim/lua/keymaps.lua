local map = vim.keymap.set
local global = vim.g

-- leader key
global.mapleader = " "

-- easy ESC
map("i", "ññ", "<ESC>", { noremap = true })

-- show invisible characters
map("n", "<leader>ñ", ":set list!<CR>", { noremap = true, desc = "Show invisible characters." })

-- windows movements
map("n", "<A-w>", "<C-w>", { noremap = true })

-- gi moves to last insert mode (default)
-- gI moves to last modification
map("n", "gI", "`.", {})

-- Disable highlight when <leader><CR> is pressed
map("n", "<leader><CR>", ":noh<CR>", { desc = "Stop the highlighting." })

-- Visual mode pressing * or # searches for the current selection
map(
    "v",
    "*",
    ":<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>",
    { desc = "Searches for the current selection" }
)
map(
    "v",
    "#",
    ":<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>",
    { desc = "Searches for the current selection" }
)

------------------------------------------------------------------------------
-- Moving around windows, buffers and marks
------------------------------------------------------------------------------
-- buffers
map("n", "<leader><Right>", ":bnext<CR>", { noremap = true, desc = "Goto next buffer." })
map("n", "<leader><Left>", ":bprev<CR>", { noremap = true, desc = "Goto previos buffer." })

-- toggle if you want to make Vim wrap long lines to fit in the window
map("n", "<leader>L", ":call ToggleWrap()<CR>", { desc = "Vim wrap long lines." })
-- jump history
map("", "<leader>J", ":call GotoJump()<CR>", { desc = "Goto jump history." })
-- change the way numbers look
map("n", "<leader>N", ":call ToggleNumber()<CR>", { desc = "Change the way numbers look." })
-- toggle highlight character from line 80
map("n", "<leader>C", ":call ToggleCol80()<CR>", { desc = "Highlight character from line 80." })
-- Close the current buffer
map("n", "<leader>Q", ":Bclose<CR>", { desc = "Delete buffer (not windows)." })

------------------------------------------------------------------------------
-- Function keys
------------------------------------------------------------------------------
-- build
map("n", "<F9>", ":w!<CR>:call Build()<CR>", {})
map("i", "<F9>", "<ESC>:w!<CR>:call Build()<CR>", {})

-- Strip trailing whitespace
map("n", "<F10>", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>", { desc = "Strip trailing whitespaces" })
map("i", "<F10>", "<Esc>:let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar><CR>", { desc = "Strip trailing whitespaces" })

------------------------------------------------------------------------------
-- plugins
------------------------------------------------------------------------------
-- fugitive
map("n", "<leader>gh", ":Ghdiffsplit<CR>", { desc = "Git diff horizontal split." })
map("n", "<leader>gv", ":Gvdiffsplit<CR>", { desc = "Git diff vertical split. " })

-- neeotree
map("n", "<leader>gg", ":Neotree float git_status toggle<CR>", { desc = "Neotree float git status." })
map("n", "<leader>bb", ":Neotree float buffers toggle<CR>", { desc = "Neotree float buffers." })
map("n", "<leader>ff", ":Neotree float filesystem toggle<CR>", { desc = "Neotree float filesystem." })
map("n", "<leader>f", ":Neotree left filesystem toggle<CR>", { desc = "Neotree left filesystem." })

