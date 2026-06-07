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
-- lsp
map("n", "<leader>K", vim.lsp.buf.hover, { desc = "Show info." })
map("n", "<leader>bd", vim.lsp.buf.definition, { desc = "Goto definition." })
map("n", "<leader>br", vim.lsp.buf.references, { desc = "Goto reference." })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions." })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol." })
map("n", "<leader>D", vim.diagnostic.open_float, { desc = "Open float diagnostic." })
map("n", "<leader><Up>", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic." })
map("n", "<leader><Down>", vim.diagnostic.goto_next, { desc = "Goto next diagnostic." })

-- dap
map("n", "<F5>", function() require("dap").continue() end, { desc = "DAP Continue." })
map("n", "<F6>", function() require("dap").step_over() end, { desc = "DAP Step Over." })
map("n", "<F7>", function() require("dap").step_into() end, { desc = "DAP Step Into." })
map("n", "<F8>", function() require("dap").step_out() end, { desc = "DAP Step Out." })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint." })
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "DAP Conditional Breakpoint." })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP UI Toggle." })

-- none-ls
map("n", "<leader>F", function() vim.lsp.buf.format() end, { desc = "Format buffer." })

-- render-markdown
map("n", "<leader>M", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown preview." })

-- telescope
local tb = function(picker) return function() require("telescope.builtin")[picker]() end end
map("n", "<leader>zf", tb("find_files"), { desc = "Find files." })
map("n", "<leader>zg", tb("live_grep"), { desc = "Live grep." })
map("n", "<leader>zb", tb("buffers"), { desc = "Buffers." })
map("n", "<leader>zh", tb("help_tags"), { desc = "Help tags." })
map("n", "<leader>zr", tb("registers"), { desc = "Registers." })
map("n", "<leader>zd", tb("diagnostics"), { desc = "Diagnostics." })
map("n", "<leader>zt", tb("treesitter"), { desc = "Treesitter." })
map("n", "<leader>zj", tb("jumplist"), { desc = "Jump list." })
map("n", "<leader>zm", tb("marks"), { desc = "Marks." })
map("n", "<leader>zs", tb("search_history"), { desc = "Search history." })
map("n", "<leader>zc", tb("command_history"), { desc = "Command history." })
map("n", "<leader>zgc", tb("git_commits"), { desc = "Git commits." })
map("n", "<leader>zgb", tb("git_branches"), { desc = "Git branches." })
map("n", "<leader>zgs", tb("git_status"), { desc = "Git status." })
map("n", "<leader>zgt", tb("git_stash"), { desc = "Git stash." })

-- trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All diagnostics (Trouble)." })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)." })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)." })
map("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP references (Trouble)." })

-- gitsigns
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git preview hunk." })
map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_blame_line<CR>", { desc = "Git current line blame." })

-- fugitive
map("n", "<leader>gh", ":Ghdiffsplit<CR>", { desc = "Git diff horizontal split." })
map("n", "<leader>gv", ":Gvdiffsplit<CR>", { desc = "Git diff vertical split. " })

-- marks
map("n", "<leader>mm", "<cmd>MarksListBuf<CR>", { noremap = true, desc = "Marks list buffer." })
map("n", "<leader>mj", "]'", { noremap = true, desc = "Next mark." })
map("n", "<leader>mk", "['", { noremap = true, desc = "Previous mark." })
map("n", "<leader>md", "<cmd>delmarks!<CR>", { noremap = true, desc = "Delete all marks (current buffer)." })

-- comments
map("n", "<leader>cc", "<cmd>CommentToggle<CR>", { desc = "Comment/uncomment line." })
map("v", "<leader>c", "<cmd>CommentToggle<CR>", { desc = "Comment/uncomment selection." })

-- which-key
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer local keymaps (which-key)." })

-- neeotree
map("n", "<leader>gg", ":Neotree float git_status toggle<CR>", { desc = "Neotree float git status." })
map("n", "<leader>bb", ":Neotree float buffers toggle<CR>", { desc = "Neotree float buffers." })
map("n", "<leader>ff", ":Neotree float filesystem toggle<CR>", { desc = "Neotree float filesystem." })
map("n", "<leader>f", ":Neotree left filesystem toggle<CR>", { desc = "Neotree left filesystem." })

