local function pick_file_with_dbgsym()
    return require('dap.utils').pick_file({
        filter = function(filename)
            local uv = vim.uv or vim.loop
            local user_execute = tonumber('00100', 8)
            local stat = uv.fs_stat(filename)
            local exe = stat
                    and bit.band(stat.mode, user_execute) == user_execute
                or false
            if not exe then
                return false
            end

            local relpath =
                string.sub(filename, string.len(vim.fn.getcwd()) + 2)

            if
                vim.startswith(relpath, '.git')
                or vim.startswith(relpath, '.direnv')
                or vim.startswith(relpath, '.zig-cache')
            then
                return false
            end

            local symbols =
                vim.fn.system('file ' .. filename .. ' | grep debug_info')
            local has_dbgsyms = symbols and symbols ~= ''

            return has_dbgsyms
        end,
    })
end

return {
    {
        {
            'mfussenegger/nvim-dap',
            lazy = true,
            config = function()
                local dap = require('dap')
                local adapters = dap.adapters
                local configurations = dap.configurations

                local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'

                vim.fn.sign_define(
                    'DapBreakpoint',
                    { text = '🛑', texthl = '', linehl = '', numhl = '' }
                )

                -- ADAPTERS
                adapters.gdb = {
                    type = 'executable',
                    command = 'gdb',
                    args = {
                        '--interpreter=dap',
                        '--eval-command',
                        'set print pretty on',
                        '--eval-command',
                        'set print array on',
                        '--eval-command',
                        'set print address off',
                    },
                }

                adapters.codelldb = {
                    name = 'codelldb',
                    type = 'server',
                    port = '${port}',
                    executable = {
                        command = 'codelldb', -- or if not in $PATH: "/absolute/path/to/codelldb"
                        args = { '--port', '${port}' },

                        -- On windows you may have to uncomment this:
                        -- detached = false,
                    },
                }

                -- C#
                local netcoredbg = vim.g.is_windows
                        and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
                    or mason_pkgs .. '/netcoredbg/netcoredbg'
                adapters.coreclr = {
                    type = 'executable',
                    command = netcoredbg,
                    args = { '--interpreter=vscode' },
                }

                -- CONFIGURATIONS
                local lldb_config = {
                    name = 'LLDB',
                    type = 'codelldb',
                    request = 'launch',
                    program = pick_file_with_dbgsym,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                }

                local gdbserver_config = {
                    name = 'gdbserver at localhost:1234',
                    type = 'cppdbg',
                    request = 'launch',
                    MIMode = 'gdb',
                    miDebuggerServerAddress = 'localhost:1234',
                    miDebuggerPath = '/usr/bin/gdb',
                    cwd = '${workspaceFolder}',
                    program = pick_file_with_dbgsym,
                    setupCommands = {
                        {
                            text = '-enable-pretty-printing',
                            description = 'enable pretty printing',
                            ignoreFailures = false,
                        },
                    },
                }
                local gdb_config = {
                    name = 'GDB',
                    type = 'gdb',
                    request = 'launch',
                    program = pick_file_with_dbgsym,
                    cwd = '${workspaceFolder}',
                    stopAtBeginningOfMainSubprogram = true,
                }

                configurations.cpp = {
                    gdb_config,
                    gdbserver_config,
                }
                configurations.c = configurations.cpp
                configurations.rust = configurations.cpp
                configurations.zig = { lldb_config }
                configurations.cs = {
                    {
                        type = 'coreclr',
                        name = 'Launch netcoredbg',
                        request = 'launch',
                        program = function()
                            return require('dap.utils').pick_file({
                                filter = '.*bin/Debug/.*%.dll',
                                executables = false,
                            })
                        end,
                    },
                }

                local opts = { silent = true }
                vim.keymap.set({ 'i', 'n' }, '<F5>', dap.continue, opts)
                vim.keymap.set(
                    { 'i', 'n' },
                    '<F9>',
                    dap.toggle_breakpoint,
                    opts
                )
                vim.keymap.set({ 'i', 'n' }, '<F10>', dap.step_over, opts)
                vim.keymap.set({ 'i', 'n' }, '<F11>', dap.step_into, opts)
                vim.keymap.set({ 'i', 'n' }, '<s-<F11>>', dap.step_out, opts)
            end,
        },
        { 'mfussenegger/nvim-dap-python', lazy = true, ft = 'python' },
    },
}
