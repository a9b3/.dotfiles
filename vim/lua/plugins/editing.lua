return {
	{
		"echasnovski/mini.ai",
		event = "BufRead",
		config = true,
	},
	{
		"echasnovski/mini.surround",
		event = "BufRead",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		opts = {
			toggler = {
				line = "<C-_>",
			},
			opleader = {
				line = "<C-_>",
			},
		},
		config = function(_, opts)
			require("Comment").setup(opts)
			-- Neovim outside of tmux is getting <C-/> while inside tmux it gets <C-_>
			vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", { noremap = false, silent = true })
			vim.keymap.set("x", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { noremap = false, silent = true })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
			}
		end,
	},
}
