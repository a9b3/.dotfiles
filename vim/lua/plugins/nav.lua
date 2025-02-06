return {
	{
		"famiu/bufdelete.nvim",
		event = "BufEnter",
	},
	-- scoped buffers to tabs
	{
		"tiagovla/scope.nvim",
		config = true,
	},
	{
		"simeji/winresizer",
		event = "WinEnter",
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 50,
				open_mapping = [[<M-\>]],
				direction = "horizontal",
			})

			-- Set toggleterm keymaps
			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<M-\\>", [[<Cmd>:ToggleTerm <CR>]], opts)
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			end

			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					if vim.o.filetype == "toggleterm" then
						vim.cmd("startinsert")
					end
				end,
			})
		end,
	},
	{
		"chrishrb/gx.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		config = true,
		submodules = false,
	},
}
