return {
    'kaarmu/typst.vim',
    ft = 'typst',
    config = function()
        -- ### Options
        --
        -- - `g:typst_cmd`:
        --     Specifies the location of the Typst executable.
        --     *Default:* `'typst'`
        -- - `g:typst_pdf_viewer`:
        --     Specifies pdf viewer that `typst watch --open` will use.
        --     *Default:* `''`
        -- - `g:typst_conceal`:
        --     Enable concealment.
        --     *Default:* `0`
        -- - `g:typst_conceal_math`:
        --     Enable concealment for math symbols in math mode (i.e. replaces symbols
        --     with their actual unicode character). **OBS**: this can affect performance,
        --     see issue [#64](https://github.com/kaarmu/typst.vim/issues/64).
        --     *Default:* `g:typst_conceal`
        -- - `g:typst_conceal_emoji`:
        --     Enable concealing emojis, e.g. `#emoji.alien` becomes 👽.
        --     *Default:* `g:typst_conceal`
        -- - `g:typst_auto_close_toc`:
        --     Specifies whether TOC will be automatically closed after using it.
        --     *Default:* `0`
        -- - `g:typst_auto_open_quickfix`:
        --     Specifies whether the quickfix list should automatically open when there are errors from typst.
        --     *Default:* `1`
        -- - `g:typst_embedded_languages`:
        --     A list of languages that will be highlighted in code blocks. Typst is always highlighted.
        --     *Default:* `[]`
        vim.g.typst_auto_open_quickfix = 0
        -- vim.g.typst_embedded_languages = { 'python', 'bash' }
        vim.g.typst_conceal = 1
        vim.g.typst_conceal_math = 0
        vim.g.typst_pdf_viewer = 'zathura'
    end,
}
