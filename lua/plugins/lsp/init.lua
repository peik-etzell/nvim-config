vim.pack.add({ 'https://github.com/b0o/schemastore.nvim' })

require('plugins.lsp.clangd')
require('plugins.lsp.jsonls')
require('plugins.lsp.yamlls')

local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.pack.add({
    {
        src = 'https://github.com/neovim/nvim-lspconfig',
    },
})

vim.lsp.config('*', {
    capabilities = capabilities,
    root_markers = { '.git' },
})
