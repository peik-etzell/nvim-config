return {
    {
        'aznhe21/actions-preview.nvim',
        lazy = false,
        config = function()
            vim.keymap.set(
                { 'v', 'n' },
                '<C-.>',
                require('actions-preview').code_actions,
                { silent = true }
            )
        end,
    },
    {
        'weilbith/nvim-code-action-menu',
        lazy = false,
        enabled = false,
        config = function()
            vim.g.code_action_menu_window_border = vim.g.border
            vim.keymap.set(
                'n',
                '<C-.>',
                require('code_action_menu').open_code_action_menu,
                { silent = true }
            )
        end,
    },
}
