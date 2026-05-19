--- @type vim.lsp.Config
return {
    settings = {
        enable_autofix = false,
        enable_build_on_save = true,
    },
    root_markers = { 'zls.json', 'build.zig', '.git' },
}
