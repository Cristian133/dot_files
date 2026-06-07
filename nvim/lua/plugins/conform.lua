local map = vim.keymap.set

return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPost" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                },
            })
            map("n", "<leader>F", function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end, { desc = "Buffer format" })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {}
            if vim.fn.executable("cpplint") == 1 then
                lint.linters_by_ft.c = { "cpplint" }
                lint.linters_by_ft.cpp = { "cpplint" }
            end
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
