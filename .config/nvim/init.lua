local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

require('packer').startup(function()
  use 'wbthomason/packer.nvim'  -- Package manager
  
  -- API
  use 'nvim-lua/plenary.nvim' -- i forgor :skull:
  use 'kyazdani42/nvim-web-devicons' -- Devicons support
  use 'b0o/mapx.nvim' -- Better keymapping util
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  -- Treesitter support
  
  -- Completions
  use 'neovim/nvim-lspconfig' -- Preconfigured LSPs
  use 'hrsh7th/nvim-cmp' -- Completions engine
  use 'hrsh7th/cmp-nvim-lsp' --Neovim builtin LSP support for cmp
  use 'hrsh7th/cmp-vsnip' -- VSnip support for cmp
  use 'hrsh7th/cmp-buffer' -- ...buffers
  use 'hrsh7th/cmp-path' -- ...paths
  use 'hrsh7th/cmp-cmdline' -- ...commands
  use 'hrsh7th/vim-vsnip' -- Snippets engine
  
  -- Navigation
  use 'kyazdani42/nvim-tree.lua' -- File explorer
  use 'cloudhead/neovim-fuzzy' -- Fuzzy file search (TODO: replace with telescope?)

  -- Coding QoL
  use 'lewis6991/gitsigns.nvim' -- Git integration for buffers
  use 'lukas-reineke/indent-blankline.nvim' -- Indent lines
  use 'p00f/nvim-ts-rainbow' -- Rainbow brackets
  use 'windwp/nvim-autopairs' -- Autopair

  -- Language specific
  use 'dart-lang/dart-vim-plugin' -- Dart syntax highlight etc
  
  -- Appearance
  use 'Mofiqul/dracula.nvim' -- Dracula theme
  use 'noib3/nvim-cokeline' -- Bufferline
  use 'nvim-lualine/lualine.nvim' -- Statusline

  -- Other
  use 'andweeb/presence.nvim' -- Discord presence
end)

cmd('PackerInstall')

require('nvim-autopairs').setup()
require('mapx').setup{global="force"}
require('nvim-tree').setup()
require('gitsigns').setup()
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
local get_hex = require('cokeline/utils').get_hex

require('cokeline').setup({
  default_hl = {
    focused = {
      fg = get_hex('Normal', 'fg'),
      bg = 'NONE',
    },
    unfocused = {
      fg = get_hex('Comment', 'fg'),
      bg = 'NONE',
    },
  },

  rendering = {
    left_sidebar = {
      filetype = 'NvimTree',
      components = {
        {
          text = '  NvimTree',
          hl = {
            fg = yellow,
            bg = get_hex('NvimTreeNormal', 'bg'),
            style = 'bold'
          }
        },
      }
    },
  },

  components = {
    {
      text = function(buffer) return ' ' .. buffer.devicon.icon end,
      hl = {
        fg = function(buffer) return buffer.devicon.color end,
      },
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      hl = {
        fg = get_hex('Comment', 'fg'),
        style = 'italic',
      },
    },
    {
      text = function(buffer) return buffer.filename .. ' ' end,
    },
  },
})
require('lualine').setup {
  options = {
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  extensions = {'nvim-tree', 'quickfix'}
}

-- LSP SETUP --
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  completion = {
    autocomplete = false,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, 
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {'dartls', 'pylsp', 'gopls'}
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {on_attach=on_attach, capatibilities=capatibilities, flags={debounce_text_changes = 150}}
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

cmd('colorscheme dracula')

g.fuzzy_rootcmds = {{"git", "rev-parse", "--show-toplevel"}}
opt.ts = 4
opt.sw = 4
opt.updatetime = 150
opt.smarttab = true
opt.expandtab = true
opt.smartindent = true
opt.completeopt = {'menu', 'menuone', 'noselect'}
cmd('filetype plugin on')
cmd('filetype plugin indent on')
opt.sessionoptions:append {"tabpages", "globals"}
opt.whichwrap:append "<>[]hl"
opt.number = true
opt.mouse = "a"
opt.backup = false
opt.writebackup = false
opt.cursorline = true

