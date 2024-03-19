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
local plugins = {}
local hpath = os.getenv("HOME")

package.preload.navPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/nav.lua")
vim.list_extend(plugins, require("navPlugins"))
package.preload.editingPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/editing.lua")
vim.list_extend(plugins, require("editingPlugins"))
package.preload.uiPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/ui.lua")
vim.list_extend(plugins, require("uiPlugins"))
package.preload.telescopePlugins = loadfile("/Users/es/.dotfiles/vim/lua/plugins/telescope.lua")
vim.list_extend(plugins, require("telescopePlugins"))
package.preload.lspPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/lsp.lua")
vim.list_extend(plugins, require("lspPlugins"))
package.preload.cmpPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/cmp.lua")
vim.list_extend(plugins, require("cmpPlugins"))
package.preload.formatterPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/formatter.lua")
vim.list_extend(plugins, require("formatterPlugins"))
package.preload.linterPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/linter.lua")
vim.list_extend(plugins, require("linterPlugins"))
package.preload.gitPlugins = loadfile(hpath .. "/.dotfiles/vim/lua/plugins/git.lua")
vim.list_extend(plugins, require("gitPlugins"))

require("lazy").setup(plugins, {
	ui = {
		border = "single",
	},
})

package.preload.basicConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/basic.lua")
require("basicConf")
package.preload.autocmdConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/autocmd.lua")
require("autocmdConf")
package.preload.pluginsConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/plugins.lua")
require("pluginsConf")
package.preload.keymapsConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/keymaps.lua")
require("keymapsConf")
