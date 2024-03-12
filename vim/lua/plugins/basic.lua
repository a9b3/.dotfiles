return {
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
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  { "famiu/bufdelete.nvim" },
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
  },
}
