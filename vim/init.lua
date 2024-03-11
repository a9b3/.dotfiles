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
-- Example using a list of specs with the default options
vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`
require("lazy").setup({
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup {}
    end,
  },
  {
      'numToStr/Comment.nvim',
      opts = {
          toggler = {
            line = '<C-_>',
          },
          opleader = {
            line = "<C-_>"
          },
      },
      lazy = false,
  },
  {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true
      -- use opts = {} for passing setup options
      -- this is equalent to setup({}) function
  },
  {
    "RRethy/base16-nvim",
    config = function()
      -- optionally enable 24-bit colour
      vim.opt.termguicolors = true

      -- Define a function to reload the color scheme
      local function reload_colorscheme()
        require('base16-colorscheme').load_from_shell()
      end

      -- Get the path to the base16 theme file
      local base16_theme_file = vim.env.BASE16_SHELL_COLORSCHEME_PATH

      -- Create an autocommand group to watch for file changes
      vim.api.nvim_create_augroup("Base16ThemeWatch", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = "Base16ThemeWatch",
        pattern = base16_theme_file,
        callback = reload_colorscheme,
      })


      require('base16-colorscheme').load_from_shell()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup()
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-tree/nvim-tree.lua",
    init = function()
      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        update_focused_file = {
          enable = true,
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          highlight_opened_files = "name",
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
    keys = {
      {"<C-n>", "<cmd>NvimTreeToggle<cr>"},
      {"<leader>f", "<cmd>NvimTreeFindFile<cr>"},
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = { "c", "rust" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                  return true
              end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
    config = function()
      -- You dont need to set any of these options. These are the default ones. Only
      -- the loading is important
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          }
        }
      }
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>a', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end,
  },
  {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
  },
}, {
  ui = {
    border = "single",
  },
})

vim.cmd([[
  " Enable filetype plugins
  filetype plugin indent on
  syntax enable

  " Resize vim upon resize eg. pane sizing when resizing terminal window
  au VimResized * exe "normal! \<c-w>="

  set encoding=utf8
  set nocompatible
  set clipboard=unnamed                         " use system clipboard, vim must have +clipboard
  set noreadonly                                " for vimdiff
  set history=1000                              " Sets how many lines of history VIM has to remember
  set ttyfast                                   " send more characters for faster redraws
  set lazyredraw                                " Don't redraw while executing macros
  set autoread                                  " update when a file is changed from the outside
  " reload buffer when moving around for file changes from outside
  " https://vi.stackexchange.com/questions/444/how-do-i-reload-the-current-file
  au FocusGained,BufEnter * :checktime
  set showcmd                                   " Show incomplete cmds down the bottom
  set hidden                                    " A buffer becomes hidden when it is abandoned
  set ignorecase smartcase hlsearch incsearch   " Search settings
  set nobackup nowb noswapfile                  " No vim backup files
  set ffs=unix,dos,mac                          " Use Unix as the standard file type
  set noerrorbells novisualbell t_vb= tm=500    " No annoying sound on errors
  set backspace=eol,start,indent                " Configure backspace so it acts as it should act
  set whichwrap+=<,>,h,l                        " automatically wrap left and right
  set t_Co=256                                  " 256 colors in vim
  set textwidth=80 colorcolumn=80 lbr tw=80     " set line break to 80
  set number numberwidth=2                      " show line number in left margin
  set cursorline!                               " highlight current cursor's line
  set ruler laststatus=2 title                  " Sets ruler show current line
  set magic                                     " For regular expressions turn magic on
  set showmatch                                 " Show matching brackets when text indicator is over them
  set mat=2                                     " How many tenths of a second to blink when matching brackets
  set wildmenu                                  " Turn on the WiLd menu
  set wildmode=list:longest,full
  set wildignorecase
  set wildignore=*.o,*~,*.pyc                   " Ignore compiled files
  set shiftwidth=2 tabstop=2 expandtab smarttab " tab space
  set wrap                                      " Wrap lines
  set cmdheight=2                               " Display for messages
  set updatetime=300
  set signcolumn=yes
  set copyindent                                " Paste mode
  set iskeyword+=- " treat dash as word
  " for markdown
  " https://github.com/plasticboy/vim-markdown/#options
  set conceallevel=2

  autocmd BufWritePre * :%s/\s\+$//e            " Clear trailing spaces on save

  " File types
  au BufRead,BufNewFile *.ejs,*.handlebars set filetype=html
  au BufRead,BufNewFile *.css set filetype=scss.css
  au BufRead,BufNewFile *.scss set filetype=scss
  au BufRead,BufNewFile *.js set filetype=javascript
  au BufRead,BufNewFile *.conf set filetype=nginx
  au BufRead,BufNewFile *.sls,*.{yaml,yml},*.service set filetype=yaml
  au BufRead,BufNewFile *.ts,*.tsx set filetype=typescript.tsx
  au BufRead,BufNewFile *.groovy set filetype=Jenkinsfile
  au BufRead,BufNewFile *.Dockerfile set filetype=dockerfile
  au BufRead,BufNewFile .bazelrc set filetype=conf

  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType scss.css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " vimdiff, ignore whitespace
  if &diff
    " diff mode
    set diffopt+=iwhite
    map gs :call IwhiteToggle()<CR>
    function! IwhiteToggle()
      if &diffopt =~ 'iwhite'
        set diffopt-=iwhite
      else
        set diffopt+=iwhite
      endif
    endfunction
  endif

  set diffopt+=internal,algorithm:patience

  " ============================================================================
  " KEYBINDINGS
  " ============================================================================

  " Set Leader
  let g:mapleader = ","
  " save and quit
  map <leader>w :w!<cr>
  map <leader>q :qa<cr>
  " jk to escape from all modes
  imap jk <Esc>
  " control a/e will go back and front of line
  imap <C-a> <esc>I
  imap <C-e> <esc>A
  " tab buffer shortcuts
  nmap <leader>[ :bprevious<CR>
  nmap <leader>] :bnext<CR>
  nmap <leader>d :bd<CR>
  " Shorten next window command
  " see more here
  " :help <C-w>
  map <C-w> <C-w>w
  " next search will center screen
  nnoremap n nzzzv
  nnoremap N Nzzzv
  " replace word under cursor
  nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
  " move up and down wrapped lines
  nnoremap j gj
  nnoremap k gk
  " capitol movement keys will do sensible corresponding movement
  noremap H ^
  noremap L g_
  noremap J 6j
  noremap K 6k
  noremap <leader>1 :%bd\|e#<CR>
  " clear search highlight
  nnoremap <leader><space> :nohlsearch<cr>
  " shortcut for visual mode sort
  vnoremap <leader>s :sort
  " do not override register when pasting
  xnoremap p pgvy
  " execute macro on every line of visual selection
  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
  map <leader>e :Explore<CR>
  let g:netrw_list_hide = '^\..*'
  let g:netrw_hide = 1

  " ============================================================================
  " VIM_PLUG
  " ============================================================================


  " coc
  call plug#begin(stdpath('data') . '/plugged')
  Plug 'jesseleite/vim-agriculture'
  Plug 'fatih/vim-hclfmt'
  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'othree/html5.vim'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'mxw/vim-jsx'
  Plug 'othree/yajs.vim'
  Plug 'evanleck/vim-svelte'
  Plug 'google/vim-glaive'
  Plug 'qpkorr/vim-bufkill'
  Plug 'SirVer/ultisnips'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'easymotion/vim-easymotion'
  Plug 'Raimondi/delimitMate'
  Plug 'mhinz/vim-signify'
  Plug 'rhysd/committia.vim'
  Plug 'hashivim/vim-terraform'
  Plug 'chr4/nginx.vim'
  Plug 'elzr/vim-json'
  Plug 'jparise/vim-graphql'
  Plug 'jvirtanen/vim-hcl'
  Plug 'fatih/vim-go'
  Plug 'rust-lang/rust.vim'
  Plug 'mattn/emmet-vim'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'plasticboy/vim-markdown'
  Plug 'LnL7/vim-nix'
  Plug 'google/vim-maktaba'
  Plug 'google/vim-codefmt'
  Plug 'bazelbuild/vim-bazel'
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'} " color highlighting
  Plug 'josa42/coc-docker', {'do': 'yarn install --frozen-lockfile'}
  Plug 'coc-extensions/coc-svelte', {'do': 'yarn install --frozen-lockfile'}
  Plug 'leafOfTree/vim-svelte-plugin'
  Plug 'github/copilot.vim'

  " --------------------------------------------
  "  coc-prettier
  " --------------------------------------------
  " Prettier Settings
  " let g:prettier#quickfix_enabled = 0
  " let g:prettier#autoformat_require_pragma = 0
  " add svelte files to the default
  " au BufWritePre *.css,*.svelte,*.pcss,*.html,*.ts,*.js,*.json PrettierAsync

  " use <tab> for trigger completion and navigate to the next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
  " Use K to show documentation in preview window
  nnoremap <silent> <C-a> :call <SID>show_documentation()<CR>
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  inoremap <silent><expr> <c-space> coc#refresh()
  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  " Remap keys for gotos
  nmap <C-]> <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " Use K to show documentation in preview window
  nnoremap <leader>m :call <SID>show_documentation()<CR>


  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Snippets
  " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
  let g:UltiSnipsExpandTrigger="<c-k>"
  let g:UltiSnipsJumpForwardTrigger="<c-k>"
  let g:UltiSnipsJumpBackwardTrigger="<c-bk>"
  let g:UltiSnipsSnippetsDir = "~/.dotfiles/vim/UltiSnips"
  let g:UltiSnipsSnippetDirectories=[$HOME . '/.dotfiles/vim/UltiSnips']

  " vim-visual-multi
  let g:VM_maps = {}
  let g:VM_maps['Find Under']         = '<C-k>'           " replace C-n
  let g:VM_maps['Find Subword Under'] = '<C-k>'           " replace visual C-n

  " easy motion trigger with 's'
  let g:EasyMotion_do_mapping = 0
  nmap s <Plug>(easymotion-overwin-f2)
  let g:EasyMotion_smartcase = 1
  map <Leader>j <Plug>(easymotion-j)
  map <Leader>k <Plug>(easymotion-k)
  " override default search /
  " map / <Plug>(easymotion-sn)
  " omap / <Plug>(easymotion-tn)
  let g:EasyMotion_user_smartsign_us = 1
  " Plug 'Raimondi/delimitMate'
  let delimitMate_expand_cr=1
  au FileType mail let b:delimitMate_expand_cr = 1
  " ==================================================================== SYNTAX "
  let g:terraform_align=1
  let g:terraform_fmt_on_save=1
  let g:vim_json_syntax_conceal = 0
  " ==================================================================== GOLANG "
  let g:go_doc_keywordprg_enabled = 0
  let g:go_fmt_command = "goimports"
  let g:go_def_mode = 'godef'

  " ====================================================================== RUST "
  let g:rustfmt_autosave = 1
  " ================================================================ JAVASCRIPT "
  let g:user_emmet_leader_key='<C-Z>'
  let g:svelte_preprocessors = ['typescript']

  " https://github.com/google/vim-codefmt
  augroup autoformat_settings
    autocmd FileType bzl AutoFormatBuffer buildifier
  augroup END

  let g:vim_markdown_folding_disabled = 1

  call plug#end()

  " ============================================================================
  " Windows WSL
  " ============================================================================

  " Setup yanking from vim to windows clipboard
  if system('uname -r') =~ "microsoft"
    augroup Yank
      autocmd!
      autocmd TextYankPost * :call system('clip.exe ',@")")
    augroup END
  endif

  set secure

  au BufRead,BufNewFile *.json set filetype=jsonc
]])

