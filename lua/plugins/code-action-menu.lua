return {
    'aznhe21/actions-preview.nvim',
    config = function()
        vim.keymap.set(
            { 'v', 'n' },
            '<tab>',
            require('actions-preview').code_actions
            -- { silent = true }
        )
    end,
}
