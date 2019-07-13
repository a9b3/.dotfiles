" ============================================================================
" GENERAL
" ============================================================================

" Enable filetype plugins
filetype plugin indent on
syntax enable

" File types
au BufRead,BufNewFile *.ejs set filetype=html
au BufRead,BufNewFile *.handlebars set filetype=html
au BufRead,BufNewFile *.css set filetype=scss.css
au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.service set filetype=yaml
au BufRead,BufNewFile *.js set filetype=javascript
au BufRead,BufNewFile *.conf set filetype=nginx
au BufRead,BufNewFile *.sls set filetype=yaml
au BufRead,BufNewFile *.ts set filetype=typescript.jsx
au BufRead,BufNewFile *.tsx set filetype=typescript.jsx
au BufRead,BufNewFile *.groovy set filetype=Jenkinsfile
au BufRead,BufNewFile *.{yaml,yml} set filetype=yaml

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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
set showcmd                                   " Show incomplete cmds down the bottom
set hidden                                    " A buffer becomes hidden when it is abandoned
set ignorecase smartcase hlsearch incsearch   " Search settings
set nobackup nowb noswapfile                  " No vim backup files
set ffs=unix,dos,mac                          " Use Unix as the standard file type
set noerrorbells novisualbell t_vb= tm=500    " No annoying sound on errors
set tags=./tags,tags;/                        " keep looking up until tags is found
set backspace=eol,start,indent                " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l                        " automatically wrap left and right
set relativenumber                            " show relative number from curent line
set t_Co=256                                  " 256 colors in vim
set textwidth=80 colorcolumn=80 lbr tw=80     " set line break to 80
set number numberwidth=2                      " show line number in left margin
" set cursorline!                               " highlight current cursor's line
set ruler laststatus=2 title                  " Sets ruler show current line
set magic                                     " For regular expressions turn magic on
set showmatch                                 " Show matching brackets when text indicator is over them
set mat=2                                     " How many tenths of a second to blink when matching brackets
set wildmenu                                  " Turn on the WiLd menu
set wildmode=list:longest,full
set wildignorecase
set wildignore=*.o,*~,*.pyc                   " Ignore compiled files
set shiftwidth=2 tabstop=2 expandtab smarttab " tab space
set ai                                        " Auto indent
set si                                        " Smart indent
set wrap                                      " Wrap lines

autocmd BufWritePre * :%s/\s\+$//e          " Clear trailing spaces on save

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
nmap <leader>d :bdelete<CR>

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

" ============================================================================
" VIM_PLUG
" ============================================================================

call plug#begin('~/.vim/plugged')

" ---------------------------------
"  AUTOCOMPLETE
" ---------------------------------
let g:python3_host_prog = '/usr/local/bin/python3'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
let g:pyxversion=3

set completeopt-=preview
set completeopt+=menuone
autocmd FileType scss.css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" ---------------------------------
"  GENERAL
" ---------------------------------
" Set vim's project root to the closest ancestor directory containing the
" rooter_patterns
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['package.json', '.git/']

" Use base16 color theme
Plug 'chriskempson/base16-vim'

" Navigation
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=45
let g:NERDTreeIgnore = ['node_modules']

" Tab bar for buffers
Plug 'ap/vim-buftabline'

Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_start_word_key      = '<C-k>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-k>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-k>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'
" Disable Deoplete when selecting multiple cursors starts
function! Multiple_cursors_before()
    if exists('*deoplete#disable')
        exe 'call deoplete#disable()'
    elseif exists(':NeoCompleteLock') == 2
        exe 'NeoCompleteLock'
    endif
endfunction
" Enable Deoplete when selecting multiple cursors ends
function! Multiple_cursors_after()
    if exists('*deoplete#toggle')
        exe 'call deoplete#toggle()'
    elseif exists(':NeoCompleteUnlock') == 2
        exe 'NeoCompleteUnlock'
    endif
endfunction

" Snippets
Plug 'SirVer/ultisnips'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-bk>"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" Fuzzy file search
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_custom_ignore='node_modules\|DS_STORE\|bower_components\|.sass-cache\|dist\|plugins\|platform\|public\|production'
" use rg to search, ignores custom ignores
let g:ctrlp_user_command='rg %s --files --color=never --glob ""'
" ctrlP auto cache clearing, rescan for new files on save for ctrlp
" http://stackoverflow.com/questions/8663829/vim-ctrlp-vim-plugin-how-to-rescan-files
function! SetupCtrlP()
  if exists("g:loaded_ctrlp") && g:loaded_ctrlp
    augroup CtrlPExtension
      autocmd!
      autocmd FocusGained * CtrlPClearCache
      autocmd BufWritePost * CtrlPClearCache
    augroup END
  endif
endfunction
if has("autocmd")
  autocmd VimEnter * :call SetupCtrlP()
