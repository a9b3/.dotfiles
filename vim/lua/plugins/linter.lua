return {
	{
		"mfussenegger/nvim-lint",
		dependencies = { "neovim/nvim-lspconfig" },
		event = { "BufRead", "BufWritePre" },
		config = function()
			require("lint").linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				lua = { "luacheck" },
			}
			require("lint").linters.eslint = {
				cmd = "eslint_d",
				args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
				stream = "stdout",
			}
			require("lint").linters.luacheck = {
				cmd = "luacheck",
				args = { "--formatter", "plain", "--codes", "--ranges", "--filename", "%filepath", "-" },
				stdin = true,
				parser = require("lint.parser").from_pattern([[(%d+):(%d+)-(%d+):(%d+) (%u+)%s+(.*)]], {
					source = "source",
					row = "line",
					endRow = "endLine",
					column = "column",
					endColumn = "endColumn",
					message = "%message",
				}),
			}
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
