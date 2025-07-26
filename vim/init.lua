local hpath = os.getenv("HOME")
local customPath = hpath .. "/.dotfiles/vim/lua/?.lua"
package.path = package.path ..";" .. customPath

require("confs.lazy")

package.preload.basicConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/basic.lua")
require("basicConf")
package.preload.autocmdConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/autocmd.lua")
require("autocmdConf")
package.preload.pluginsConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/plugins.lua")
require("pluginsConf")
package.preload.keymapsConf = loadfile(hpath .. "/.dotfiles/vim/lua/confs/keymaps.lua")
require("keymapsConf")