endif

" change surrounding delimiters
Plug 'tpope/vim-surround'
" gS spit single into multi line, gJ to join back into one line
Plug 'AndrewRadev/splitjoin.vim'

Plug 'easymotion/vim-easymotion'
" easy motion trigger with 's'
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" override default search /
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
let g:EasyMotion_user_smartsign_us = 1

" C-// to start comment
Plug 'tomtom/tcomment_vim'
" Better git commit editing window
Plug 'rhysd/committia.vim'

" automatic closing of quotes
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=1
au FileType mail let b:delimitMate_expand_cr = 1

Plug 'majutsushi/tagbar'
let g:tagbar_type_typescript = {
  \ 'ctagsbin' : 'tstags',
  \ 'ctagsargs' : '-f-',
  \ 'kinds': [
    \ 'e:enums:0:1',
    \ 'f:function:0:1',
    \ 't:typealias:0:1',
    \ 'M:Module:0:1',
    \ 'I:import:0:1',
    \ 'i:interface:0:1',
    \ 'C:class:0:1',
    \ 'm:method:0:1',
    \ 'p:property:0:1',
    \ 'v:variable:0:1',
    \ 'c:const:0:1',
  \ ],
  \ 'sort' : 0
\ }
nmap <F8> :TagbarToggle<CR>

" ---------------------------------
"  GIT
" ---------------------------------
" Jump to github line
" blob view <leader>gh
" blame view <leader>gb
Plug 'ruanyl/vim-gh-line'
let g:gh_user_canonical = 0 " Use branch name when possible

Plug 'tpope/vim-fugitive'
" shortcut Gblame
nnoremap <leader>g :Gblame<cr>

" Disply git status per line on the right guttter
Plug 'airblade/vim-gitgutter'
set updatetime=2000
let g:gitgutter_realtime=1
set signcolumn=yes

" ---------------------------------
"  SYNTAX
" ---------------------------------
Plug 'martinda/Jenkinsfile-vim-syntax'
" NGINX conf file synxtax
Plug 'chr4/nginx.vim'
Plug 'hashivim/vim-terraform'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
Plug 'mustache/vim-mustache-handlebars'


" ---------------------------------
"  LINT
" ---------------------------------
Plug 'w0rp/ale'
let g:ale_linters = {
\  'javascript': ['flow', 'eslint']
\}
" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
" You can disable this option too
" if you don't want linters to run on opening a file
" let g:ale_lint_on_enter = 1
let g:ale_fix_on_save = 1
" already running eslint --fix on save no need to lint again
let g:ale_lint_on_save = 0
" use faster version
let g:ale_javascript_eslint_executable='eslint_d'
let g:ale_pattern_options = {
\   '.*node_modules.*': {'ale_enabled': 0},
\}
let g:ale_sign_column_always = 1
" eslint is a command that will automatically run eslint --fix
" https://github.com/w0rp/ale/issues/541
" let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --no-semi'
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_fixers = {
\   'javascript': [
\       'prettier',
\       'eslint',
\   ],
\   'typescript': [
\       'prettier',
\       'eslint',
\   ],
\}
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>ap :ALEPreviousWrap<cr>

" ---------------------------------
"  GOLANG
" ---------------------------------
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_def_mode = 'godef'

" ---------------------------------
"  GOLANG
" ---------------------------------
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1

" ---------------------------------
"  JS
" ---------------------------------
" html tag insert shortcuts
Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-Z>'

Plug 'pangloss/vim-javascript'
let g:javascript_plugin_flow = 1
Plug 'mxw/vim-jsx'

" ---------------------------------
"  JS FLOW
" ---------------------------------
Plug 'wokalski/autocomplete-flow'
Plug 'flowtype/vim-flow', {
      \ 'autoload': {
      \   'filetypes': 'javascript'
      \ },
      \ 'build': {
      \   'mac': 'npm install -g flow-bin'
      \ }}
"Use locally installed flow
let local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(local_flow, "^\/\\w") == ''
    let local_flow= getcwd() . "/" . local_flow
endif
if executable(local_flow)
  let g:flow#flowpath = local_flow
endif
let g:flow#autoclose = 1
let g:flow#showquickfix = 0
map <leader>z :FlowJumpToDef<CR>


" ---------------------------------
"  TYPESCRIPT PLUGS
" ---------------------------------
" TSServer client
Plug 'Quramy/tsuquyomi'
" Typescript syntax highlighting
Plug 'leafgarland/typescript-vim'
" Integration with deoplete for autocomplete
Plug 'rudism/deoplete-tsuquyomi'
Plug 'peitalin/vim-jsx-typescript'

autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

call plug#end()

let base16colorspace=256        " Let base16 access colors present in 256 colorspace
colorscheme base16-default-dark

set secure
