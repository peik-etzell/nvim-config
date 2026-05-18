vim.pack.add({
    { src = 'https://github.com/nvim-mini/mini.pairs', version = 'stable' },
})

require('mini.pairs').setup()

return {
    {
        'windwp/nvim-autopairs',
        event = 'VeryLazy',
        config = function()
            local autopairs = require('nvim-autopairs')
            autopairs.setup()
            local rule = require('nvim-autopairs.rule')

            autopairs.add_rules({
                rule('```', '```', { 'typst', 'markdown' }),
                rule('$', '$', { 'typst', 'latex', 'tex' }),
                rule('\\[', '\\]', { 'latex', 'tex' }),
                rule('\\(', '\\)', { 'latex', 'tex' }),
            })
        end,
    },
}
