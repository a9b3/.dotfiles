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
