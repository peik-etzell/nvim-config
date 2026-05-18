vim.api.nvim_create_autocmd('BufEnter', {
    pattern = {
        '*.c',
        '*.cpp',
        '*.cc',
        '*.zig',
    },
    callback = function()
        vim.cmd.packadd('termdebug')
    end,
})

vim.keymap.set('n', '<F5>', vim.cmd.Continue, { silent = true })
vim.keymap.set('n', '<F9>', vim.cmd.Break, { silent = true })
vim.keymap.set('n', '<F10>', vim.cmd.Over, { silent = true })
vim.keymap.set('n', '<F11>', vim.cmd.Step, { silent = true })
