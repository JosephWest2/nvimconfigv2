vim.g.mapleader = " "

vim.o.shiftwidth = 4

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.nu = true
vim.o.rnu = true

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]])
vim.keymap.set({ "n", "v" }, "<A-y>", [["*y]])
vim.keymap.set({ "n", "v" }, "<A-p>", [["*p]])
vim.keymap.set({ "n", "v" }, "<A-P>", [["*P]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]])

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-[>", [[<C-\><C-n>]])
vim.keymap.set("t", "C-c", [[<C-\><C-n>]])

vim.keymap.set("n", "-", "<cmd>Oil<CR>")
vim.keymap.set({ "i", "n", "v" }, "<C-c>", "<Esc>")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    { 'nvim-treesitter/nvim-treesitter', lazy = false },
    { 'm4xshen/autoclose.nvim' },
    { 'Pocco81/auto-save.nvim' },
    { 'navarasu/onedark.nvim' },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = { '~/', '~/Downloads', '/', '~/development' }
        }
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
    },

    -- lsp stuff
    {
        "mason-org/mason.nvim",
        config = function()
            require('mason').setup()
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            require('lspconfig').lua_ls.setup {}
            require('lspconfig').clangd.setup {}
        end
    },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'L3MON4D3/LuaSnip',
        dependencies =
        { 'rafamadriz/friendly-snippets' },

    },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'ray-x/lsp_signature.nvim' },
    { 'Civitasv/cmake-tools.nvim' }
}, {})

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-k>'] = cmp.mapping(function()
            local ls = require("luasnip")
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { 'i', 's' }),
        ['<C-j>'] = cmp.mapping(function()
            local ls = require("luasnip")
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { 'i', 's' }),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- LSP Signature
require('lsp_signature').setup({
    extra_trigger_chars = { ' ' },
    hint_enable = false,
    vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', function()
        require('lsp_signature').toggle_float_win()
    end, { silent = true, noremap = true, desc = 'toggle lsp signature window' })
})

require('onedark').setup {
    style = 'cool',
    colors = {
        bg0 = '#21262f',
    },
}
require('onedark').load()

require('autoclose').setup({
    keys = {
        ["("] = { escape = false, close = true, pair = "()" },
        ["["] = { escape = false, close = true, pair = "[]" },
        ["{"] = { escape = false, close = true, pair = "{}" },
        [")"] = { escape = true, close = false, pair = "()" },
        ["]"] = { escape = true, close = false, pair = "[]" },
        ["}"] = { escape = true, close = false, pair = "{}" },
        ['"'] = { escape = true, close = true, pair = '""' },
        ["'"] = { escape = true, close = false, pair = "''" },
        ["`"] = { escape = true, close = true, pair = "``" },
    },
    options = {
        auto_indent = true,
    },
})

vim.keymap.set("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
})

-- Treesitter
require('nvim-treesitter.configs').setup {
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff',
    "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
    { desc = 'Telescope find files' })
--vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


-- Nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.keymap.set('n', '<Leader>t', "<cmd>silent NvimTreeOpen<cr>")
require('nvim-tree').setup {
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', '<Leader>r', api.tree.close)
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        require('nvim-tree.view').View.side = "right"
    end
}

-- BarBar
vim.keymap.set('n', '<A-p>', "<cmd>silent BufferPrevious<CR>")
vim.keymap.set('n', '<A-n>', "<cmd>silent BufferNext<CR>")
vim.keymap.set('n', '<C-p>', "<cmd>BufferPick<CR>")
vim.keymap.set("n", "<A-q>", "<cmd>BufferClose<CR>")

-- auto save
require("auto-save").setup {
    enabled = true,          -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    execution_message = {
        message = function() -- message to print on save
            return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S") .. " filetype: " .. vim.bo.filetype)
        end,
        dim = 0.18,                     -- dim the color of `message`
        cleaning_interval = 1250,       -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    },
    trigger_events = { "InsertLeave" }, -- vim events that trigger auto-save. See :h events
    -- function that determines whether to save the current buffer or not
    -- return true: if buffer is ok to be saved
    -- return false: if it's not ok to be saved
    condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        if
            vim.bo.filetype == "TelescopePrompt" or
            vim.bo.filetype == "oil" then
            return false
        end
        if
            fn.getbufvar(buf, "&modifiable") == 1 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true              -- met condition(s), can save
        end
        return false                 -- can't save
    end,
    write_all_buffers = false,       -- write all buffers when the current one meets `condition`
    debounce_delay = 135,            -- saves the file at most every `debounce_delay` milliseconds
    callbacks = {                    -- functions to be executed at different intervals
        enabling = nil,              -- ran when enabling auto-save
        disabling = nil,             -- ran when disabling auto-save
        before_asserting_save = nil, -- ran before checking `condition`
        before_saving = nil,         -- ran before doing the actual save
        after_saving = nil           -- ran after doing the actual save
    }
}
