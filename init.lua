local set = vim.opt
local let = vim.g

let.do_filetype_lua = 1
vim.filetype.add({
    extension = {
        repos = 'yaml',
        rviz = 'yaml',
        scad = 'openscad',
        typ = 'typst',
        eta = 'html',
        gnuplot = 'gnuplot',
        plt = 'gnuplot',
        hlsl = 'hlsl',
        xaml = 'xml',
    },
})

let.mapleader = ' '
let.maplocalleader = ','

-- let.border = 'rounded'
let.border = nil

-- set.mouse = nil
set.number = true
set.relativenumber = false
set.tabstop = 4
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

set.updatetime = 300
set.clipboard = 'unnamedplus'

require('window-management')
require('wrap')
require('fix_comment_strings')
require('terminal')
require('termdebug')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins', {
    ui = { border = vim.g.border },
    change_detection = { notify = false },
})
