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

vim.pack.add({
    'https://github.com/mfussenegger/nvim-dap',
    {
        src = 'https://github.com/igorlfs/nvim-dap-view',
        version = vim.version.range('1.*'),
    },
})

local dap = require('dap')
local dap_view = require('dap-view')

local adapters = dap.adapters
local configurations = dap.configurations
local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'

dap.set_log_level('TRACE')
vim.fn.sign_define(
    'DapBreakpoint',
    { text = '🛑', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
    'DapBreakpointCondition',
    { text = '🖥️', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
    'DapBreakpointRejected',
    { text = '🚫', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
    'DapStopped',
    { text = '👉', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
    'DapLogPoint',
    { text = '🗒', texthl = '', linehl = '', numhl = '' }
)

local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map('n', '<F4>', dap_view.toggle, 'Toggle Dap-UI')
map('n', '<F5>', dap.continue, 'Continue')
map('n', '<F9>', dap.toggle_breakpoint, 'Toggle breakpoint')

map('n', '<Down>', dap.step_over, 'Step over')
map('n', '<Up>', dap.restart_frame, 'Step back')
map('n', '<Right>', dap.step_into, 'Step into')
map('n', '<Left>', dap.step_out, 'Step out')

map('n', '<leader>drr', dap.continue, 'Continue')
map('n', '<leader>drc', dap.run_to_cursor, 'Run to cursor')

map('n', '<C-k>', dap_view.hover, 'Dap Hover')

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

local netcoredbg = vim.g.is_windows
        and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
    or vim.g.is_nixos and 'netcoredbg'
    or mason_pkgs .. '/netcoredbg/netcoredbg'

adapters.dotnet = {
    type = 'executable',
    command = netcoredbg,
    args = { '--interpreter=vscode' },
}

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

-- return {
--     {
--         {
--             'mfussenegger/nvim-dap',
--             lazy = true,
--             config = function()
--                 local dap = require('dap')
--                 local adapters = dap.adapters
--                 local configurations = dap.configurations
--
--                 local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'
--
--                 vim.fn.sign_define(
--                     'DapBreakpoint',
--                     { text = '🛑', texthl = '', linehl = '', numhl = '' }
--                 )
--
--                 -- ADAPTERS
--                 adapters.gdb = {
--                     type = 'executable',
--                     command = 'gdb',
--                     args = {
--                         '--interpreter=dap',
--                         '--eval-command',
--                         'set print pretty on',
--                         '--eval-command',
--                         'set print array on',
--                         '--eval-command',
--                         'set print address off',
--                     },
--                 }
--
--                 adapters.codelldb = {
--                     name = 'codelldb',
--                     type = 'server',
--                     port = '${port}',
--                     executable = {
--                         command = 'codelldb', -- or if not in $PATH: "/absolute/path/to/codelldb"
--                         args = { '--port', '${port}' },
--
--                         -- On windows you may have to uncomment this:
--                         -- detached = false,
--                     },
--                 }
--
--                 adapters.cppdbg = {
--                     id = 'cppdbg',
--                     type = 'executable',
--                     command = mason_pkgs
--                         .. '/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
--                 }
--
--                 -- C#
--                 local netcoredbg = vim.g.is_windows
--                         and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
--                     or vim.g.is_nixos and 'netcoredbg'
--                     or mason_pkgs .. '/netcoredbg/netcoredbg'
--                 adapters.coreclr = {
--                     type = 'executable',
--                     command = netcoredbg,
--                     args = { '--interpreter=vscode' },
--                 }
--
--                 -- CONFIGURATIONS
--                 local lldb_config = {
--                     name = 'LLDB',
--                     type = 'codelldb',
--                     request = 'launch',
--                     program = pick_file_with_dbgsym,
--                     cwd = '${workspaceFolder}',
--                     stopOnEntry = false,
--                 }
--
--                 local gdbserver_config = {
--                     name = 'gdbserver at localhost:1234',
--                     type = 'cppdbg',
--                     request = 'launch',
--                     MIMode = 'gdb',
--                     miDebuggerServerAddress = 'localhost:1234',
--                     miDebuggerPath = '/usr/bin/gdb',
--                     cwd = '${workspaceFolder}',
--                     program = pick_file_with_dbgsym,
--                     setupCommands = {
--                         {
--                             text = '-enable-pretty-printing',
--                             description = 'enable pretty printing',
--                             ignoreFailures = false,
--                         },
--                     },
--                 }
--                 local gdb_config = {
--                     name = 'GDB',
--                     type = 'gdb',
--                     request = 'launch',
--                     program = pick_file_with_dbgsym,
--                     cwd = '${workspaceFolder}',
--                     stopAtBeginningOfMainSubprogram = true,
--                 }
--
--                 local cppdbg_config = {
--                     name = 'cppdbg',
--                     type = 'cppdbg',
--                     request = 'launch',
--                     program = pick_file_with_dbgsym,
--                     cwd = '${workspaceFolder}',
--                     stopAtEntry = true,
--                 }
--
--                 configurations.cpp = {
--                     gdb_config,
--                     gdbserver_config,
--                     cppdbg_config,
--                 }
--                 configurations.c = configurations.cpp
--                 configurations.rust = configurations.cpp
--                 configurations.zig = { lldb_config }
--
--                 local opts = { silent = true }
--                 vim.keymap.set({ 'i', 'n' }, '<F5>', dap.continue, opts)
--                 vim.keymap.set(
--                     { 'i', 'n' },
--                     '<F9>',
--                     dap.toggle_breakpoint,
--                     opts
--                 )
--                 vim.keymap.set({ 'i', 'n' }, '<F10>', dap.step_over, opts)
--                 vim.keymap.set({ 'i', 'n' }, '<F11>', dap.step_into, opts)
--                 vim.keymap.set({ 'i', 'n' }, '<s-<F11>>', dap.step_out, opts)
--             end,
--         },
--         { 'mfussenegger/nvim-dap-python', lazy = true, ft = 'python' },
--     },
-- }
