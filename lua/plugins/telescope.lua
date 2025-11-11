return {
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        branch = '0.1.x',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            {
                'nvim-telescope/telescope-dap.nvim',
                dependencies = {
                    'mfussenegger/nvim-dap',
                    'nvim-treesitter/nvim-treesitter',
                },
            },
        },
        event = 'VeryLazy',
        config = function()
            require('telescope').setup({
                defaults = {
                    sorting_strategy = 'ascending',
                    scroll_strategy = 'limit',
                    layout_strategy = 'flex',
                    layout_config = {
                        prompt_position = 'top',
                        height = 0.99,
                        width = 0.99,
                        horizontal = {
                            preview_width = 0.5,
                        },
                    },
                    path_display = { 'truncate' },
                    file_ignore_patterns = {
                        -- latex
                        '%.ipe',
                        '%.eps',
                        '%.fls',
                        '%.fdb_latexmk',
                        '%.synctex.gz',
                        '%.aux',
                        '%.pdf',
                        'indent.log',
                        'node_modules/',
                        'flake.lock',

                        -- Binary files
                        '%.pcd',
                        '%.out',
                        '%.jpg',
                        '%.png',

                        -- ros
                        './build/',
                        'install/',
                        'log/',
                        'logs/',
                        'devel/',
                        -- python
                        '__pycache__/',
                        -- clangd
                        'compile_commands',
                    },
                },
            })
            pcall(require('telescope').load_extension, 'fzf')
            -- pcall(require('telescope').load_extension, 'dap')

            local function map(lhs, rhs, desc)
                vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
            end

            local builtin = require('telescope.builtin')

            map('<leader>f', function()
                builtin.find_files({
                    find_command = {
                        'rg',
                        '--color=never',
                        '--column',
                        '--files',
                        '--no-heading',
                        '--no-ignore-vcs',
                        '--smart-case',
                        '--with-filename',
                    },
                })
            end, 'Open file')

            map('<leader>o', function()
                builtin.git_files()
            end, 'Open file - git')

            map('<leader>c', function()
                builtin.colorscheme({
                    layout_strategy = 'cursor',
                    layout_config = {
                        width = 25,
                        height = 10,
                    },
                })
            end, 'Change colorscheme')

            map('<leader>i', function()
                builtin.live_grep({ layout_strategy = 'vertical' })
            end, 'Fuzzy find in files - git')

            map('<leader>g', function()
                builtin.live_grep({
                    additional_args = { '--no-ignore-vcs' },
                    layout_strategy = 'vertical',
                })
            end, 'Fuzzy find in files')

            map('<leader>lr', function()
                builtin.lsp_references()
            end, '[L]sp [r]eferences')
            map('<leader>lk', function()
                builtin.diagnostics()
            end, '[L]sp diagnosti[k]s')
            map('<leader>li', function()
                builtin.lsp_implementations()
            end, '[L]sp [i]mplementations')
            map('<leader>ld', function()
                builtin.lsp_definitions()
            end, '[L]sp [d]efinitions')
            map('<C-/>', function()
                builtin.current_buffer_fuzzy_find({
                    layout_strategy = 'vertical',
                })
            end, 'Fuzzy find in current buffer')
            map('<leader>ta', function()
                builtin.builtin()
            end, '[T]elescope builtins - [a]ll')
        end,
    },
}
