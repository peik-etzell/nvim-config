vim.pack.add({
    'https://github.com/GustavEikaas/easy-dotnet.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'cs', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' },
    callback = function()
        if vim.fn.executable('dotnet') == 1 then
            local mason_pkgs = vim.fn.stdpath('data') .. '/mason/packages'
            local netcoredbg = vim.g.is_windows
                    and mason_pkgs .. '/netcoredbg/netcoredbg/netcoredbg.exe'
                or vim.g.is_nixos and 'netcoredbg'
                or mason_pkgs .. '/netcoredbg/netcoredbg'

            if vim.fn.executable(netcoredbg) == 0 then
                print('netcoredbg is not executable')
            end

            require('easy-dotnet').setup({
                lsp = {
                    auto_refresh_codelens = false,
                },
                debugger = {
                    bin_path = netcoredbg,
                },
            })

            vim.keymap.set(
                'n',
                '<leader>dn',
                ':Dotnet<CR>',
                { desc = '[D]ot[N]et' }
            )
        end
    end,
})
