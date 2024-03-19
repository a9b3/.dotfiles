-- General settings
vim.o.encoding = "utf8"
vim.o.compatible = false
vim.o.clipboard = "unnamed" -- Use system clipboard, vim must have +clipboard
vim.o.readonly = false -- For vimdiff
vim.o.history = 1000 -- Sets how many lines of history VIM has to remember
vim.o.backspace = "eol,start,indent" -- Configure backspace so it acts as it should act
vim.o.fileformats = "unix,dos,mac" -- Use Unix as the standard file type
vim.opt.iskeyword:append("-") -- Treat dash as word

-- User interface
vim.o.number = true -- Show line number in left margin
vim.o.numberwidth = 2
vim.o.cursorline = true -- Highlight current cursor's line
vim.o.ruler = true
vim.o.laststatus = 2
vim.o.title = true -- Sets ruler to show current line
vim.o.showmatch = true -- Show matching brackets when text indicator is over them
vim.o.mat = 2 -- How many tenths of a second to blink when matching brackets
vim.o.cmdheight = 2 -- Display for messages
vim.o.showcmd = true -- Show incomplete commands down the bottom
vim.o.wildmenu = true -- Turn on the WiLd menu
vim.o.wildmode = "list:longest,full"
vim.o.wildignorecase = true
vim.o.wildignore = "*.o,*~,*.pyc" -- Ignore compiled files
vim.o.textwidth = 80 -- Set line break to 80
vim.o.colorcolumn = "80"
vim.o.linebreak = true
vim.o.signcolumn = "yes"
vim.o.conceallevel = 2 -- For markdown

-- Colors and highlighting
vim.o.background = "dark" -- Set dark background
vim.cmd("syntax enable")

-- Indentation and formatting
vim.o.autoindent = true -- Auto-indent new lines
vim.o.smartindent = true -- Enable smart-indent
vim.o.shiftwidth = 2 -- Tab space
vim.o.tabstop = 2
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.smarttab = true -- Use shiftwidths for tab
vim.o.wrap = true -- Wrap lines
vim.o.copyindent = true -- Paste mode

-- Searching
vim.o.ignorecase = true -- Ignore case when searching
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.magic = true -- For regular expressions turn magic on

-- Performance
vim.o.ttyfast = true -- Send more characters for faster redraws
vim.o.lazyredraw = true -- Don't redraw while executing macros
vim.o.updatetime = 300

-- Backup and swap files
vim.o.backup = false -- No vim backup files
vim.o.writebackup = false
vim.o.swapfile = false

-- Buffers and windows
vim.o.hidden = true -- A buffer becomes hidden when it is abandoned
vim.o.autoread = true -- Update when a file is changed from the outside
vim.o.splitbelow = true -- Horizontal splits will automatically be below
vim.o.splitright = true -- Vertical splits will automatically be to the right

-- Set git diff options
vim.opt.diffopt:append("internal,algorithm:patience")

-- File types and syntax highlighting
vim.cmd("filetype plugin indent on")

vim.cmd([[
  augroup FileTypes
    autocmd!
    autocmd BufRead,BufNewFile *.ejs,*.handlebars set filetype=html
    autocmd BufRead,BufNewFile *.css set filetype=scss.css
    autocmd BufRead,BufNewFile *.scss set filetype=scss
    autocmd BufRead,BufNewFile *.js set filetype=javascript
    autocmd BufRead,BufNewFile *.conf set filetype=nginx
    autocmd BufRead,BufNewFile *.sls,*.{yaml,yml},*.service set filetype=yaml
    autocmd BufRead,BufNewFile *.ts,*.tsx set filetype=typescript.tsx
    autocmd BufRead,BufNewFile *.groovy set filetype=Jenkinsfile
    autocmd BufRead,BufNewFile *.Dockerfile set filetype=dockerfile
    autocmd BufRead,BufNewFile .bazelrc set filetype=conf
    autocmd BufRead,BufNewFile *.json set filetype=jsonc
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType snippets setlocal ts=4 sts=4 sw=4 expandtab=false
    autocmd FileType scss.css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType json syntax match Comment +\/\/.\+$+
  augroup END
]])
