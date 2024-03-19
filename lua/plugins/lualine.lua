return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'arkav/lualine-lsp-progress' },
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
                        },
                        winbar = {
                            'NvimTree',
                            'toggleterm',
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
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'diagnostics' },
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
                        {
                            'lsp_progress',
                            spinner_symbols = {
                                '🌑 ',
                                '🌒 ',
                                '🌓 ',
                                '🌔 ',
                                '🌕 ',
                                '🌖 ',
                                '🌗 ',
                                '🌘 ',
                            },
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
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
