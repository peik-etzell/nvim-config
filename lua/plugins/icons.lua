vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' })

require('nvim-web-devicons').setup({
    color_icons = true,
    override_by_extension = {
        ['tsv'] = {
            icon = '',
            color = '#f08080',
            name = 'tsv',
        },
        ['mzn'] = {
            icon = '',
            color = '#00a2ff',
            name = 'minizinc',
        },
        ['dzn'] = {
            icon = '',
            color = '#00a2ff',
            name = 'minizinc',
        },
    },
})
