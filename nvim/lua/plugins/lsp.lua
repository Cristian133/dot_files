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
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim'},
                        },
                    },
                },
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--fallback-style=webkit",
                },
            })
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
            })
            map("n", "<leader>K", buf.hover, { desc = "Show info." })
            map("n", "<leader>bd", buf.definition, { desc = "Goto definition." })
            map("n", "<leader>br", buf.references, { desc = "Goto reference." })
            map("n", "<leader>ca", buf.code_action, { desc = "Code actions." })
            -- Show diagnostics in a floating window
            map("n", "<leader>D", dia.open_float, { desc = "Open float diagnostic." })
            -- Move to the previous diagnostic
            map("n", "<leader><Up>", dia.goto_prev, { desc = "Goto previous diagnostic." })
            -- Move to the next diagnostic
            map("n", "<leader><Down>", dia.goto_next, { desc = "Goto next diagnostic." })
        end,
    },
}
