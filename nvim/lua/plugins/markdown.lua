return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        keys = {
            { "<leader>M", "<cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle Markdown preview." },
        },
        opts = {},
    },
}
