" ============================================================================
" General
" ============================================================================

set encoding=utf8
set nocompatible

set clipboard=unnamed " use system clipboard, vim must have +clipboard
set noreadonly        " for vimdiff
set history=1000      " Sets how many lines of history VIM has to remember

" Enable filetype plugins
filetype on
filetype plugin on
filetype indent on

" File types
au BufRead,BufNewFile *.ejs set filetype=html
au BufRead,BufNewFile *.handlebars set filetype=html
au BufRead,BufNewFile *.css set filetype=scss.css
au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.service set filetype=yaml
au BufRead,BufNewFile *.js set filetype=javascript

set ttyfast                                 " send more characters for faster redraws
set mouse=a                                 " enable mouse use in all modes
set lazyredraw                              " Don't redraw while executing macros
set autoread                                " update when a file is changed from the outside
set showcmd                                 " Show incomplete cmds down the bottom
set hidden                                  " A buffer becomes hidden when it is abandoned
set ignorecase smartcase hlsearch incsearch " Search settings
set nobackup nowb noswapfile                " No vim backup files

" ============================================================================
" UI
" ============================================================================

set t_Co=256
syntax enable

" Background color
hi Normal ctermbg=none
highlight NonText ctermbg=none

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
endif

" set line break to 80
set textwidth=80 colorcolumn=80 lbr tw=80
set number numberwidth=2 relativenumber

" Highlight current line & column
" au WinLeave * set nocursorline
" au WinEnter * set cursorline
set cursorline
set ruler laststatus=2 title " Sets ruler show current line

" vim code folding
" set foldmethod=syntax foldlevelstart=99

set wildmenu                   " Turn on the WiLd menu
set wildmode=list:longest,full
set wildignorecase
set wildignore=*.o,*~,*.pyc    " Ignore compiled files

set cmdheight=1 " Height of the command bar
set magic       " For regular expressions turn magic on
set showmatch   " Show matching brackets when text indicator is over them
set mat=2       " How many tenths of a second to blink when matching brackets

" Resize
au VimResized * exe "normal! \<c-w>="

" ============================================================================
" BEHAVIOR
" ============================================================================

set ffs=unix,dos,mac                       " Use Unix as the standard file type
autocmd BufWritePre * :%s/\s\+$//e         " Clear trailing spaces on save
set noerrorbells novisualbell t_vb= tm=500 " No annoying sound on errors
set tags=./tags,tags;/                     " keep looking up until tags is found

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" ============================================================================
" INDENT
" ============================================================================

" tab space
set shiftwidth=2 tabstop=2 expandtab smarttab
set ai   " Auto indent
set si   " Smart indent
set wrap " Wrap lines

" ============================================================================
" KEYBINDINGS
" ============================================================================

" Set Leader
let mapleader = ","
let g:mapleader = ","

" jk to escape from insert mode
imap jk <Esc>

" save and quit
map <leader>w :w!<cr>
map <leader>q :qa<cr>

" tab buffer shortcuts
nmap <leader>[ :bprevious<CR>
nmap <leader>] :bnext<CR>
nmap <leader>d :bdelete<CR>

" next search will center screen
nnoremap n nzzzv
nnoremap N Nzzzv

" move up and down wrapped lines
nnoremap j gj
nnoremap k gk

" capitol movement keys will do sensible corresponding movement
noremap H ^
noremap L g_
" noremap J <S-}>
" noremap K <S-{>
noremap J 6j
noremap K 6k

" control a/e will go back and front of line
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A

" clear search highlight
nnoremap <leader><space> :nohlsearch<cr>

" open close folds
nnoremap <space> za
nnoremap <space>o zA

" do not allow arrow key movement
map <up> <NOP>
map <down> <NOP>
map <left> <NOP>
map <right> <NOP>

" shortcut to put vim into background, fg to bring back to foreground
nnoremap <leader>z <C-z>

" shortcut for visual mode sort
vnoremap <leader>s :sort

" override behavior when cutting and deleting copying into register
" do not override register when pasting
xnoremap p pgvy


" ============================================================================
" VIM PLUG
" ============================================================================

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>

Plug 'ap/vim-buftabline'
Plug 'chriskempson/base16-vim'

" ----------------------------------------------------------------------------
"  AUTOCOMPLETE
" ----------------------------------------------------------------------------

Plug 'Shougo/neocomplete.vim'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

set completeopt-=preview
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType scss.css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" ----------------------------------------------------------------------------
"  END AUTOCOMPLETE
" ----------------------------------------------------------------------------

Plug 'SirVer/ultisnips'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-bk>"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

Plug 'ctrlpvim/ctrlp.vim'
" ctrlp
let g:ctrlp_custom_ignore='node_modules\|DS_STORE\|bower_components\|.sass-cache\|dist\|plugins\|platform\|public\|production'
" use ag to search, ignores custom ignores, use .agignore
let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
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

" visual indent guides
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_start_level=1
let g:indent_guides_guide_size=2

Plug 'Valloric/MatchTagAlways'
" enable html tag matching in jsx
let g:mta_filetypes={
      \ 'javascript.jsx' : 1,
      \}

" ds{ , delete {
" cs"', change double quotes to single quotes
Plug 'tpope/vim-surround'

" gS to split and gJ to join use on first line
Plug 'AndrewRadev/splitjoin.vim'

" align based on delimiter
Plug 'godlygeek/tabular', { 'on': ['Tabularize'] }
vmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>af :Tabularize /from<CR>

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

" ctrl + // to toggle comment
Plug 'tomtom/tcomment_vim'

" show diff in own split when editing a COMMIT_EDITMSG
Plug 'rhysd/committia.vim'

Plug 'airblade/vim-gitgutter'
set updatetime=2000
let g:gitgutter_realtime=1
let g:gitgutter_sign_column_always=1

Plug 'tpope/vim-fugitive'
" shortcut Gblame
nnoremap <leader>g :Gblame<cr>

Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=1
au FileType mail let b:delimitMate_expand_cr = 1

Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-Z>'

Plug 'mustache/vim-mustache-handlebars'
Plug 'othree/html5.vim'

Plug 'elzr/vim-json'

Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'

Plug 'othree/javascript-libraries-syntax.vim'
let g:used_javascript_libs = 'react,jasmine,chai'

Plug 'heavenshell/vim-jsdoc'
Plug 'moll/vim-node'
" TODO fix this
" Plug 'othree/jspc.vim'

Plug 'JulesWang/css.vim'
      \| Plug 'hail2u/vim-css3-syntax'
      \| Plug 'cakebaker/scss-syntax.vim', { 'for': ['scss'] }

Plug 'othree/csscomplete.vim'

Plug 'hashivim/vim-terraform'
Plug 'Glench/Vim-Jinja2-Syntax'

call plug#end()

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-tomorrow-night
