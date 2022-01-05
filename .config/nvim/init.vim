" -------------------------------------------------- "
" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
" Config made by arslee (arslee.dev)                 "
" -------------------------------------------------- "

set nocompatible

" Autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif



" Setup plugins
filetype plugin indent on
call plug#begin('~/.config/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'casonadams/vim-dim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
" Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
Plug 'junegunn/fzf.vim' " needed for previews
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'habamax/vim-godot'

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
      \'coc-explorer',
      \'coc-json',
      \'coc-git',
      \'coc-discord-rpc',
      \'coc-pairs',
      \'coc-snippets',
      \'coc-docker',
\]

" Bind gr to rename
:nmap <silent><leader>r <Plug>(coc-rename)

" Bind the dot key to show suggestions
nnoremap <silent> . :CocAction<CR>

" Bind the comma key to show documentation
nnoremap <silent> , :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Bind gd to go to definition
" GoTo code navigation.
nmap <silent> gd :call CocAction('jumpDefinition', 'tab drop') <CR>
nmap <silent> gy :call CocAction('jumpTypeDefinition', 'tab drop') <CR>
nmap <silent> gi :call CocAction('jumpImplementation', 'tab drop') <CR>
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> ? :call CocAction('diagnosticInfo') <CR>

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'


" .............................................................................
" coc-explorer
" .............................................................................

" Bind ge to open the coc-explorer
nnoremap <silent>ge :CocCommand explorer<CR>


" .............................................................................
" vim-airline/vim-airline
" .............................................................................

"let g:airline_theme='dracula'
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



" .............................................................................
" luochen1990/rainbow
" .............................................................................

let g:rainbow_active = 1


" Enable TrueColor support
if (has("termguicolors"))
  set termguicolors
endif

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
nmap <silent> <space><space> :Files<CR>
nmap <silent> <space>g :GFiles<CR>
nmap <silent> <space>s :GFiles?<CR>
nmap <silent> <space>d :CocFzfList diagnostics<CR>
nmap <silent> <space>c :CocFzfList commits<CR>
nmap <silent> <space>l :CocFzfList<CR>


function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    vsp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    vsp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

nnoremap <silent>mt :call MoveToNextTab()<CR>
nnoremap <silent>mT :call MoveToPrevTab()<CR>

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Give more space for displaying messages
set cmdheight=2

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Automatically strip trailing spaces on buffer write
autocmd BufWritePre * :%s/\s\+$//e

" Enable syntax highlight
syntax on

" Enable mouse support
set mouse=a

" Enable line numbers
set number

" disable this fucking shit
set nobackup
set nowritebackup

" Auto move cursor
set whichwrap+=<,>,[,]

set splitright
set nowrap

set smarttab
set expandtab
set smartindent
filetype plugin indent on

" Enable Dracula colorscheme
colorscheme dracula

function! DartSettings() abort
    set tabstop=2 shiftwidth=2
endfunction
augroup dart | au!
    au FileType dart call DartSettings()
augroup end
