local function deno_overwrite()
    local is_deno_project = vim.fn.glob('deno.json') ~= ''
    if is_deno_project then
        return { 'deno_fmt' }
    else
        return { 'prettierd', 'prettier', stop_after_first = true }
    end
end

vim.pack.add({
    {
        src = 'https://github.com/stevearc/conform.nvim',
        version = vim.version.range('v9.*'),
    },
})

require('conform').setup({
    formatters = {},
    formatters_by_ft = {
        lua = { 'stylua' },
        proto = { 'buf' },
        python = { 'black' },
        sh = { 'shfmt' },
        javascript = deno_overwrite(),
        typescript = deno_overwrite(),
        javascriptreact = deno_overwrite(),
        typescriptreact = deno_overwrite(),

        xml = { 'csharpier' },
        cs = { 'csharpier' },

        astro = deno_overwrite(),
        nix = { 'nixfmt' },
        typst = { 'typstyle' },

        markdown = { 'deno_fmt' },
        json = { 'deno_fmt' },
        jsonc = { 'deno_fmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
    },
})

vim.keymap.set('n', '<leader>s', function()
    require('conform').format({
        async = true,
        lsp_format = 'fallback',
        filter = function(server)
            return server.name ~= 'lua_ls'
                and server.name ~= 'tsserver'
                and server.name ~= 'clangd'
                and server.name ~= 'easy_dotnet'
        end,
    })
end, {
    desc = 'Format buffer',
})
