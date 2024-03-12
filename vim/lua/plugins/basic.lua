return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup {}
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = '<C-_>',
      },
      opleader = {
        line = "<C-_>"
      },
    },
    lazy = false,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    "RRethy/base16-nvim",
    config = function()
      -- optionally enable 24-bit colour
      vim.opt.termguicolors = true

      -- Define a function to reload the color scheme
      local function reload_colorscheme()
        require('base16-colorscheme').load_from_shell()
      end

      -- Get the path to the base16 theme file
      local base16_theme_file = vim.env.BASE16_SHELL_COLORSCHEME_PATH

      -- Create an autocommand group to watch for file changes
      vim.api.nvim_create_augroup("Base16ThemeWatch", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = "Base16ThemeWatch",
        pattern = base16_theme_file,
        callback = reload_colorscheme,
      })


      require('base16-colorscheme').load_from_shell()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup()
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
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
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
    keys = {
      { "<C-n>",     "<cmd>NvimTreeToggle<cr>" },
      { "<leader>f", "<cmd>NvimTreeFindFile<cr>" },
    },
  },
}
