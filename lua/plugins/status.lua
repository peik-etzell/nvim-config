vim.pack.add({
    'https://github.com/nvim-mini/mini.statusline',
})

vim.o.showmode = false
require('mini.statusline').setup()

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'NvimTree' },
    callback = function()
        vim.b.ministatusline_disable = true
    end,
})
