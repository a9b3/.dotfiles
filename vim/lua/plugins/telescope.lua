return {
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"RRethy/base16-nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
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
					borderchars = {
						prompt = { "─", "│", " ", "│", "╭", "┬", "│", "│" },
						results = { "─", "│", "─", "│", "├", "┤", "┴", "╰" },
						preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
					},
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
}
