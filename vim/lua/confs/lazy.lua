-- This file is included by the main init.lua file and is responsible for
-- setting up lazy.nvim and loading plugins.

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

vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`
vim.opt.sessionoptions = { "buffers", "tabpages", "globals" } -- used by scope.nvim needs to happen before plugin loads

-- configure plugins
local plugins = {
	require("plugins.nav"),
	require("plugins.editing"),
	require("plugins.ui"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.cmp"),
	require("plugins.formatter"),
	require("plugins.linter"),
	require("plugins.git"),
}

require("lazy").setup(plugins, {
	ui = {
		border = "single",
	},
})
