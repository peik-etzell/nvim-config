return {
    {
        'codethread/qmk.nvim',
        event = 'BufEnter keymap.c',
        config = function()
            local qmk = require('qmk')

            local group = vim.api.nvim_create_augroup('My qmk', {})

            vim.api.nvim_create_autocmd('BufEnter', {
                desc = 'Format cantor keymap',
                group = group,
                pattern = '*cantor/keymaps/*/keymap.c',
                callback = function()
                    print('Qmk init for cantor')
                    qmk.setup({
                        name = 'LAYOUT_split_3x6_3',
                        layout = {
                            'x x x x x x _ _ _ x x x x x x',
                            'x x x x x x _ _ _ x x x x x x',
                            'x x x x x x _ _ _ x x x x x x',
                            '_ _ _ _ x x x _ x x x _ _ _ _',
                        },
                    })
                end,
            })

            vim.api.nvim_create_autocmd('BufEnter', {
                desc = 'Format jj40 keymap',
                group = group,
                pattern = '*jj40/keymaps/*/keymap.c',
                callback = function()
                    print('Qmk init for jj40')
                    qmk.setup({
                        name = 'LAYOUT_ortho_4x12',
                        layout = {
                            'x x x x x x x x x x x x',
                            'x x x x x x x x x x x x',
                            'x x x x x x x x x x x x',
                            'x x x x x x x x x x x x',
                        },
                    })
                end,
            })

            vim.api.nvim_create_autocmd('BufEnter', {
                desc = 'Format bm40 keymap',
                group = group,
                pattern = '*bm40hsrgb/rev2/keymaps/*/keymap.c',
                callback = function()
                    print('Qmk init for bm40')
                    qmk.setup({
                        name = 'LAYOUT_ortho_4x12_1x2uC',
                        layout = {
                            'x x x x x x x x x x x x',
                            'x x x x x x x x x x x x',
                            'x x x x x x x x x x x x',
                            'x x x x x x^x x x x x x',
                        },
                    })
                end,
            })
        end,
    },
}
