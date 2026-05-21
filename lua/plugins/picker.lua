vim.pack.add({ 'https://github.com/nvim-mini/mini.pick' })

local pick = require('mini.pick')
pick.setup()

vim.keymap.set('n', '<leader>f', function()
    pick.builtin.files()
end, { desc = 'Search files' })

vim.keymap.set(
    'n',
    '<leader>g',
    pick.builtin.grep_live,
    { desc = 'Search in files' }
)

local function with_rg_config(f, path)
    local rg_env = 'RIPGREP_CONFIG_PATH'
    local old = vim.uv.os_getenv(rg_env) or ''
    vim.uv.os_setenv(rg_env, path)
    f()
    vim.uv.os_setenv(rg_env, old)
end

local function get_custom_path()
    return vim.uv.fs_stat('.rg') ~= nil and '.rg'
        or vim.fn.stdpath('config') .. '/default.rg'
end

vim.keymap.set('n', '<leader>i', function()
    with_rg_config(function()
        pick.builtin.grep_live({ tool = 'rg' })
    end, get_custom_path())
end, { desc = 'Search in files (custom)' })

vim.keymap.set('n', '<leader>o', function()
    with_rg_config(function()
        pick.builtin.files({ tool = 'rg' })
    end, get_custom_path())
end, { desc = 'Search files (custom)' })
