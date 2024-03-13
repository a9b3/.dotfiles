return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local luasnip = require("luasnip")

			require("luasnip/loaders/from_vscode").lazy_load()
			require("luasnip/loaders/from_snipmate").lazy_load({ path = { "./snippets" } })

			require("cmp").setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<S-Tab>"] = require("cmp").mapping.select_prev_item(),
					["<Tab>"] = require("cmp").mapping.select_next_item(),
					["<C-h>"] = require("cmp").mapping.scroll_docs(-4),
					["<C-l>"] = require("cmp").mapping.scroll_docs(4),
					["<C-Space>"] = require("cmp").mapping.complete(),
					["<C-d>"] = require("cmp").mapping.close(),
					["<C-k>"] = require("cmp").mapping.confirm({
						behavior = require("cmp").ConfirmBehavior.Insert,
						select = true,
					}),
					["<CR>"] = require("cmp").mapping.confirm({
						behavior = require("cmp").ConfirmBehavior.Insert,
						select = true,
					}),
				},
				sources = {
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},
}
