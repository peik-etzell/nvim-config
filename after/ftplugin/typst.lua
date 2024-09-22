vim.keymap.set('n', '<leader>z', function()
    vim.fn.system(
        string.format('zathura --fork %s.pdf &', vim.fn.expand('%:p:r'))
    )
end, {})

vim.bo.commentstring = '// %s'
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
