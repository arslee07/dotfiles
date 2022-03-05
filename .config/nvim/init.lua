local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap

local kind_icons = { Text = "", Method = "", Function = "", Constructor = "", Field = "", Variable = "", Class = "ﴯ", Interface = "", Module = "", Property = "ﰠ", Unit = "", Value = "", Enum = "", Keyword = "", Snippet = "", Color = "", File = "", Reference = "", Folder = "", EnumMember = "", Constant = "", Struct = "", Event = "", Operator = "", TypeParameter = "" }

require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager itself

    -- API
    use 'nvim-lua/plenary.nvim' -- i forgor :skull:
    use 'kyazdani42/nvim-web-devicons' -- Devicons support
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Treesitter support

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

    -- Coding QoL
    use 'lewis6991/gitsigns.nvim' -- Git integration for buffers
    use 'lukas-reineke/indent-blankline.nvim' -- Indent lines
    use 'p00f/nvim-ts-rainbow' -- Rainbow brackets
    use 'windwp/nvim-autopairs' -- Autopair
    use 'norcalli/nvim-colorizer.lua' -- Colors highlighter
    use 'kosayoda/nvim-lightbulb' -- Le bulb
    use 'weilbith/nvim-code-action-menu' -- Code action menu
    use 'fedepujol/move.nvim' -- Move lines or blocks
    use 'b3nj5m1n/kommentary' -- Comment lines easily
    use 'famiu/bufdelete.nvim'

    -- Language specific
    use 'dart-lang/dart-vim-plugin' -- Dart syntax highlight etc
    use 'Nash0x7E2/awesome-flutter-snippets' -- Flutter snppets

    -- Appearance
    use 'dracula/vim'
    use 'ellisonleao/gruvbox.nvim' -- Gruvbox theme
    use 'akinsho/bufferline.nvim' -- Bufferline
    use 'nvim-lualine/lualine.nvim' -- Statusline

    -- Other
    use 'andweeb/presence.nvim' -- Discord presence
    use 'williamboman/nvim-lsp-installer' -- Automatic LSP installer

end)

cmd('PackerInstall')

require('nvim-tree').setup {
    diagnostics = {
        enable = true,
    },
    hijack_cursor = true,
    disable_netrw = true
}
require('gitsigns').setup()
require('nvim-autopairs').setup()
require('presence'):setup {
    main_image = "file",
}
require('telescope').setup {}
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}


cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

require('lualine').setup {
    options = {
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = { 'filename' },
        lualine_x = { 'diagnostics' },
        lualine_y = { 'filetype' },
        lualine_z = { 'progress', 'location' }
    },
    extensions = { 'nvim-tree', 'quickfix' }
}

opt.termguicolors = true
require("bufferline").setup {
    options = {
        offsets = {
        {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }
        },
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " "
                or (e == "warning" and " " or "")
                s = s .. n .. sym
            end
            return s
        end
    }
}

require('colorizer').setup()
require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<CR>",
            node_decremental = "<BS>",
        },
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
        colors = {
            "#FB4934",
            "#B8BB26",
            "#FABD2F",
            "#83A598",
            "#D3869B",
            "#8EC07C",
            "#FE8019"
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

local cmp = require 'cmp'
cmp.event:on( 'confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({  map_char = { tex = '' } }))
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, { "i", "s", "c", }),

        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    }, {
        { name = 'buffer' },
        }),
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                vsnip = "[VSnip]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
        end
    }
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
local configs = require 'lspconfig.configs'
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true


local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
---

-- cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()")

map('n', '<A-j>', ":MoveLine(1)<CR>", { noremap = true, silent = true })
map('n', '<A-k>', ":MoveLine(-1)<CR>", { noremap = true, silent = true })
map('v', '<A-j>', ":MoveBlock(1)<CR>", { noremap = true, silent = true })
map('v', '<A-k>', ":MoveBlock(-1)<CR>", { noremap = true, silent = true })
map('n', '<A-l>', ":MoveHChar(1)<CR>", { noremap = true, silent = true })
map('n', '<A-h>', ":MoveHChar(-1)<CR>", { noremap = true, silent = true })
map('v', '<A-l>', ":MoveHBlock(1)<CR>", { noremap = true, silent = true })
map('v', '<A-h>', ":MoveHBlock(-1)<CR>", { noremap = true, silent = true })

map("n", "<Space><Space>", "<cmd>Telescope<CR>", { noremap = true })
map("n", "<Space>f", "<cmd>Telescope find_files<CR>", { noremap = true })
map("n", "<Space>q", "<cmd>Telescope quickfix<CR>", { noremap = true })
map("n", "<Space>d", "<cmd>Telescope diagnostics<CR>", { noremap = true })

map('n', "ge", ":NvimTreeToggle<CR>", { noremap = true })

map('n', "<leader>h", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, noremap = true })
map('n', "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true, noremap = true })
map('n', "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true, noremap = true })
map('n', "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true, noremap = true })
map('n', "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true, noremap = true })
map('n', "<leader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", { silent = true, noremap = true })
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


opt.termguicolors = true
vim.o.background = "dark"
cmd('colorscheme gruvbox')

g.dart_style_guide = 2

opt.ts = 4
opt.sw = 4
opt.updatetime = 50
opt.smarttab = true
opt.expandtab = true
opt.smartindent = true
opt.completeopt = { 'menu', 'menuone', 'noselect' }
cmd('filetype plugin on')
cmd('filetype plugin indent on')
opt.sessionoptions:append { "tabpages", "globals" }
opt.whichwrap:append "<>[]hl"
opt.number = true
opt.mouse = "a"
opt.backup = false
opt.writebackup = false
opt.cursorline = true
opt.cursorline = true
