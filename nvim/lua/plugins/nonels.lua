local map = vim.keymap.set
local buf = vim.lsp.buf

return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.rustfmt,
				null_ls.builtins.code_actions.gitsigns,
			},
		})
		map("n", "<leader>F", buf.format, { desc = "Buffer format." })
	end,
}
