return {
	"chentoast/marks.nvim",
	config = function()
		require("marks").setup({
			default_mappings = true,
			builtin_marks = { ".", "<", ">", "^" },
			cyclic = true,
			force_write_shada = false,
			refresh_interval = 250,
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			excluded_filetypes = {},
			excluded_buftypes = {},
			bookmark_0 = {
				sign = "⚑",
				virt_text = "hello world",
				annotate = false,
			},
			mappings = {},
		})
		local map = vim.keymap.set
		map("n", "<leader>mm", ":MarksListBuf<CR>", { noremap = true, desc = "Marks list buffer" })
		map("n", "<leader>mj", "]'", { noremap = true, desc = "Marks previous" })
		map("n", "<leader>mk", "['", { noremap = true, desc = "Marks next" })
		map("n", "<leader>md", ":delmarks!<CR>", { noremap = true, desc = "Marks delete all (current buffer)." })
	end,
}
