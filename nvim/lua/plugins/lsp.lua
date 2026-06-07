local map = vim.keymap.set
local buf = vim.lsp.buf
local dia = vim.diagnostic

return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "clangd", "zls", "rust_analyzer", "omnisharp", "angularls" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("*", { capabilities = capabilities })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--fallback-style=webkit" },
            })

            vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "zls", "rust_analyzer", "omnisharp", "angularls" })

            map("n", "<leader>K", buf.hover, { desc = "Show info." })
            map("n", "<leader>bd", buf.definition, { desc = "Goto definition." })
            map("n", "<leader>br", buf.references, { desc = "Goto reference." })
            map("n", "<leader>ca", buf.code_action, { desc = "Code actions." })
            map("n", "<leader>rn", buf.rename, { desc = "Rename symbol." })
            map("n", "<leader>D", dia.open_float, { desc = "Open float diagnostic." })
            map("n", "<leader><Up>", dia.goto_prev, { desc = "Goto previous diagnostic." })
            map("n", "<leader><Down>", dia.goto_next, { desc = "Goto next diagnostic." })
        end,
    },
}
