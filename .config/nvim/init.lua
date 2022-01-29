local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap


require('packer').startup(function()
  use 'wbthomason/packer.nvim'  -- Package manager itself
  
  -- API
  use 'nvim-lua/plenary.nvim' -- i forgor :skull:
  use 'kyazdani42/nvim-web-devicons' -- Devicons support
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
  use 'nvim-lua/lsp_extensions.nvim' -- LSP extensions
  
  -- Navigation
  use 'kyazdani42/nvim-tree.lua' -- File explorer
  use 'nvim-telescope/telescope.nvim' -- Fuzzy engine
  use 'nvim-telescope/telescope-ui-select.nvim' -- Telescope UI select
  use 'folke/trouble.nvim' -- Better UI for diagnostics, quickfix, references, etc

  -- Coding QoL
  use 'lewis6991/gitsigns.nvim' -- Git integration for buffers
  use 'lukas-reineke/indent-blankline.nvim' -- Indent lines
  use 'p00f/nvim-ts-rainbow' -- Rainbow brackets
  use 'windwp/nvim-autopairs' -- Autopair
  use 'ray-x/lsp_signature.nvim' -- Better LSP signatures
  use 'norcalli/nvim-colorizer.lua' -- Colors highlighter
  use 'kosayoda/nvim-lightbulb' -- Le bulb
  use 'weilbith/nvim-code-action-menu' -- Code action menu
  use 'fedepujol/move.nvim' -- Move lines or blocks
  use 'b3nj5m1n/kommentary' -- Comment lines easily

  -- Language specific
  use 'dart-lang/dart-vim-plugin' -- Dart syntax highlight etc
  
  -- Appearance
  --use 'Mofiqul/dracula.nvim' -- Dracula theme
  use 'dracula/vim'
  use 'noib3/nvim-cokeline' -- Bufferline
  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'tami5/lspsaga.nvim'

  -- Other
  use 'andweeb/presence.nvim' -- Discord presence
end)

cmd('PackerInstall')

require('nvim-tree').setup{
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
}
require('gitsigns').setup()
require('nvim-autopairs').setup()
require('trouble').setup()
require('lspsaga').setup {
    code_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
    },
    rename_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
    },
    rename_prompt_prefix = ">",
}
require('presence'):setup {
  main_image = "file",
}
require "lsp_signature".setup({
 vbind = true,
   handler_opts = {
    border = "rounded"
  }
})
require('lsp_signature').on_attach()
require('telescope').setup()
require('telescope').load_extension('ui-select')
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}

local get_hex = require('cokeline/utils').get_hex

require('cokeline').setup({
    mappings = {
      cycle_prev_next = true,
    },
    default_hl = {
        focused = {
            bg = "none"
        },
        unfocused = {
            fg = get_hex("Comment", "fg"),
            bg = "none"
        }
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
      hl = {fg = function(buffer) return buffer.devicon.color end},
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      hl = {fg = get_hex('Comment', 'fg'), style = 'italic'},
    },
    {
      text = function(buffer) return buffer.filename end,
      hl = {
        fg = function(buffer) return buffer.diagnostics.errors ~= 0 and '#ff5555' or buffer.diagnostics.warnings ~= 0 and '#f1fa8c' end,
        style = function(buffer) return buffer.is_focused and 'bold' or nil end
      },
    },
    {
      text = function(buffer) return buffer.is_modified and ' •' or '' end,
    },
    {text=' '}
  },
})
cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
require('lualine').setup {
  options = {
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {'diagnostics'},
    lualine_y = {'filetype'},
    lualine_z = {'progress', 'location'}
  },
  extensions = {'nvim-tree', 'quickfix'}
}

opt.termguicolors = true

require('colorizer').setup()
require("nvim-treesitter.configs").setup {
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
    colors = {
      "#f8f8f2",
      "#bd93f9",
      "#ff5555",
      "#f1fa8c",
      "#50fa7b",
      "#ffb86c",
      "#8be9fd",
    },
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


local servers = {'dartls', 'gopls', 'pylsp', 'clangd'}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {capatibilities=capatibilities, flags={debounce_text_changes = 150}}
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
---

cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()")

map('n', '<A-j>', ":MoveLine(1)<CR>", { noremap = true, silent = true })
map('n', '<A-k>', ":MoveLine(-1)<CR>", { noremap = true, silent = true })
map('v', '<A-j>', ":MoveBlock(1)<CR>", { noremap = true, silent = true })
map('v', '<A-k>', ":MoveBlock(-1)<CR>", { noremap = true, silent = true })
map('n', '<A-l>', ":MoveHChar(1)<CR>", { noremap = true, silent = true })
map('n', '<A-h>', ":MoveHChar(-1)<CR>", { noremap = true, silent = true })
map('v', '<A-l>', ":MoveHBlock(1)<CR>", { noremap = true, silent = true })
map('v', '<A-h>', ":MoveHBlock(-1)<CR>", { noremap = true, silent = true })

map("n", "<Space><Space>", "<cmd>Telescope find_files<CR>", { noremap = true })
map("n", "<Space>q", "<cmd>Telescope quickfix<CR>", { noremap = true })
map("n", "<Space>d", "<cmd>Telescope diagnostics<CR>", { noremap = true })

map('n', "ge", ":NvimTreeToggle<CR>", { noremap = true })

map('n', "<leader>h", "<cmd>Lspsaga hover_doc<CR>", { silent = true, noremap = true })
map('n', "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, noremap = true })
map('n', "<leader>a", "<cmd>Lspsaga code_action<CR>", { silent = true, noremap = true })
map('n', "<leader>r", "<cmd>Lspsaga rename<CR>", { silent = true, noremap = true })
map('n', '.', '<leader>a', {})
map('n', ',', '<leader>h', {})
map('n', "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
map('n', "gD", "<cmd>Telescope lsp_declaration<CR>", { noremap = true })
map('n', "gR", "<cmd>Telescope lsp_references<CR>", { noremap = true })
map('n', "gi", "<cmd>Telescope lsp_implementations<CR>", { noremap = true })
map("n", "<C-k>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>", {})
map("n", "<C-j>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>", {})

map('', 'x', '"_x', { noremap = true })
map('', 'X', '"_x', { noremap = true })
map('', '<Del>', '"_x', { noremap = true })

map('', 'j', 'gj', { noremap = true })
map('', 'j', 'gj', { noremap = true })
map('', '<Up>', 'gk', { noremap = true })
map('', '<Down>', 'gj', { noremap = true })
map('i', '<Up>', '<C-o>gk', { noremap = true })
map('i', '<Down>', '<C-o>gj', { noremap = true })

cmd('colorscheme dracula')

g.dart_style_guide = 2

g.code_action_menu_show_details = false
opt.ts = 4
opt.sw = 4
opt.updatetime = 50
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
