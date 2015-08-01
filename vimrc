"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" for pathogen
execute pathogen#infect()

" for vimdiff
set noro

" Sets ruler
set ruler laststatus=2 number title nohlsearch

" Sets how many lines of history VIM has to remember
set history=1000

" Enable filetype plugins
filetype on
filetype plugin on
filetype indent on

" File type
au BufNewFile,BufRead *.ejs set filetype=html

" Set to auto read when a file is changed from the outside
set autoread

" Show incomplete cmds down the bottom
set showcmd    

set tags=./tags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight current line & column
au WinLeave * set nocursorline
au WinEnter * set cursorline
set cursorline 

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7 

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Resize
au VimResized * exe "normal! \<c-w>="

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256

syntax enable

colorscheme Tomorrow-Night-Eighties

hi Normal ctermbg=none
highlight NonText ctermbg=none

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set textwidth=100
set colorcolumn=100

set number
set numberwidth=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocomplete, Snippets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-bk>"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Pathogen, plugin stuff 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nerd tree
map <C-n> :NERDTreeToggle<CR>

" Multiple Cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_quit_key='<Esc>'

" delimitMate
let delimitMate_expand_cr=1

" ctrlp
let g:ctrlp_custom_ignore='node_modules\|DS_STORE\|bower_components\|.sass-cache'

" GitGutter
set updatetime=200
let g:gitgutter_realtime=1
let g:gitgutter_sign_column_always=1

" vim-airline
let g:airline_powerline_fonts=0
let g:airline_theme='simple'

" buffer as tabs on top
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set Leader
let mapleader = ","
let g:mapleader = ","

imap jk <Esc>

map <C-c> <esc>
map - dd
map <leader>w :w!<cr>
map <leader>q :q<cr>

" tab shortcuts
nmap <leader>[ :bprevious<CR>
nmap <leader>] :bnext<CR>
nmap <leader>d :bdelete<CR>

" next search will center screen
nnoremap n nzzzv
nnoremap N Nzzzv

" capitol movement keys will do sensible corresponding movement
noremap H ^
noremap L g_
noremap J <S-}>j
noremap K <S-{><S-{>j

" control a/e will go back and front of line
nmap <C-a> ^
nmap <C-e> g_
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A

map <leader>ve :vsp $MYVIMRC<cr>
map <leader>vs :source $MYVIMRC<cr>
nnoremap <F3> :nohl<cr>

" set foldmethod=syntax
autocmd Syntax c,cpp,vim,xml,html,xhtml,java setlocal foldmethod=syntax
autocmd Syntax c,cpp,vim,xml,html,xhtml,perl,java normal zR

map <up> <NOP>
map <down> <NOP>
map <left> <NOP>
map <right> <NOP>
