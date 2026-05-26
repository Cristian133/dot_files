return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local neo_tree = require("neo-tree")

        neo_tree.setup({
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
            },
        })
    end,
}
