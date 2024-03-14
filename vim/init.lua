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

-- configure plugins
local plugins = {}
local hpath = os.getenv("HOME")
package.preload.basicPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/basic.lua")
package.preload.myesuiPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/ui.lua")
package.preload.lspPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/lsp.lua")
package.preload.cmpPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/cmp.lua")
package.preload.formatterPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/formatter.lua")
package.preload.linterPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/linter.lua")
vim.list_extend(plugins, require("basicPlugins"))
vim.list_extend(plugins, require("myesuiPlugins"))
vim.list_extend(plugins, require("lspPlugins"))
vim.list_extend(plugins, require("cmpPlugins"))
vim.list_extend(plugins, require("formatterPlugins"))
vim.list_extend(plugins, require("linterPlugins"))

local opts = {
	ui = {
		border = "single",
	},
}

require("lazy").setup(plugins, opts)

package.preload.basicConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/basic.lua")
package.preload.autocmdConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/autocmd.lua")
package.preload.pluginsConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/plugins.lua")
package.preload.keymapsConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/keymaps.lua")
require("basicConf")
require("autocmdConf")
require("pluginsConf")
require("keymapsConf")
