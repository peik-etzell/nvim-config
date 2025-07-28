local function indent_pure_vim()
    local cursor_pos = vim.fn.getcurpos()
    vim.cmd.normal('gg=G')
    vim.fn.setpos('.', cursor_pos)
end

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'saghen/blink.cmp',
            {
                'https://git.sr.ht/~p00f/clangd_extensions.nvim',
                ft = { 'cpp', 'c' },
            },
        },
        config = function()
            vim.diagnostic.config({ virtual_text = false, severity_sort = true })
            vim.lsp.handlers['textDocument/hover'] =
                vim.lsp.with(vim.lsp.handlers.hover, {
                    border = vim.g.border,
                })
            require('lspconfig.ui.windows').default_options.border =
                vim.g.border
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP on_attach',
                callback = function(event)
                    local function set_keymap(lhs, rhs)
                        vim.keymap.set(
                            'n',
                            lhs,
                            rhs,
                            { silent = true, buffer = event.buf }
                        )
                    end
                    set_keymap('<C-S-k>', vim.lsp.buf.signature_help)
                    set_keymap('<leader>rn', vim.lsp.buf.rename)
                end,
            })

            local servers = {
                'fish_lsp',
                'slangd',
                'pyright',
                'texlab',
                'openscad_lsp',
                'cmake',
                'dockerls',
                'docker_compose_language_service',
                'jsonls',
                'cssls',
                'html',
                -- 'htmx',
                'marksman',
                'lemminx',
                'eslint',
                'asm_lsp',
                'elmls',
                'svelte',
                'autotools_ls',
                'superhtml',
                'postgres_lsp',
            }
            local lspconfig = require('lspconfig')
            local default_capabilities =
                require('blink.cmp').get_lsp_capabilities()
            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = default_capabilities,
                })
            end
            lspconfig.lua_ls.setup({
                capabilities = default_capabilities,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                    },
                },
            })
            lspconfig.bashls.setup({
                capabilities = default_capabilities,
                filetypes = { 'sh', 'zsh', 'bash' },
            })
            lspconfig.clangd.setup({
                capabilities = default_capabilities,
                filetypes = { 'cpp', 'c', 'cuda', 'objcpp', 'objc' },
            })
            local function omnisharp_cmd()
                return { vim.g.nixos and 'OmniSharp' or 'omnisharp' }
            end
            lspconfig.omnisharp.setup({
                capabilities = default_capabilities,
                cmd = omnisharp_cmd(),
            })
            vim.g.zig_fmt_autosave = 0
            lspconfig.zls.setup({
                capabilities = default_capabilities,
                settings = {
                    enable_autofix = false,
                    enable_build_on_save = true,
                },
            })

            lspconfig.nil_ls.setup({
                capabilities = default_capabilities,
                settings = {
                    ['nil'] = {
                        formatting = {
                            command = { 'nixfmt' },
                        },
                    },
                },
            })

            lspconfig.denols.setup({
                capabilities = default_capabilities,
                root_dir = lspconfig.util.root_pattern(
                    'deno.json',
                    'deno.jsonc'
                ),
            })
            lspconfig.ts_ls.setup({
                capabilities = default_capabilities,
                root_dir = lspconfig.util.root_pattern('package.json'),
                single_file_support = false,
            })
            lspconfig.tinymist.setup({
                capabilities = default_capabilities,
                single_file_support = true,
            })
            -- lspconfig.harper_ls.setup({
            --     capabilities = default_capabilities,
            --     settings = {
            --         ['harper-ls'] = {
            --             isolateEnglish = true,
            --             userDictPath = vim.fn.stdpath('config')
            --                 .. '/spell/en.utf-8.add',
            --         },
            --     },
            -- })
        end,
    },
}
