-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","       -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

-- configure plugins
local plugins = {}
vim.list_extend(plugins, require("plugins/basic"))
vim.list_extend(plugins, require("plugins/ui"))
vim.list_extend(plugins, require('plugins/lsp'))

local opts = {
  ui = {
    border = "single",
  },
}

require("lazy").setup(plugins, opts)

require("confs/basic")
