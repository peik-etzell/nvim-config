return {
    'TheLeoP/powershell.nvim',
    enabled = vim.g.is_windows,
    ft = { 'ps1' },
    opts = {
        bundle_path = vim.fn.stdpath('data')
            .. '/mason/packages/powershell-editor-services',
    },
}
