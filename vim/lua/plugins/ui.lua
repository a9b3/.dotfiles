return {
	{
		"rcarriga/nvim-notify",
		opts = {
			max_width = 80,
			level = vim.log.levels.WARN,
		},
		config = true,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = true,
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
		config = true,
	},
	{
		"RRethy/base16-nvim",
		config = function()
			vim.opt.termguicolors = true

			local function reload_colorscheme()
				require("base16-colorscheme").load_from_shell()
			end

			local base16_theme_file = vim.env.BASE16_SHELL_COLORSCHEME_PATH

			-- Create an autocommand group to watch for file changes
			vim.api.nvim_create_augroup("Base16ThemeWatch", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = "Base16ThemeWatch",
				pattern = base16_theme_file,
				callback = reload_colorscheme,
			})

			require("base16-colorscheme").load_from_shell()
		end,
	},
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
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"arkav/lualine-lsp-progress",
		},
		opts = {
			sections = {
				lualine_x = {
					function()
						local active_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
						local client_names = {}

						for _, client in ipairs(active_clients) do
							table.insert(client_names, client.name)
						end

						return table.concat(client_names, ", ")
					end,
					{
						"lsp_progress",
						display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
						timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
						spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
					},
					function()
						local lint_progress = function()
							local linters = require("lint").get_running()
							if #linters == 0 then
								return "󰦕"
							end
							return "󱉶 " .. table.concat(linters, ", ")
						end

						return lint_progress()
					end,
					"encoding",
					"filetype",
				},
			},
		},
		config = true,
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
		config = true,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			require("which-key").setup({
				mode = { "n", "v" },
				window = {
					border = "single",
					margin = { 0.5, 0.2, 0.5, 0.2 },
					position = "top",
				},
			})
			require("which-key").register({
				["<leader>"] = {
					g = { name = "Git" },
					t = { name = "Tab" },
					l = { name = "LSP" },
					s = { name = "Telescope" },
					x = { name = "Trouble" },
					n = { name = "Navigation" },
				},
			})
		end,
	},
}
