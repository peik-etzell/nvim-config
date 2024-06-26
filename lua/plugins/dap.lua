return {
    {
        'rcarriga/nvim-dap-ui',
        ft = { 'c', 'cpp', 'rust', 'python', 'csharp' },
        dependencies = {
            'nvim-neotest/nvim-nio',
            {
                'mfussenegger/nvim-dap',
                config = function()
                    local dap = require('dap')
                    local adapters = dap.adapters
                    local configurations = dap.configurations
                    local nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0

                    -- ADAPTERS
                    adapters.gdb = {
                        type = 'executable',
                        command = 'gdb',
                        args = { '-i', 'dap' },
                    }

                    adapters.lldb = {
                        type = 'executable',
                        command = nixos
                                and '/run/current-system/sw/bin/lldb-vscode'
                            or vim.fn.stdpath('data')
                                .. '/mason/packages/codelldb/codelldb',
                        name = 'lldb',
                    }

                    adapters.cppdbg = {
                        id = 'cppdbg',
                        name = 'cppdbg',
                        type = 'executable',
                        command = vim.fn.stdpath('data')
                            .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
                    }
                    -- C#
                    adapters.coreclr = {
                        type = 'executable',
                        command = vim.fn.stdpath('data')
                            .. '/mason/packages/netcoredbg/netcoredbg',
                        args = { '--interpreter=vscode' },
                    }

                    local function path_to_executable()
                        return vim.fn.input({
                            prompt = 'Path to executable: ',
                            default = vim.fn.getcwd() .. '/',
                            completion = 'file',
                        })
                    end

                    -- CONFIGURATIONS
                    local lldbConfig = {
                        name = 'LLDB',
                        type = 'lldb',
                        request = 'launch',
                        program = path_to_executable,
                        cwd = '${workspaceFolder}',
                        stopOnEntry = false,
                        args = {},
                    }
                    local cpptoolsConfig = {
                        name = 'cpptools',
                        type = 'cppdbg',
                        request = 'launch',
                        program = path_to_executable,
                        cwd = '${workspaceFolder}',
                        stopOnEntry = true,
                        setupCommands = {
                            {
                                text = '-enable-pretty-printing',
                                description = 'enable pretty printing',
                                ignoreFailures = false,
                            },
                        },
                    }
                    local gdbserverConfig = {
                        name = 'gdbserver at localhost:1234',
                        type = 'cppdbg',
                        request = 'launch',
                        MIMode = 'gdb',
                        miDebuggerServerAddress = 'localhost:1234',
                        miDebuggerPath = '/usr/bin/gdb',
                        cwd = '${workspaceFolder}',
                        program = path_to_executable,
                        setupCommands = {
                            {
                                text = '-enable-pretty-printing',
                                description = 'enable pretty printing',
                                ignoreFailures = false,
                            },
                        },
                    }
                    local gdbConfig = {
                        name = 'GDB',
                        type = 'gdb',
                        request = 'launch',
                        program = path_to_executable,
                        cwd = '${workspaceFolder}',
                        stopAtBeginningOfMainSubprogram = false,
                    }

                    configurations.cpp = {
                        lldbConfig,
                        cpptoolsConfig,
                        gdbConfig,
                        gdbserverConfig,
                    }
                    configurations.c = configurations.cpp
                    configurations.rust = configurations.cpp
                    configurations.cs = {
                        {
                            type = 'coreclr',
                            name = 'Launch netcoredbg',
                            request = 'launch',
                            program = path_to_executable,
                        },
                    }

                    local opts = { silent = true }
                    vim.keymap.set({ 'n' }, '<F5>', dap.continue, opts)
                    vim.keymap.set({ 'n' }, '<F9>', dap.toggle_breakpoint, opts)
                    vim.keymap.set({ 'n' }, '<F10>', dap.step_over, opts)
                    vim.keymap.set({ 'n' }, '<F11>', dap.step_into, opts)
                    vim.keymap.set({ 'n' }, '<s-<F11>>', dap.step_out, opts)
                end,
            },
            { 'mfussenegger/nvim-dap-python', ft = 'python' },
            {
                'theHamsta/nvim-dap-virtual-text',
                dependencies = {
                    'nvim-treesitter/nvim-treesitter',
                },
                config = function()
                    require('nvim-dap-virtual-text').setup({
                        -- enable this plugin (the default)
                        enabled = true,
                        -- create commands
                        -- DapVirtualTextEnable,
                        -- DapVirtualTextDisable,
                        -- DapVirtualTextToggle,
                        -- (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                        enabled_commands = true,
                        -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                        highlight_changed_variables = true,
                        -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                        highlight_new_as_changed = false,
                        -- show stop reason when stopped for exceptions
                        show_stop_reason = true,
                        -- prefix virtual text with comment string
                        commented = false,
                        -- only show virtual text at first definition (if there are multiple)
                        only_first_definition = true,
                        -- show virtual text on all all references of the variable (not only definitions)
                        all_references = false,
                        -- clear virtual text on "continue" (might cause flickering when stepping)
                        clear_on_continue = false,
                        --- A callback that determines how a variable is displayed or whether it should be omitted
                        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
                        --- @param buf number
                        --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
                        --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
                        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
                        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
                        display_callback = function(
                            variable,
                            buf,
                            stackframe,
                            node,
                            options
                        )
                            if options.virt_text_pos == 'inline' then
                                return ' = ' .. variable.value
                            else
                                return variable.name .. ' = ' .. variable.value
                            end
                        end,
                        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text.
                        -- Use 'eol' to set to end of line
                        virt_text_pos = vim.fn.has('nvim-0.10') == 1
                                and 'inline'
                            or 'eol',

                        -- experimental features:
                        --
                        -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                        all_frames = false,
                        -- show virtual lines instead of virtual text (will flicker!)
                        virt_lines = false,
                        -- position the virtual text at a fixed window column (starting from the first text column) ,
                        virt_text_win_col = nil,
                        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
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
                -- Use this to override mappings for specific elements
                element_mappings = {
                    -- Example:
                    -- stacks = {
                    --   open = "<CR>",
                    --   expand = "o",
                    -- }
                },
                -- Expand lines larger than the window
                -- Requires >= 0.7
                expand_lines = vim.fn.has('nvim-0.7') == 1,
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
                controls = {
                    -- Requires Neovim nightly (or 0.8 when released)
                    enabled = true,
                    -- Display controls in this element
                    element = 'repl',
                    icons = {
                        pause = '',
                        play = '',
                        step_into = '',
                        step_over = '',
                        step_out = '',
                        step_back = '',
                        run_last = '↻',
                        terminate = '□',
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
                render = {
                    max_type_length = nil, -- Can be integer or nil.
                    max_value_lines = 100, -- Can be integer or nil.
                },
            })
            vim.keymap.set({ 'n' }, '<F4>', function()
                dapui.toggle()
            end, { silent = true })
        end,
    },
}
