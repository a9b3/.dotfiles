"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" for pathogen
execute pathogen#infect()

" for vimdiff
set noreadonly

" Sets ruler show current line
set ruler laststatus=2 number title nohlsearch

" Sets how many lines of history VIM has to remember
set history=1000

" Enable filetype plugins
filetype on
filetype plugin on
filetype indent on

" File type
au BufNewFile,BufRead *.ejs set filetype=html

" Clear trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Set to auto read when a file is changed from the outside
set autoread

" Show incomplete cmds down the bottom
set showcmd

" use system clipboard, vim must have +clipboard
set clipboard=unnamed

" keep looking up until tags is found
set tags=./tags,tags;/

" vim code folding
" set foldenable
" start with most things not folded
" set foldlevelstart=10
" set foldnestmax=10
" set foldmethod=syntax

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight current line & column
au WinLeave * set nocursorline
au WinEnter * set cursorline
set cursorline

" Set lines to the cursor - when moving vertically using j/k
" keeps cursor in the middle of the page
set so=30

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

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

set textwidth=80
set colorcolumn=80

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

" tab space
set shiftwidth=4
set tabstop=4

" set line break to 80
set lbr
set tw=80

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

" vim-jsx enable for .js files as well
let g:jsx_ext_required = 0

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

let g:used_javascript_libs = 'underscore,angularjs,angularui,angularuirouter,react,flux,jquery'

let g:user_emmet_leader_key='<C-Z>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set Leader
let mapleader = ","
let g:mapleader = ","

" jk to escape from insert mode
imap jk <Esc>

" save and quit
map <leader>w :w!<cr>
map <leader>q :q<cr>

" save session
nnoremap <leader>s :mksession<cr>

" tab shortcuts
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
noremap J <S-}>
noremap K <S-{>

" control a/e will go back and front of line
nmap <C-a> ^
nmap <C-e> g_
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A

" quit edit vimrc
map <leader>ve :vsp $MYVIMRC<cr>
map <leader>vs :source $MYVIMRC<cr>

" clear search highlight
nnoremap <leader><space> :nohlsearch<cr>

" open close folds
nnoremap <space> za

" set foldmethod=syntax
" autocmd Syntax c,cpp,vim,xml,html,xhtml,java setlocal foldmethod=syntax
" autocmd Syntax c,cpp,vim,xml,html,xhtml,perl,java normal zR

" do not allow arrow key movement
map <up> <NOP>
map <down> <NOP>
map <left> <NOP>
map <right> <NOP>

" shortcut to silver searcher
nnoremap <leader>a :Ag

" shortcut Gblame
nnoremap <leader>g :Gblame<cr>

" shortcut to put vim into background, fg to bring back to foreground
nnoremap <leader>z <C-z>
