local cmd = vim.cmd
local opt = vim.opt

require('packer').startup(function()
  -- Autocompletion
  use 'neovim/nvim-lspconfig'
  
  use 'wbthomason/packer.nvim'  -- Package manager
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  -- Treesitter support
  --use 'kyazdani42/nvim-tree.lua' -- File explorer
  use 'b0o/mapx.nvim' -- Better keymapping util
  use 'windwp/nvim-autopairs' -- Autopair
  use 'dart-lang/dart-vim-plugin' -- Dart syntax highlight etc
  use 'lukas-reineke/indent-blankline.nvim'
  use 'p00f/nvim-ts-rainbow'
  use 'cloudhead/neovim-fuzzy'
  use 'andweeb/presence.nvim' -- Discord presence
  use 'Mofiqul/dracula.nvim' -- Dracula theme
end)

cmd('PackerInstall')

require('nvim-autopairs').setup()
require('mapx').setup{global="force"}
--require('nvim-tree').setup()
vim.g.nvim_tree_icon_padding = ''
vim.g.nvim_tree_icons = {
    default = '',
    symlink = '>',
    git = {
      unstaged =  "",
      staged = "",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted = "",
      ignored = ""
     },
    folder = {
      arrow_open = "",
      arrow_closed = "",
      default = "+",
      open = "-",
      empty = "+",
      empty_open = "-",
      symlink = ">",
      symlink_open = "v",
      }
    }
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
require("nvim-treesitter.configs").setup {
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- LSP SETUP --
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local servers = {'dartls', 'pylsp', 'gopls'}
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {on_attach=on_attach, flags={debounce_text_changes = 150}}
end
---

cmd("autocmd CursorHold * lua vim.diagnostic.open_float()")
cmd("autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()")
cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()")

nnoremap("<Space><Space>", "<cmd>FuzzyOpen<CR>")

nnoremap("ge", ":NvimTreeToggle<CR>")

nnoremap(",", "<cmd>lua vim.lsp.buf.hover()<CR>")
nnoremap(".", "<cmd>lua vim.lsp.buf.code_action()<CR>")

noremap('x', '"_x')
noremap('X', '"_x')
noremap('<Del>', '"_x')

noremap('j', 'gj')
noremap('j', 'gj')
noremap('<Up>', 'gk')
noremap('<Down>', 'gj')
inoremap('<Up>', '<C-o>gk')
inoremap('<Down>', '<C-o>gj')

cmd [[function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction]]

inoremap('<Tab>', '<C-r>=InsertTabWrapper()<CR>')

-- Statusline setup
-- TODO: rewrite to lua
cmd[[
set nocompatible
set laststatus=2
set statusline=

" Left side
set statusline+=%1*
set statusline+=%{StatuslineMode()}
set statusline+=%9*
set statusline+=\ 
set statusline+=%f " Filename
set statusline+=\ 
set statusline+=%m " Is modified
set statusline+=\ 
set statusline+=%r " Is readonly

set statusline+=%=

set statusline+=%1*
set statusline+=%P " File percentage
set statusline+=\ 
set statusline+=%l " Current line
set statusline+=:
set statusline+=%c " Current column

hi User1 ctermbg=darkgrey ctermfg=white
hi User9 ctermbg=black ctermfg=white

function! StatuslineMode()
  let l:mode=mode()
  if l:mode==#"n"
    return "NORMAL"
  elseif l:mode==?"v"
    return "VISUAL"
  elseif l:mode==#"i"
    return "INSERT"
  elseif l:mode==#"R"
    return "REPLACE"
  elseif l:mode==?"s"
    return "SELECT"
  elseif l:mode==#"t"
    return "TERMINAL"
  elseif l:mode==#"c"
    return "COMMAND"
  elseif l:mode==#"!"
    return "SHELL"
  endif
endfunction
]]

cmd[[
nnoremap <silent> ge :Lexplore<cr>
vnoremap <silent> ge :Lexplore<cr>

let g:netrw_altv=1
let g:netrw_banner=0
let g:netrw_winsize=30
let g:netrw_liststyle=3
let g:netrw_browse_split=0
let g:netrw_list_hide='.*\.git/$,'.netrw_gitignore#Hide()
]]

vim.g.fuzzy_rootcmds = {{"git", "rev-parse", "--show-toplevel"}}
opt.updatetime = 150
opt.smarttab = true
opt.expandtab = true
opt.smartindent = true
opt.completeopt = {'menu', 'menuone', 'noselect'}
cmd('filetype plugin indent on')
opt.sessionoptions:append {"tabpages", "globals"}
opt.whichwrap:append "<>[]hl"
opt.number = true
opt.mouse = "a"
opt.backup = false
opt.writebackup = false
opt.cursorline = true

cmd('colorscheme dracula')
