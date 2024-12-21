local map = vim.keymap.set

return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Git previous hunk." }),
            map("n", "<leader>gb", ":Gitsigns toggle_current_blame_line<CR>", { desc = "Git current line blame." }),
        })
    end,
}
