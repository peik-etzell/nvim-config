local set = vim.opt
local let = vim.g

let.do_filetype_lua = 1

let.nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0

vim.filetype.add({
    extension = {
        eta = 'html',
        gnuplot = 'gnuplot',
        hlsl = 'hlsl',
        plt = 'gnuplot',
        repos = 'yaml',
        rviz = 'yaml',
        scad = 'openscad',
        typ = 'typst',
        xaml = 'xml',
        xkb = 'xkb',
    },
})

let.mapleader = ' '
let.maplocalleader = ','

-- let.border = 'rounded'
let.border = nil

-- set.mouse = nil
set.number = true
set.relativenumber = false

set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

set.timeoutlen = 500
set.undofile = true
set.wrap = false
set.list = true
set.title = true
set.cursorline = true
set.scrolloff = 10 -- Scroll offset
set.sidescrolloff = 10
set.colorcolumn = '80'
set.ignorecase = true
set.smartcase = true
set.inccommand = 'split'
set.signcolumn = 'yes:1'

-- folding
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'
set.foldenable = false
set.foldlevel = 99

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ timeout = 500 })
    end,
})

vim.keymap.set({ 'n', 'i', 't' }, '<D-Space>', '', {})
vim.keymap.set('n', '<BS>', '', {})
vim.keymap.set('n', ' ', '', {})

local function set_keymap(lhs, rhs)
    vim.keymap.set('n', lhs, rhs, { silent = true })
end

set_keymap('K', function()
    if require('dap').status() ~= '' then
        require('dapui').eval()
    else
        vim.lsp.buf.hover()
    end
end)
set_keymap('<C-k>', function()
    vim.diagnostic.open_float({ border = vim.g.border })
end)
set_keymap('<leader>s', function()
    vim.lsp.buf.format({
        async = true,
        filter = function(server)
            return server.name ~= 'lua_ls' and server.name ~= 'tsserver'
        end,
    })
end)

set.updatetime = 300
set.clipboard = 'unnamedplus'

require('window-management')
require('wrap')
require('fix_comment_strings')
require('terminal')
require('termdebug')
require('clang-format')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to continue...' },
        }, true, {})
        vim.fn.getchar()
    end
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
    spec = { import = 'plugins' },
    ui = { border = vim.g.border },
    change_detection = { notify = false },
    performance = { rtp = { reset = false } },
})
