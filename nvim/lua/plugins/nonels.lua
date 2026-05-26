local map = vim.keymap.set
local buf = vim.lsp.buf
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				require("none-ls.diagnostics.cpplint"),
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.buf
            },
		})
		map("n", "<leader>F", buf.format, { desc = "Buffer format" })
	end,
}
