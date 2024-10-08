return {
    {
        'nvim-tree/nvim-tree.lua',
        event = 'VeryLazy',
        config = function()
            require('nvim-tree').setup({
                notify = {
                    threshold = vim.log.levels.WARN,
                },
                update_focused_file = {
                    enable = false,
                },
                renderer = {
                    add_trailing = true,
                    group_empty = true,
                    icons = {
                        git_placement = 'after',
                        modified_placement = 'after',
                    },
                    special_files = {
                        'Cargo.toml',
                        'Makefile',
                        'makefile',
                        'README.md',
                        'default.nix',
                    },
                },
                actions = {
                    open_file = {
                        resize_window = false,
                    },
                },
            })
            local opts = { silent = true }
            local tree = require('nvim-tree.api').tree
            vim.keymap.set('n', '<leader>at', function()
                tree.toggle({
                    find_file = false,
                })
            end, opts)
            vim.keymap.set('n', '<leader>af', function()
                tree.find_file({
                    open = true,
                    focus = true,
                })
            end, opts)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
}
