local function deno_overwrite()
    local is_deno_project = vim.fn.glob('deno.json') ~= ''
    if is_deno_project then
        return { 'deno_fmt' }
    else
        return { 'prettierd', 'prettier', stop_after_first = true }
    end
end

return {
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>s',
                function()
                    require('conform').format({
                        async = true,
                        lsp_format = 'fallback',
                    })
                end,
                mode = '',
                desc = 'Format buffer',
            },
        },
        opts = {
            formatters_by_ft = {
                proto = { 'buf' },
                python = { 'black' },

                lua = { 'stylua' },

                sh = { 'shfmt' },

                cmake = { 'cmake_format' },

                javascript = deno_overwrite(),
                typescript = deno_overwrite(),
                javascriptreact = deno_overwrite(),
                typescriptreact = deno_overwrite(),

                astro = deno_overwrite(),
                nix = { 'nixfmt' },
                typst = { 'typstyle' },

                markdown = { 'deno_fmt' },
                json = { 'deno_fmt' },
                jsonc = { 'deno_fmt' },
            },
        },
    },
}
