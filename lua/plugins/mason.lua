vim.g.use_mason = not vim.g.is_nixos

return {
    {
        enabled = vim.g.use_mason,
        event = 'VeryLazy',
        'williamboman/mason.nvim',
        opts = {},
    },
}
