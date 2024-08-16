return {
    {
        enabled = not vim.g.nixos,
        event = 'VeryLazy',
        'williamboman/mason.nvim',
        opts = {
            ui = {
                border = vim.g.border,
            },
        },
    },
}
