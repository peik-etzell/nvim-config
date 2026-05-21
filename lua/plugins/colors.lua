vim.pack.add({
    'https://github.com/yorickpeterse/vim-paper',
    'https://github.com/catppuccin/nvim',
    'https://github.com/f4z3r/gruvbox-material.nvim',
})

require('catppuccin').setup()
require('gruvbox-material').setup()

local default = 'habamax'
local store_path = vim.fn.stdpath('state') .. '/colorscheme'

local function load()
    local f = io.open(store_path, 'r')
    if not f then
        vim.cmd.colorscheme(default)
        return
    end

    local colorscheme = f:read('*l')
    local background = f:read('*l')
    f:close()

    if not colorscheme or colorscheme == '' then
        vim.cmd.colorscheme(default)
        return
    end

    if background and (background == 'light' or background == 'dark') then
        vim.o.background = background
    end

    local ok = pcall(vim.cmd.colorscheme, colorscheme)
    if not ok then
        vim.cmd.colorscheme(default)
    end
end

local function save()
    local f = io.open(store_path, 'w')
    if f then
        f:write(vim.g.colors_name .. '\n' .. vim.o.background)
        f:close()
    end
end

load()

vim.api.nvim_create_autocmd('ColorScheme', { callback = save })
