-- Keybindings
vim.g.mapleader = ","
vim.keymap.set("n", "<leader>w", ":w!<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":qa<cr>", { desc = "Quit" })
vim.keymap.set("i", "jk", "<Esc>")
-- Navigation
vim.keymap.set("n", "<leader>[", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>]", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>d", ":Bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "[t", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "]t", ":tabprevious<CR>", { desc = "Previous tab" })
-- vim.keymap.set("n", "<C-w>", "<C-w>w") -- Move between windows
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "g_")
vim.keymap.set({ "n", "v" }, "J", "6j")
vim.keymap.set({ "n", "v" }, "K", "6k")
vim.keymap.set("n", "<leader><space>", ":nohlsearch<cr>", { desc = "Clear search" })
vim.keymap.set("x", "p", "pgvy") -- Paste over visual selection
-- Buffers
vim.keymap.set("n", "<leader>to", ":%bdelete|edit#|bdelete#<CR>", { desc = "Close all other buffers" })

-- Delete all buffers except current one
vim.keymap.set("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = false })
		end
	end
end, { desc = "Delete other buffers" })
