return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            -- { 'linrongbin16/lsp-progress.nvim', opts = {} },
            {
                'abccsss/nvim-gitstatus',
                event = 'VeryLazy',
                config = true,
                opts = {
                    auto_fetch_interval = 30000,
                    git_status_timeout = 1000,
                    debug = false,
                },
            },
        },
        enabled = not vim.g.started_by_firenvim,
        init = function()
            local filepath = { 'filename', path = 1 }
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    icons_enabled = true,
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {
                            'NvimTree',
                            'dap-repl',
                            'dapui_console',
                            'dapui_scopes',
                            'dapui_breakpoints',
                            'dapui_stacks',
                            'dapui_watches',
                        },
                        winbar = {
                            'NvimTree',
                            'toggleterm',
                            'dap-repl',
                            'dapui_console',
                            'dapui_scopes',
                            'dapui_breakpoints',
                            'dapui_stacks',
                            'dapui_watches',
                        },
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 500,
                    },
                },
                sections = {
                    lualine_a = {},
                    lualine_b = { 'branch' },
                    lualine_c = { 'diff' },
                    lualine_x = { 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { filepath },
                    lualine_x = {
                        'diagnostics',
                        'lsp_status',
                    },
                    lualine_y = {},
                    lualine_z = {
                        {
                            'gitstatus',
                            sections = {
                                { 'ahead', format = '{}↑' },
                                { 'behind', format = '{}↓' },
                            },
                        },
                    },
                },
                inactive_winbar = {
                    lualine_a = { filepath },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = {},
            })
        end,
    },
}
