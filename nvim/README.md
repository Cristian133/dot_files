# nvim.lua

| Mode | Mapping | function | Comment |
| ---- | ---- | ---- | ---- |
| Insert | ññ | \<ESC\> |  |
| Normal | gI | `. | moves to last modification |
| Normal | \<A-w\> | \<C-w\> | window movements |
| Normal | \<Leader\>ñ | set list!\<CR\> | show invisible characters |
| Normal | \<Leader\>\<CR\> | :noh\<CR\> | disable highlight |
| Normal | \<Leader\>\<Right\> | :bnext\<CR\> |  Move to the previous buffer |
| Normal | \<Leader\>\<Left\> | :bprev\<CR\> |  Move to the previous buffer |
| Normal | \<Leader\>gl | vim.diagnostic.open_float | Show diagnostics in a floating window |
| Normal | \<Leader\>\<Up\> | vim.diagnostic.goto_prev | Move to the previous diagnostic |
| Normal | \<Leader\>\<Down\> | vim.diagnostic.goto_next | Move to the next diagnostic |
| Normal | \<Leader\>m | :MarksListBuf<CR> | Mark's list |
| Normal | \<Leader\>j | ]' | Move to the previous mark |
| Normal | \<Leader\>k | [' | Move to the previous mark |
| Normal | \<Leader\>cc |  | comment line |
| Visual | \<Leader\>c |  | comment block |
| Normal | \<Leader\>gf | vim.lsp.buf.format | format buffer |
| Normal | \<Leader\>z | builtin.find_files |  |
| Normal | \<Leader\>zg | builtin.live_grep |  |
| Normal | \<Leader\>d | :Gdiffsplit<CR> |  |
| Normal | \<Leader\>g | :Neotree float git_status toggle\<CR\> |  |
| Normal | \<Leader\>b | :Neotree float buffers toggle\<CR\> |  |
| Normal | \<Leader\>f | :Neotree float filesystem toggle\<CR\> |  |
| Normal | \<Leader\>gp | :Gitsigns preview_hunk\<CR\> |  |
| Normal | \<Leader\>gt | :Gitsigns toggle_current_blame_line\<CR\> |  |
| Normal | \<Leader\>dt | :DapToggleBreakpoint<CR> |  |
| Normal | \<Leader\>dc | :DapContinue<CR> |  |
| Normal | \<Leader\>dx | :DapTerminate<CR> |  |
| Normal | \<Leader\>do | :DapStepOver<CR> |  |
| Normal |  \<Shift\>k | vim.lsp.buf.hover |  |
| Normal | \<Leader\>gd | vim.lsp.buf.definition | |
| Normal | \<Leader\>gr | vim.lsp.buf.references | |
| Normal | \<Leader\>ca | vim.lsp.buf.code_action | |
