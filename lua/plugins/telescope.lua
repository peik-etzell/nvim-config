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
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--no-ignore-vcs',
                    },
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
                        '--files',
                        '--color=never',
                        '--no-ignore-vcs',
                    },
                })
            end, 'Fuzzy find files')
            map('<leader>c', function()
                builtin.colorscheme({
                    layout_strategy = 'cursor',
                    layout_config = {
                        width = 25,
                        height = 10,
                    },
                })
            end, 'Change colorscheme')
            map('<leader>g', function()
                builtin.live_grep({ layout_strategy = 'vertical' })
            end, 'Fuzzy find in files')
            map('<leader>lr', function()
                builtin.lsp_references()
            end, 'Lsp references')
            map('<leader>lk', function()
                builtin.diagnostics()
            end, 'Lsp diagnostics')
            map('<leader>li', function()
                builtin.lsp_implementations()
            end, 'Lsp implementations')
            map('<leader>ld', function()
                builtin.lsp_definitions()
            end, 'Lsp definitions')
            map('<C-/>', function()
                builtin.current_buffer_fuzzy_find({
                    layout_strategy = 'vertical',
                })
            end, 'Fuzzy find in current buffer')
            map('<leader>ta', function()
                builtin.builtin()
            end, 'Telescope builtins')
        end,
    },
}
