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
            {
                'someone-stole-my-name/yaml-companion.nvim',
                dependencies = {
                    { 'neovim/nvim-lspconfig' },
                    { 'nvim-lua/plenary.nvim' },
                    { 'nvim-telescope/telescope.nvim' },
                },
                config = function()
                    require('telescope').load_extension('yaml_schema')
                end,
                ft = { 'yaml', 'json' },
            },
        },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            vim.diagnostic.config({ virtual_text = false, severity_sort = true })
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP on_attach',
                callback = function(event)
                    local function nmap(lhs, rhs, desc)
                        vim.keymap.set(
                            'n',
                            lhs,
                            rhs,
                            { silent = true, buffer = event.buf, desc = desc }
                        )
                    end
                    nmap(
                        '<C-S-k>',
                        vim.lsp.buf.signature_help,
                        'Signature help'
                    )
                    nmap('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
                    nmap('K', function()
                        if require('dap').status() ~= '' then
                            require('dapui').eval()
                        else
                            vim.lsp.buf.hover({
                                close_events = {
                                    'CursorMoved',
                                    'BufLeave',
                                    'WinLeave',
                                    'FocusLost',
                                    'CmdlineEnter',
                                },
                            })
                        end
                    end, 'Symbol information')

                    nmap(
                        'gt',
                        vim.lsp.buf.type_definition,
                        'Goto type definition'
                    )
                    nmap('grr', vim.lsp.buf.references, 'List references')
                    nmap('gd', vim.lsp.buf.definition, 'Goto definition')
                    nmap(
                        'gi',
                        vim.lsp.buf.implementation,
                        'Goto implementation'
                    )
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

            local yaml_companion = require('yaml-companion')
            vim.lsp.config.yamlls = yaml_companion.setup()

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


            vim.lsp.config.neocmake = {
                cmd = { 'neocmakelsp', 'stdio' }
            }

            vim.lsp.enable({
                'asm_lsp',
                'autotools_ls',
                'bashls',
                'clangd',
                'neocmake',
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
