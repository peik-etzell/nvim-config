return {
    {
        {
            'mfussenegger/nvim-dap',
            lazy = true,
            config = function()
                local dap = require('dap')
                local adapters = dap.adapters
                local configurations = dap.configurations

                -- ADAPTERS
                adapters.gdb = {
                    type = 'executable',
                    command = 'gdb',
                    args = { '-i', 'dap' },
                }

                adapters.lldb = {
                    type = 'executable',
                    command = vim.g.nixos
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
        { 'mfussenegger/nvim-dap-python', lazy = true, ft = 'python' },
    },
}
