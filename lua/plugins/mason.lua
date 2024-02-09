return {
    {
        enabled = vim.fn.filereadable('/etc/NIXOS') == 0,
        event = 'VeryLazy',
        'williamboman/mason.nvim',
        opts = {},
    },
}
