return {
    {
        enable = not vim.fn.filereadable('/etc/NIXOS'),
        event = 'VeryLazy',
        "williamboman/mason.nvim",
        opts = {},
    }
}
