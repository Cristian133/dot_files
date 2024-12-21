local map = vim.keymap.set

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
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
			},
		})

		map("n", "<leader>gg", ":Neotree float git_status toggle<CR>", { desc = "Neotree float git status." })
		map("n", "<leader>bb", ":Neotree float buffers toggle<CR>", { desc = "Neotree float buffers." })
		map("n", "<leader>f", ":Neotree left filesystem toggle<CR>", { desc = "Neotree left filesystem." })
	end,
}
