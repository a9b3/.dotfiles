return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>xx",
				"<cmd>TroubleToggle<cr>",
				mode = { "n" },
				desc = "[Trouble] Toggle",
			},
			{
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				mode = { "n" },
				desc = "[Trouble] Toggle Workspace",
			},
			{
				"<leader>xd",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				mode = { "n" },
				desc = "[Trouble] Toggle Document",
			},
			{
				"<leader>xl",
				"<cmd>TroubleToggle loclist<cr>",
				mode = { "n" },
				desc = "[Trouble] Toggle Loclist",
			},
			{
				"<leader>xq",
				"<cmd>TroubleToggle quickfix<cr>",
				mode = { "n" },
				desc = "[Trouble] Toggle Quickfix",
			},
		},
	},
	{ "b0o/schemastore.nvim" },
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
					additional_vim_regex_highlighting = true,
				},
			})
			require("nvim-treesitter.install").compilers = { "gcc" }
		end,
	},
	{
		"github/copilot.vim",
		init = function()
			-- Set copilot keymaps
			vim.keymap.set("i", "<C-e>", 'copilot#Accept("")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
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
}
