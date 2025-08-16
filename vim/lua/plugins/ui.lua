return {
	-- "rcarriga/nvim-notify" provides a notification system
	{
		"rcarriga/nvim-notify",
		opts = {
			max_width = 80,
			level = vim.log.levels.WARN,
		},
	},
	-- "folke/noice.nvim" provides a better UI for messages, cmdline, and
	-- notifications
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = true,
	},
	-- "folke/twilight.nvim" dims inactive portions of the code to reduce
	{
		"folke/twilight.nvim",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPre",
		opts = {
			indent = {
				char = "╎",
			},
			scope = {
				enabled = true,
				show_start = false,
			},
		},
	},
	{
		"RRethy/base16-nvim",
		config = function()
			local scheme = vim.env.BASE16_THEME
			vim.cmd("colorscheme base16-" .. scheme)
		end,
	},
	-- "akinsho/bufferline.nvim" provides a tab-like interface for buffers
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				indicator = {
					style = "underline",
				},
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},
			},
		},
	},
	-- "nvim-lualine/lualine.nvim" provides a status line at the bottom of the
	-- screen
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"arkav/lualine-lsp-progress",
		},
		opts = {
			sections = {
				lualine_x = {
					require("plugins.utils.getActiveLspClients"),
					require("plugins.utils.activeLinters"),
					"encoding",
					"filetype",
				},
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		init = function()
			-- disable netrw at the very start of your init.lua
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		keys = {
			{ "<C-n>", "<cmd>NvimTreeToggle<cr>" },
			{ "<leader>f", "<cmd>NvimTreeFindFile<cr>" },
		},
		opts = {
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- custom mappings
				vim.keymap.set("n", "p", api.node.navigate.parent, opts("Go to parent"))
			end,
			sort = {
				sorter = "case_sensitive",
			},
			update_focused_file = {
				enable = true,
			},
			view = {
				width = 40,
			},
			renderer = {
				group_empty = true,
				highlight_opened_files = "name",
				icons = {
					git_placement = "after",
				},
			},
			filters = {
				dotfiles = true,
				custom = { "node_modules" },
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			preset = "modern",
			layout = {
				height = { min = 4, max = 10 },
			},
			icons = { mappings = false },
			spec = {
				{ "<leader>g", name = "Git" },
				{ "<leader>t", name = "Tab" },
				{ "<leader>l", name = "LSP" },
				{ "<leader>s", name = "Telescope" },
				{ "<leader>x", name = "Trouble" },
				{ "<leader>n", name = "Navigation" },
			},
		},
	},
}
