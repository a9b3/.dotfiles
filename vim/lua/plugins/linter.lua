local linters_by_ft = {
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	svelte = { "eslint_d" },
	lua = { "luacheck" },
}

return {
	-- Check https://github.com/mfussenegger/nvim-lint/tree/master/lua/lint/linters
	-- for more linter configs
	{
		"mfussenegger/nvim-lint",
		event = { "BufRead", "BufWritePre" },
		config = function()
			require("lint").linters_by_ft = linters_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("lint", { clear = true }),
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
