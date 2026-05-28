vim.pack.add({ 'https://github.com/TheLeoP/powershell.nvim' })

require('plugins.mason')
require('plugins.completion')
local capabilities = require('blink.cmp').get_lsp_capabilities()

require('powershell').setup({
    bundle_path = vim.fn.stdpath('data')
        .. '/mason/packages/powershell-editor-services',
    capabilities = capabilities,
})
