-- https://neovim.io/doc/user/lsp.html
local lspConfigs = {
	{
		name = "lua_ls",
		override = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		},
	},
	{ name = "ts_ls", override = {} },
	{
		name = "jsonls",
		override = function()
			return {
				settings = {
					json = {
						validate = { enable = true },
						schemas = require("schemastore").json.schemas(),
					},
				},
			}
		end,
	},
	{
		name = "yamlls",
		override = function()
			return {
				settings = {
					yaml = {
						validate = true,
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			}
		end,
	},
	{ name = "svelte", override = { settings = { svelte = { plugin = { svelte = { compilerWarnings = {} } } } } } },
	{
		name = "gopls",
		override = function()
			return {
				cmd = { "gopls", "serve" },
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
				root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
			}
		end,
	},
	{
		name = "nil_ls",
		override = function()
			return {
				root_dir = require("lspconfig").util.root_pattern("flake.nix", ".git"),
			}
		end,
	},
}

local masonInstalls = {}
for _, confs in ipairs(lspConfigs) do
	masonInstalls[#masonInstalls + 1] = confs.name
end

local on_attach_keybindings = function(_, _)
	vim.keymap.set(
		"n",
		"[d",
		"<cmd>Lspsaga diagnostic_jump_prev<cr>",
		{ remap = false, desc = "[lsp] Next diagnostic" }
	)
	vim.keymap.set(
		"n",
		"]d",
		"<cmd>Lspsaga diagnostic_jump_next<cr>",
		{ remap = false, desc = "[lsp] Previous diagnostic" }
	)
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { remap = false, desc = "[lsp] Declaration" })
	vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", { desc = "[lsp] Code actions" })
	vim.keymap.set("n", "<leader>lR", "<cmd>Lspsaga finder<cr>", { desc = "[lsp] Finder" })
	vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga peek_definition<cr>", { desc = "[lsp] Peek definition" })
	vim.keymap.set("n", "<leader>li", "<cmd>Lspsaga finder imp<cr>", { desc = "[lsp] Finder implementation" })
	vim.keymap.set("n", "<leader>lt", "<cmd>Lspsaga peek_type_definition<cr>", { desc = "[lsp] Peek type definition" })
	vim.keymap.set("n", "<leader>lc", "<cmd>Lspsaga hover_doc<cr>", { desc = "[lsp] Hover doc" })
	vim.keymap.set("n", "<leader>lo", "<cmd>Outline<cr>", { desc = "[lsp] Outline" })
	vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", { desc = "[lsp] Rename" })
end

local linters_by_ft = {
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	svelte = { "eslint_d" },
	lua = { "luacheck" },
	bzl = { "buildifier" },
}

-- This function retrieves the names of all active LSP clients for the current
-- buffer
local function getActiveLspClients()
	local active_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	local client_names = {}

	for _, client in ipairs(active_clients) do
		table.insert(client_names, client.name)
	end

	return "󰧑 " .. table.concat(client_names, ", ")
end

-- This module provides a function to display the current active linters in
-- Neovim.
local function activeLinters()
	local lint_progress = function()
		local linters = require("lint").get_running()
		if #linters == 0 then
			return "󰿞"
		end
		return "󰿞 " .. table.concat(linters, ", ")
	end

	return lint_progress()
end

return {

	-- ----------------------------------------------------------------------------
	-- Nav
	-- ----------------------------------------------------------------------------

	{ "famiu/bufdelete.nvim" },
	{ "tiagovla/scope.nvim", config = true }, -- scoped buffers to tabs

	-- ----------------------------------------------------------------------------
	-- Editing
	-- ----------------------------------------------------------------------------

	{ "echasnovski/mini.ai" }, -- ex. change in (
	{ "echasnovski/mini.surround" }, -- ex. change surrounding quotes
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		opts = {
			-- for keycodes sent within tmux
			toggler = { line = "<C-_>" },
			opleader = { line = "<C-_>" },
		},
		keys = {
			{ "<C-/>", "<Plug>(comment_toggle_linewise_current)", mode = "n", remap = true, silent = true },
			{ "<C-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "x", remap = true, silent = true },
		},
	},
	{ -- automatically close brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ -- Ctrl-d to select multiple like in VSCode
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
			}
		end,
	},

	-- ----------------------------------------------------------------------------
	-- UI
	-- ----------------------------------------------------------------------------

	{ -- pop up notifications
		"rcarriga/nvim-notify",
		opts = {
			max_width = 80,
			level = vim.log.levels.WARN,
		},
	},
	{ -- enhanced UI for messages and cmdline
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = true,
	},
	{ -- show indentation levels with thin lines
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
	{ -- base16 color schemes
		"RRethy/base16-nvim",
		config = function()
			local scheme = vim.env.BASE16_THEME
			vim.cmd("colorscheme base16-" .. scheme)
		end,
	},
	{ -- buffer line
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
	{ -- status line at the bottom
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"arkav/lualine-lsp-progress",
		},
		opts = {
			sections = {
				lualine_x = {
					getActiveLspClients,
					activeLinters,
					"encoding",
					"filetype",
				},
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		init = function()
			-- disable netrw
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
				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.set("n", "p", api.node.navigate.parent, {
					desc = "Up",
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				})
			end,
			sort = { sorter = "case_sensitive" },
			update_focused_file = { enable = true },
			view = { width = 40 },
			renderer = {
				group_empty = true,
				highlight_opened_files = "name",
				icons = { git_placement = "before" },
			},
			filters = { dotfiles = true, custom = { "node_modules" } },
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

	-- ----------------------------------------------------------------------------
	-- Telescope - fuzzy finder
	-- ----------------------------------------------------------------------------

	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"RRethy/base16-nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = {
						prompt_position = "top",
						preview_cutoff = 1, -- Preview should always show (unless previewer = false)
					},
					winblend = 5,
					mappings = {
						i = {
							["<C-h>"] = "which_key",
							["<esc>"] = actions.close,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
					border = true,
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
					},
					["ui-select"] = { require("telescope.themes").get_dropdown({}) },
				},
			})

			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("scope")
			require("telescope").load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "[Telescope] Find Files" })
			vim.keymap.set("n", "<leader>a", builtin.live_grep, { desc = "[Telescope] Live Grep" })
			vim.keymap.set("n", "<leader>sl", builtin.live_grep, { desc = "[Telescope] Live Grep" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[Telescope] Find Files" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[Telescope] Buffers" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[Telescope] Help Tags" })
			vim.keymap.set("n", "<leader>st", builtin.treesitter, { desc = "[Telescope] Treesitter" })
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[Telescope] Commands" })
			vim.keymap.set("n", "<leader>sa", ":Telescope<cr>", { desc = "[Telescope] Telescope" })
			vim.keymap.set("n", "<leader>sn", ":Telescope notify<cr>", { desc = "[Telescope] Notify" })
		end,
	},

	-- ----------------------------------------------------------------------------
	-- LSP
	-- ----------------------------------------------------------------------------

	{ -- show diagnostics, references, etc. in a pretty list
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
	{ -- language aware syntax highlighting
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		init = function()
			require("nvim-treesitter.install").compilers = { "gcc" }
		end,
		opts = {
			auto_install = true,
			highlight = { enable = true },
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		opts = {
			lightbulb = { enable = false },
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ -- file operations from the lsp server
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
	},
	{ -- dev helper for lazy.nvim
		"folke/lazydev.nvim",
		ft = "lua",
	},

	-- ----------------------------------------------------------------------------
	-- Copilot
	-- ----------------------------------------------------------------------------

	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false }, -- turn off inline ghost text
			panel = { enabled = false }, -- optional
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		opts = {},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
		opts = function()
			local select = require("CopilotChat.select")
			return { selection = select.unnamed }
		end,
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			chat.setup(opts)

			-- Visual selection → prompt
			vim.keymap.set("v", "<leader>cc", function()
				local prompt = vim.fn.input("CopilotChat: ")
				if prompt ~= "" then
					chat.ask(prompt, { selection = select.visual })
				end
			end, { desc = "CopilotChat (visual selection)" })

			-- Normal mode chat (no forced selection)
			vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "CopilotChat" })
		end,
	},

	-- ----------------------------------------------------------------------------
	-- Mason
	-- ----------------------------------------------------------------------------

	{ "b0o/schemastore.nvim" }, -- JSON/YAML schema store
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/schemastore.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for _, confs in ipairs(lspConfigs) do
				local override = (type(confs.override) == "function") and confs.override() or confs.override or {}
				vim.lsp.config(
					confs.name,
					vim.tbl_extend("force", override, {
						capabilities = capabilities,
						on_attach = on_attach_keybindings,
					})
				)
				vim.lsp.enable(confs.name)
			end
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = masonInstalls,
			automatic_installation = true,
		},
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
	},

	-- ----------------------------------------------------------------------------
	-- cmp
	-- ----------------------------------------------------------------------------

	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init({
				-- DEPRECATED (use mode instead): enables text annotations
				--
				-- default: true
				-- with_text = true,

				-- defines how annotations are shown
				-- default: symbol
				-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
				mode = "symbol_text",

				-- default symbol map
				-- can be either 'default' (requires nerd-fonts font) or
				-- 'codicons' for codicon preset (requires vscode-codicons font)
				--
				-- default: 'default'
				preset = "default",

				-- override preset symbols
				--
				-- default: {}
				symbol_map = {
					Text = "󰉿",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "",
				},
			})
		end,
	},
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
			"onsails/lspkind.nvim",
		},
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")

			require("luasnip/loaders/from_vscode").load()
			require("luasnip/loaders/from_snipmate").load({ path = { "./snippets" } })

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				preselect = cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<C-h>"] = cmp.mapping.scroll_docs(-4),
					["<C-l>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-d>"] = cmp.mapping.close(),
					["<C-e>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 1 },
					{ name = "nvim_lsp", group_index = 1 },
					{ name = "luasnip", group_index = 1 },
					{ name = "path", group_index = 2 },
					{ name = "buffer", group_index = 2 },
				}),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind =
							require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
			})

			-- setup filetype extends here
			-- Set lsp keymaps
			local ls = require("luasnip")
			ls.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.jump(1)
			end, { silent = true })
			luasnip.filetype_extend("typescript", { "javascript" })
			luasnip.filetype_extend("svelte", { "javascript" })
		end,
	},
	{
		"chrisgrieser/nvim-scissors",
		dependencies = "nvim-telescope/telescope.nvim", -- if using telescope
		opts = {
			snippetDir = "path/to/your/snippetFolder",
		},
	},

	-- ----------------------------------------------------------------------------
	-- formatter
	-- ----------------------------------------------------------------------------

	{
		"stevearc/conform.nvim",
		tag = "v5.4.0",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			format_on_save = {
				timeout_ms = 1000,
				async = false,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "eslint_d", "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				go = { "goimports" },
				nix = { "nixpkgs_fmt" },
				bzl = { "buildifier" },
			},
		},
	},

	-- ----------------------------------------------------------------------------
	-- lint
	-- ----------------------------------------------------------------------------

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

	-- ----------------------------------------------------------------------------
	-- git
	-- ----------------------------------------------------------------------------

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Navigation (respects diff mode)
				map("n", "]c", function()
					gs.nav_hunk("next")
				end, "Git: next hunk")
				map("n", "[c", function()
					gs.nav_hunk("prev")
				end, "Git: prev hunk")

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, "Git: stage hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Git: reset hunk")
				map("n", "<leader>gS", gs.stage_buffer, "Git: stage buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Git: undo stage hunk")
				map("n", "<leader>gR", gs.reset_buffer, "Git: reset buffer")
				map("n", "<leader>gp", gs.preview_hunk, "Git: preview hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Git: blame line")
				map("n", "<leader>gtb", gs.toggle_current_line_blame, "Git: toggle line blame")
				map("n", "<leader>gd", gs.diffthis, "Git: diff this")
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, "Git: diff vs base")
				map("n", "<leader>gtd", gs.toggle_deleted, "Git: toggle deleted")

				-- Visual stage/reset (range)
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Git: stage hunk")
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Git: reset hunk")

				-- Textobject (hunk)
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git: select hunk")
			end,
		},
	},
}
