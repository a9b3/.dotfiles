local uiPlugins = {
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{ "rcarriga/nvim-notify" },
	{
		"folke/noice.nvim",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				max_width = 80,
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = {
					char = "╎",
				},
				scope = {
					enabled = true,
					show_start = false,
				},
			})
		end,
	},
	{
		"RRethy/base16-nvim",
		config = function()
			vim.opt.termguicolors = true

			local fn = vim.fn
			local cmd = vim.cmd
			local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
			local is_set_theme_file_readable = fn.filereadable(fn.expand(set_theme_path)) == 1 and true or false

			if is_set_theme_file_readable then
				cmd("let base16colorspace=256")
				cmd("source " .. set_theme_path)
			end

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
		config = function()
			require("bufferline").setup({
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
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				sections = {
					lualine_x = {
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
						"fileformat",
						"filetype",
					},
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		init = function()
			-- disable netrw at the very start of your init.lua
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require("nvim-tree").setup({
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
					width = 30,
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
			})
		end,
		keys = {
			{ "<C-n>", "<cmd>NvimTreeToggle<cr>" },
			{ "<leader>f", "<cmd>NvimTreeFindFile<cr>" },
		},
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
				},
			})
		end,
	},
}
package.preload.mytele = loadfile("/Users/es/.dotfiles/vim/lua/plugins/telescope.lua")
vim.list_extend(uiPlugins, require("mytele"))

return uiPlugins
