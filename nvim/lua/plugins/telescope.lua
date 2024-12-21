local map = vim.keymap.set

return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
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
			map("n", "<leader>z", builtin.find_files, { desc="Find files." })
			map("n", "<leader>Z", builtin.live_grep, { desc="Find strings live grep."})

			require("telescope").load_extension("ui-select")
		end,
	},
}
