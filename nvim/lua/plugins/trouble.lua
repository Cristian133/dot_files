return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("trouble").setup()
        local map = vim.keymap.set
        map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All diagnostics (Trouble)" })
        map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)" })
        map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
        map("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP references (Trouble)" })
    end,
}
