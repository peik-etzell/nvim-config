vim.pack.add({
    'https://github.com/Pocco81/auto-save.nvim',
})

require('auto-save').setup({
    execution_message = {
        message = function()
            return ''
        end,
    },
})
