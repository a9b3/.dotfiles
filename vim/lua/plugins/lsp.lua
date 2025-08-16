return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
			require("nvim-treesitter.install").compilers = { "gcc" }
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false }, -- turn off inline ghost text
			panel = { enabled = false }, -- optional
		},
	},
	{
		{
			"zbirenbaum/copilot-cmp",
			dependencies = { "zbirenbaum/copilot.lua" },
			config = function()
				require("copilot_cmp").setup()
			end,
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			-- Use unnamed register for the selection
			opts.selection = select.unnamed

			require("CopilotChat").setup(opts)

			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			vim.keymap.set("n", "<leader>lp", "<cmd>CopilotChat<cr>", { desc = "[lsp] Copilot" })
			vim.keymap.set("v", "<leader>lp", "<cmd>CopilotChatVisual<cr>", { desc = "[lsp] Copilot Visual" })
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({
				outline_window = {
					position = "right",
					symbols = {
						icon_fetcher = function(k)
							if k == "String" then
								return ""
							end
							return false
						end,
						icon_source = "lspkind",
					},
				},
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
