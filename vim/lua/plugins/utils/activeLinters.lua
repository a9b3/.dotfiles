-- This module provides a function to display the current active linters in
-- Neovim.
return function()
	local lint_progress = function()
		local linters = require("lint").get_running()
		if #linters == 0 then
			return "󰿞"
		end
		return "󰿞 " .. table.concat(linters, ", ")
	end

	return lint_progress()
end
