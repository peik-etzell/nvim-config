return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        enabled = false,
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
}
