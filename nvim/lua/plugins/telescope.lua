local map = vim.keymap.set

return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            local builtin = require("telescope.builtin")

            map("n", "<leader>Z", builtin.planets, { desc = "Telescope use" })
            -- general pickers
            map("n", "<leader>zf", builtin.find_files, { desc = "Find files" })
            map("n", "<leader>zg", builtin.live_grep, { desc = "Live grep" })
            map("n", "<leader>zb", builtin.buffers, { desc = "Buffers" })
            map("n", "<leader>zh", builtin.help_tags, { desc = "Tags" })
            map("n", "<leader>zr", builtin.registers, { desc = "Registers" })
            map("n", "<leader>zd", builtin.diagnostics, { desc = "Diagnostic" })
            -- treesitter picker
            map("n", "<leader>zt", builtin.treesitter, { desc = "Treesitter" })
            -- history pickers
            map("n", "<leader>zj", builtin.jumplist, { desc = "Jump list" })
            map("n", "<leader>zm", builtin.marks, { desc = "Jump list" })
            map("n", "<leader>zs", builtin.search_history, { desc = "Search history" })
            map("n", "<leader>zc", builtin.command_history, { desc = "Command history" })
            -- git pickers
            map("n", "<leader>zgc", builtin.git_commits, { desc = "Commit list" })
            map("n", "<leader>zgb", builtin.git_branches, { desc = "Branches list" })
            map("n", "<leader>zgs", builtin.git_status, { desc = "Changes list" })
            map("n", "<leader>zgt", builtin.git_stash, { desc = "Stash list" })

            require("telescope").load_extension("ui-select")
        end,
    },
}
