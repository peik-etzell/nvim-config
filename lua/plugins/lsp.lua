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
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            vim.diagnostic.config({ virtual_text = false, severity_sort = true })
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
                    set_keymap('K', function()
                        vim.lsp.buf.hover({
                            border = vim.g.border,
                            close_events = {
                                'CursorMoved',
                                'BufLeave',
                                'WinLeave',
                            },
                        })
                    end)

                    set_keymap('gt', vim.lsp.buf.type_definition)
                    set_keymap('gr', vim.lsp.buf.references)
                    set_keymap('gd', vim.lsp.buf.definition)
                    set_keymap('gi', vim.lsp.buf.implementation)
                end,
            })

            local default_capabilities =
                require('blink.cmp').get_lsp_capabilities()

            vim.lsp.config('*', {
                capabilities = default_capabilities,
                root_markers = { '.git' },
            })

            vim.lsp.config.lua_ls = {
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

            vim.lsp.config.bashls = {
                filetypes = { 'sh', 'zsh', 'bash' },
            }

            vim.lsp.config.clangd = {
                capabilities = vim.tbl_extend(
                    'force',
                    default_capabilities,
                    { offsetEncoding = 'utf-8' }
                ),
                filetypes = { 'cpp', 'c', 'cuda', 'objcpp', 'objc' },
            }

            vim.lsp.config.omnisharp = {
                cmd = {
                    vim.g.is_linux and 'OmniSharp' or 'omnisharp',
                    '-z',
                    '--hostPID',
                    '12345',
                    'DotNet:enablePackageRestore=false',
                    '--encoding',
                    'utf-8',
                    '--languageserver',
                },
            }

            vim.g.zig_fmt_autosave = 0
            vim.lsp.config.zls = {
                settings = {
                    enable_autofix = false,
                    enable_build_on_save = true,
                },
                root_markers = { 'zls.json', 'build.zig', '.git' },
            }

            vim.lsp.config.nil_ls = {
                settings = {
                    ['nil'] = {
                        nix = {
                            flake = { autoArchive = true },
                        },
                        formatting = {
                            command = { 'nixfmt' },
                        },
                    },
                },
            }

            vim.lsp.config.denols = {
                root_markers = { 'deno.json', 'deno.jsonc' },
                settings = {
                    deno = {
                        enable = true,
                        unstable = true,
                        suggest = {
                            imports = {
                                hosts = {
                                    ['https://deno.land'] = true,
                                },
                            },
                        },
                    },
                },
            }
            vim.lsp.config.html = {
                root_markers = { 'package.json', 'deno.json', '.git' },
                filetypes = { 'html', 'templ', 'eta' },
                init_options = {
                    provideFormatter = false,
                },
            }

            vim.lsp.config.tinymist = {
                root_markers = { 'main.typ' },
                single_file_support = true,
                settings = {
                    exportPdf = 'never',
                    systemFonts = true,
                    semanticTokens = 'disable',
                    compileStatus = 'disable',
                    dragAndDrop = 'disable',
                    renderDocs = 'disable',
                    previewFeature = 'disable',
                },
            }

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

            vim.lsp.enable({
                'asm_lsp',
                'autotools_ls',
                'bashls',
                'clangd',
                'cmake',
                'cssls',
                'denols',
                'docker_compose_language_service',
                'dockerls',
                'elmls',
                'eslint',
                'fish_lsp',
                'html',
                'json',
                'jsonls',
                'lemminx',
                'lua_ls',
                'marksman',
                'nil_ls',
                'omnisharp',
                'openscad_lsp',
                'postgres_lsp',
                'pyright',
                'slangd',
                'superhtml',
                'svelte',
                'texlab',
                'tinymist',
                'yamlls',
                'zls',
                -- 'basedpyright',
            })
        end,
    },
}
