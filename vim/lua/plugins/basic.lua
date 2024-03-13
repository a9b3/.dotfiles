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
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      direction = "horizontal",
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
	{
		"jedrzejboczar/possession.nvim",
		config = function()
			local cwd = vim.fn.getcwd():gsub("/", "%%")

			require("possession").setup({
				commands = {
					save = "SSave",
					load = "SLoad",
					delete = "SDelete",
					list = "SList",
				},
				autosave = { current = true, tmp = true, tmp_name = cwd, on_load = true, on_quit = true },
			})
		end,
	},
}
