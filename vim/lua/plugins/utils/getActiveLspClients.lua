-- This function retrieves the names of all active LSP clients for the current
-- buffer
return function()
	local active_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	local client_names = {}

	for _, client in ipairs(active_clients) do
		table.insert(client_names, client.name)
	end

	return "󰧑 " .. table.concat(client_names, ", ")
end
