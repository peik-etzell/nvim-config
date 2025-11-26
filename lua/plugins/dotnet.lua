local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'
local netcoredbg = vim.g.is_windows
        and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
    or vim.g.is_nixos and 'netcoredbg'
    or mason_pkgs .. '/netcoredbg/netcoredbg'

return {
    'GustavEikaas/easy-dotnet.nvim',
    enabled = vim.fn.executable('dotnet') == 1,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    opts = {
        debugger = {
            bin_path = netcoredbg,
        },
    },
}
