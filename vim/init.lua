local hpath = os.getenv("HOME")
local customPath = hpath .. "/.dotfiles/vim/lua/?.lua"
package.path = package.path .. ";" .. customPath

require("confs.lazy")

require("confs.basic")
require("confs.autocmd")
require("confs.plugins")
require("confs.keymaps")
