-- Autocommands
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	callback = function()
		if vim.o.filetype ~= "toggleterm" then
			vim.cmd("normal! <c-w>=")
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		local function return_to_normal_mode()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
		end
		return_to_normal_mode()
	end,
})

-- Automatically reload files when changed
vim.cmd([[
  augroup AutoReload
    autocmd!
    autocmd FocusGained,BufEnter * :checktime
  augroup END
]])

-- Clear trailing spaces
vim.cmd([[
  augroup ClearTrailingSpaces
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
  augroup END
]])

-- Toggle whitespace
vim.cmd([[
  if &diff
    set diffopt+=iwhite
    nnoremap gs :call IwhiteToggle()<CR>
    function! IwhiteToggle()
      if &diffopt =~ 'iwhite'
        set diffopt-=iwhite
      else
        set diffopt+=iwhite
      endif
    endfunction
  endif
]])
