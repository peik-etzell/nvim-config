return {
    {
        enabled = false,

        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            -- filetypes = {
            --     markdown = true,
            --     help = true,
            -- },
        },
    },
    {
        enabled = false,
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim', branch = 'master' },
        },
        -- build = 'make tiktoken',
        config = function()
            vim.keymap.set('n', '<leader>c', function()
                require('CopilotChat').toggle()
            end, {})
        end,
        opts = {
            -- See Configuration section for options
            mappings = {
                accept_diff = {
                    normal = '<CR>',
                    -- insert = '<A-y>',
                },
            },
        },
    },
    {
        "olimorris/codecompanion.nvim",
        tag = 'v17.33.0',
        pin = true,
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {
            ignore_warnings = true,
            strategies = {
                chat = {
                    name = "copilot",
                    model = "gpt-4.1"
                },
            },
            -- NOTE: The log_level is in `opts.opts`
            opts = {
                log_level = "DEBUG",
            },
        },
    },
}
