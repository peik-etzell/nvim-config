--- @type vim.lsp.Config
return {
    filetypes = {'lua'},
    root_markers = {'.luarc.json', 'stylua.toml'},
    settings = {
        Lua = {
            completion = {
                callSnippet = 'Replace',
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
            telemetry = { enable = false },
        },
    },
}
