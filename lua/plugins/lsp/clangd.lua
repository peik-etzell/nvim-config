local capabilities = require('blink.cmp').get_lsp_capabilities()

--- @type vim.lsp.Config
return {
    capabilities = vim.tbl_extend(
        'force',
        capabilities,
        { offsetEncoding = 'utf-8' }
    ),
    filetypes = { 'cpp', 'c', 'cuda', 'objcpp', 'objc' },
}
