local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'
local netcoredbg = vim.g.is_windows
        and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
    or vim.g.is_nixos and 'netcoredbg'
    or mason_pkgs .. '/netcoredbg/netcoredbg'

return {
    'GustavEikaas/easy-dotnet.nvim',
    enabled = vim.fn.executable('dotnet') == 1,
    ft = { 'cs', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    opts = {
        lsp = {
            auto_refresh_codelens = false,
        },
        debugger = {
            bin_path = netcoredbg,
        },
    },
    keys = {
        { '<leader>dn', ':Dotnet<CR>', desc = '[D]ot[N]et' },
    },
}
