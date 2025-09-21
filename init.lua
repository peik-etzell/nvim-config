local set = vim.opt

vim.g.do_filetype_lua = 1

local sysname = vim.uv.os_uname().sysname
vim.g.is_linux = sysname == 'Linux'
vim.g.is_nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0
vim.g.is_wsl = vim.g.is_linux
    and vim.uv.os_uname().release:lower():find('microsoft')
vim.g.is_windows = sysname == 'Windows_NT'

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

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.winborder = 'rounded'

-- set.mouse = nil
set.mouse = 'nv'
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
set.splitbelow = true

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

local function unmap(modes, lhs)
    vim.keymap.set(modes, lhs, '', {})
end

unmap({ 'n', 'i', 't' }, '<D-Space>')
unmap('n', '<BS>')
unmap({ 'n', 'v' }, ' ')
unmap({ 'n', 'v' }, '<CR>')
unmap({ 'n', 'v' }, '<Del>')

local function nmap(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

nmap('<C-k>', vim.diagnostic.open_float, 'Open diagnostics')
nmap('<leader>s', function()
    vim.lsp.buf.format({
        async = true,
        filter = function(server)
            return server.name ~= 'lua_ls' and server.name ~= 'tsserver'
        end,
    })
end, 'Format file')

nmap('<ESC>', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == 'win' then
            vim.api.nvim_win_close(win, false)
        end
    end
end, 'Close hover')

set.updatetime = 300
set.clipboard = 'unnamedplus'

if vim.g.is_wsl then
    local function sh(cmd)
        return "/bin/sh -c '" .. cmd .. "'"
    end
    vim.g.clipboard = {
        name = 'wl-clipboard (wsl)',
        copy = {
            ['+'] = 'wl-copy --foreground --type text/plain',
            ['*'] = 'wl-copy --foreground --primary --type text/plain',
        },
        paste = {
            ['+'] = function()
                return vim.fn.systemlist(
                    sh('wl-paste --no-newline | sed -e "s/\r$//"'),
                    { '' },
                    1
                ) -- '1' keeps empty lines
            end,
            ['*'] = function()
                return vim.fn.systemlist(
                    sh('wl-paste --primary --no-newline | sed -e "s/\r$//"'),
                    { '' },
                    1
                )
            end,
        },
        cache_enabled = true,
    }
end

require('window-management')
require('wrap')
require('fix_comment_strings')
require('terminal')
-- require('termdebug')
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
    ui = { border = vim.o.winborder },
    change_detection = { notify = false },
    performance = { rtp = { reset = false } },
})
