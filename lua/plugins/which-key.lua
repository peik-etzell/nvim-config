return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        enabled = false;
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            window = {
                border = vim.g.border,
            },
        },
    },
}
