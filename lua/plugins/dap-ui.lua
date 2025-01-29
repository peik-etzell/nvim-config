return {
    {
        'rcarriga/nvim-dap-ui',
        ft = { 'c', 'cpp', 'rust', 'python', 'csharp' },
        lazy = true,
        dependencies = {
            'nvim-neotest/nvim-nio',
            'mfussenegger/nvim-dap',
            {
                'theHamsta/nvim-dap-virtual-text',
                config = function()
                    require('nvim-dap-virtual-text').setup({
                        enabled_commands = false,
                        only_first_definition = false,
                        all_references = true,
                    })
                end,
            },
            {
                'LiadOz/nvim-dap-repl-highlights',
                dependencies = {
                    'nvim-treesitter/nvim-treesitter',
                },
                config = function()
                    require('nvim-dap-repl-highlights').setup()
                    require('nvim-treesitter.configs').setup({
                        ensure_installed = { 'dap_repl' },
                    })
                end,
            },
        },
        config = function()
            local dapui = require('dapui')
            ---@diagnostic disable-next-line: missing-fields
            dapui.setup({
                icons = {
                    expanded = '▾',
                    collapsed = '▸',
                    current_frame = '▸',
                },
                mappings = {
                    -- Use a table to apply multiple mappings
                    expand = { '<CR>', '<2-LeftMouse>' },
                    open = 'o',
                    remove = 'd',
                    edit = 'e',
                    repl = 'r',
                    toggle = 't',
                },
                -- Layouts define sections of the screen to place windows.
                -- The position can be "left", "right", "top" or "bottom".
                -- The size specifies the height/width depending on position. It can be an Int
                -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
                -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
                -- Elements are the elements shown in the layout (in order).
                -- Layouts are opened in order so that earlier layouts take priority in window sizing.
                layouts = {
                    {
                        elements = {
                            -- Elements can be strings or table with id and size keys.
                            { id = 'scopes', size = 0.25 },
                            'breakpoints',
                            'stacks',
                            'watches',
                        },
                        size = 40, -- 40 columns
                        position = 'left',
                    },
                    {
                        elements = {
                            'repl',
                            'console',
                        },
                        size = 0.25, -- 25% of total lines
                        position = 'bottom',
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen.
                    border = vim.g.border, -- Border style. Can be "single", "double" or "rounded"
                    mappings = {
                        close = { 'q', '<Esc>' },
                    },
                },
                windows = { indent = 1 },
                ---@diagnostic disable-next-line: missing-fields
                render = {
                    max_type_length = nil, -- Can be integer or nil.
                    max_value_lines = 100, -- Can be integer or nil.
                },
            })
            vim.keymap.set({ 'i', 'n' }, '<F4>', function()
                dapui.toggle()
            end, { silent = true })

            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = { '[dap-repl-*' },
                callback = function()
                    vim.cmd.startinsert()
                end,
            })
            vim.api.nvim_create_autocmd({ 'BufLeave' }, {
                pattern = { '[dap-repl-*' },
                callback = function()
                    vim.cmd.stopinsert()
                end,
            })
        end,
    },
}
