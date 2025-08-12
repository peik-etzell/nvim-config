return {
    {
        enabled = not vim.g.is_nixos,
        event = 'VeryLazy',
        'williamboman/mason.nvim',
        opts = {
            ui = {
                border = vim.g.border,
            },
        },
    },
}
