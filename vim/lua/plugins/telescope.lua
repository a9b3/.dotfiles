return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            preview_cutoff = 1, -- Preview should always show (unless previewer = false)
          },
          winblend = 5,
          mappings = {
            i = {
              -- actions.which_key shows the mappings for your picker,
              ["<C-h>"] = "which_key",
              ["<esc>"] = actions.close,
            },
          },
          border = true,
          borderchars = {
            prompt = { "─", "│", "x", "│", "╭", "┬", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┴", "╰" },
            preview = { "─", "│", "─", " ", "─", "╮", "╯", "─" },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "ignore_case",       -- or "ignore_case" or "respect_case"
          },
          ["ui-select"] = { require("telescope.themes").get_dropdown {} }
        }
      }

      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('scope')
      require('telescope').load_extension('ui-select')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>a', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})

      local borderColor = require('base16-colorscheme').colors.base01
      local borderOpt = { fg = borderColor }
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", borderOpt)
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", borderOpt)
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", borderOpt)
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = require('base16-colorscheme').colors.base02 })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = require('base16-colorscheme').colors.base02 })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = require('base16-colorscheme').colors.base02 })
    end,
  },
}
