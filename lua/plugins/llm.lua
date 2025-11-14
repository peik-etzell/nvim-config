return {
    {
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
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim', branch = 'master' },
        },
        -- build = 'make tiktoken',
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
}
