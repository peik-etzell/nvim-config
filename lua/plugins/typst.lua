return {
    'kaarmu/typst.vim',
    ft = 'typst',
    config = function()
        vim.g.typst_auto_open_quickfix = 0
        -- vim.g.typst_embedded_languages = { 'python', 'bash' }
        -- vim.g.typst_conceal = 1
        -- vim.g.typst_conceal_math = 1
    end,
}
