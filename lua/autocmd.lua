-- highlight yanked region
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ timeout = 500 })
    end,
})

-- resize nvim splits when whole window resizes
vim.api.nvim_create_autocmd({ 'VimResized' }, {
    pattern = { '*' },
    callback = function()
        vim.cmd.wincmd('=')
    end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd('BufRead', {
    group = vim.api.nvim_create_augroup('dotenv_ft', { clear = true }),
    pattern = { '.env', '.env.*' },
    callback = function()
        vim.bo.filetype = 'dosini'
    end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
    group = 'active_cursorline',
    callback = function()
        vim.opt_local.cursorline = false
    end,
})
