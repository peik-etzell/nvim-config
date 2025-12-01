return {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },

        -- optional picker via telescope
        { 'nvim-telescope/telescope.nvim' },
        -- -- optional picker via fzf-lua
        -- {"ibhagwan/fzf-lua"},
        -- -- .. or via snacks
        -- {
        --   "folke/snacks.nvim",
        --   opts = {
        --     terminal = {},
        --   }
        -- }
    },
    event = 'LspAttach',
    opts = {},
    keys = {
        {
            '<tab>',
            function()
                require('tiny-code-action').code_action({})
            end,
        },
    },
}
