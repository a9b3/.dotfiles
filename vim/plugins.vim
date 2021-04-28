" =================================================================== GENERAL "
" Set vim's project root to the closest ancestor directory containing the
" rooter_patterns
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['.git/']

" ======================================================================== UI "
" Use base16 color theme
Plug 'chriskempson/base16-vim'

" Tab bar for buffers
Plug 'ap/vim-buftabline'

" ================================================================ NAVIGATION "

set rtp+=~/.fzf

" preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>1)

"
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>1)

" Search from project root (.git)
" https://github.com/junegunn/fzf.vim/issues/47#issuecomment-160237795
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()


Plug 'junegunn/fzf.vim'
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

nmap <C-p> :ProjectFiles<cr>
nmap <leader>a :Rg<cr>

Plug 'qpkorr/vim-bufkill'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'PhilRunninger/nerdtree-buffer-ops'
let g:NERDTreeWinSize=30
let g:NERDTreeMinimalUI = 1
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

nmap <C-n> :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" =================================================================== EDITING "

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> <C-a> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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
Plug 'SirVer/ultisnips'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-bk>"
let g:UltiSnipsSnippetsDir= $HOME.'/.vim/UltiSnips/'
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" change surrounding delimiters
Plug 'tpope/vim-surround'

" gS spit single into multi line, gJ to join back into one line
Plug 'AndrewRadev/splitjoin.vim'

Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_start_word_key      = '<C-k>'
let g:multi_cursor_next_key            = '<C-k>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

Plug 'easymotion/vim-easymotion'
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

" C-// to start comment
Plug 'tomtom/tcomment_vim'

" automatic closing of quotes
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=1
au FileType mail let b:delimitMate_expand_cr = 1

" ======================================================================= GIT "
" Jump to github line
" blob view <leader>gh
" blame view <leader>gb
Plug 'ruanyl/vim-gh-line'
let g:gh_user_canonical = 0 " Use branch name when possible

" Disply git status per line on the right guttter
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
" shortcut Gblame
nnoremap <leader>g :Gblame<cr>

Plug 'chrisbra/vim-diff-enhanced'
" Better git commit editing window
Plug 'rhysd/committia.vim'

" ==================================================================== SYNTAX "
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'hashivim/vim-terraform'
let g:terraform_align=1
let g:terraform_fmt_on_save=1
Plug 'fatih/vim-hclfmt'
Plug 'chr4/nginx.vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'othree/html5.vim'
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0
Plug 'mustache/vim-mustache-handlebars'
Plug 'jparise/vim-graphql'
Plug 'jvirtanen/vim-hcl'

" ==================================================================== GOLANG "
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_def_mode = 'godef'

" ====================================================================== RUST "
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1


" ================================================================ JAVASCRIPT "
" html tag insert shortcuts
Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-Z>'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'mxw/vim-jsx'
Plug 'othree/yajs.vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

Plug 'evanleck/vim-svelte', {'branch': 'main'}
let g:svelte_preprocessors = ['typescript']

" ==================================================================== PYTHON "
" syntax highlighting
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

Plug 'LnL7/vim-nix'
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
