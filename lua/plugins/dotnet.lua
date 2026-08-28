require('plugins.dap')

vim.pack.add({
    'https://github.com/GustavEikaas/easy-dotnet.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
})

if vim.fn.executable('dotnet') == 1 then
    local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'
    local netcoredbg = vim.g.is_windows
            and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
        or vim.g.is_nixos and 'netcoredbg'
        or mason_pkgs .. '/netcoredbg/netcoredbg'

    if vim.fn.executable(netcoredbg) == 0 then
        print('netcoredbg is not executable')
    end

    local opts = {
        lsp = {
            auto_refresh_codelens = false,
            set_fold_expr = true,
        },
        debugger = {
            engine = 'netcoredbg',
            bin_path = netcoredbg,
        },
        notifications = { handler = false },
        projx_lsp = { enabled = false },
    }
    require('easy-dotnet').setup(opts)

    vim.keymap.set('n', '<leader>dn', ':Dotnet<CR>', { desc = '[D]ot[N]et' })
end
