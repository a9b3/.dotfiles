return {
	{
		"echasnovski/mini.ai",
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
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
		"lewis6991/gitsigns.nvim",
		config = function()
			-- use nerdfonts icons
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>gs", gs.stage_hunk, { desc = "[gitsigns] stage hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "[gitsigns] reset hunk" })
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[gitsigns] stage hunk" })
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[gitsigns] reset hunk" })
					map("n", "<leader>gS", gs.stage_buffer, { desc = "[gitsigns] stage buffer" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[gitsigns] undo stage hunk" })
					map("n", "<leader>gR", gs.reset_buffer, { desc = "[gitsigns] reset buffer" })
					map("n", "<leader>gp", gs.preview_hunk, { desc = "[gitsigns] preview hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true })
					end, { desc = "[gitsigns] blame line" })
					map(
						"n",
						"<leader>gtb",
						gs.toggle_current_line_blame,
						{ desc = "[gitsigns] toggle current line blame" }
					)
					map("n", "<leader>gd", gs.diffthis, { desc = "[gitsigns] diff this" })
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "[gitsigns] diff this (base)" })
					map("n", "<leader>gtd", gs.toggle_deleted, { desc = "[gitsigns] toggle deleted" })

					-- Text object
					map({ "o", "x" }, "<leader>gh", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{ "famiu/bufdelete.nvim" },
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<M-\>]],
				direction = "horizontal",
			})

			-- Set toggleterm keymaps
			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<M-\\>", [[<Cmd>:ToggleTerm <CR>]], opts)
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
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
		"jedrzejboczar/possession.nvim",
		lazy = false,
		config = function()
			local cwd = vim.fn.getcwd():gsub("/", "%%")

			if not vim.opt.diff:get() then
				require("possession").setup({
					commands = {
						save = "SSave",
						load = "SLoad",
						delete = "SDelete",
						list = "SList",
					},
					autosave = { current = true, tmp = true, tmp_name = cwd, on_load = true, on_quit = true },
				})

				-- possession auto load
				vim.cmd("SLoad " .. cwd)
			end
		end,
	},
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
		submodules = false,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
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
}
