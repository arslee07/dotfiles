" -------------------------------------------------- "
" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
" Config made by arslee (arslee.dev)                 "
"                                                    "
" Main principles:                                   "
" 1. Leader key for navigation                       "
" 2. i forgor                                        "
" Use it as you want, I don't forbid anything :)     "
" -------------------------------------------------- "



" Autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif



" Setup plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'dart-lang/dart-vim-plugin'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'luochen1990/rainbow'

" Autoinstall missing plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
call plug#end()



" .............................................................................
" neoclide/coc.nvim
" .............................................................................

" Autoinstall Coc plugins
let g:coc_global_extensions = [
      \'coc-markdownlint',
      \'coc-highlight',
      \'coc-pyright',
      \'coc-explorer',
      \'coc-flutter',
      \'coc-json',
      \'coc-git',
\]

" Bind the F2 key to rename
:nmap <F2> <Plug>(coc-rename)

" Bind the dot key to show suggestions
:nnoremap <silent> . :CocAction<CR>

" Bind the comma key to show documentation
:nnoremap <silent> , :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Bind the F12 key to go to definition
nmap <F12> <Plug>(coc-definition)

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()



" .............................................................................
" coc-explorer
" .............................................................................

" Bind Ctrl+E to open the coc-explorer
" i love floating mode btw
:nnoremap <C-E> :CocCommand explorer --position floating<CR>



" .............................................................................
" vim-airline/vim-airline
" .............................................................................

let g:airline_theme='dracula'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
:let g:airline#extensions#tabline#show_buffers = 0
let g:airline_filetype_overrides = {
    \ 'coc-explorer':  [ 'CoC Explorer', '' ],
    \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
    \ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'],
    \ 'gundo': [ 'Gundo', '' ],
    \ 'help':  [ 'Help', '%f' ],
    \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
    \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
    \ 'startify': [ 'startify', '' ],
    \ 'vim-plug': [ 'Plugins', '' ],
    \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
    \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
    \ 'vaffle' : [ 'Vaffle', '%{b:vaffle.dir}' ],
\ }
"let g:airline_section_x = '%lsp_error_count'


" .............................................................................
" ntpeters/vim-better-whitespace
" .............................................................................

let g:strip_whitespace_confirm=0
let g:strip_whitelines_at_eof=1
let g:strip_whitespace_on_save=1



" .............................................................................
" luochen1990/rainbow
" .............................................................................

let g:rainbow_active = 1



" Bind Ctrl+S to save
:nnoremap <C-s> :w<CR>

" Bind Ctrl+Q to quit
:nnoremap <C-q> :q<CR>

" Bind Alt+Arrow key to move line(s) up or down
:nnoremap <A-Up>   :m-2<CR>
:nnoremap <A-Down> :m+1<CR>

" Bind Ctrl+<arrow> to switch between tabs
:nnoremap <leader><Left> :tabprevious<CR>
:nnoremap <leader><Right> :tabnext<CR>

" Convert tabs to 2 spaces
" TODO: make 4 spaces for python, etc.
set tabstop=2 shiftwidth=2 expandtab

" Enable TrueColor support
if (has("termguicolors"))
  set termguicolors
endif

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Enable syntax highlight
syntax on

" Enable mouse support
:set mouse=a

" Enable line numbers
:set number

" disable this fucking shit
set nobackup
set nowritebackup

" Enable Dracula colorscheme
colorscheme dracula
