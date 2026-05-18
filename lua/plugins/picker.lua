vim.pack.add({
    { src = 'https://github.com/nvim-mini/mini.pick', version = 'stable' },
})

local pick = require('mini.pick')
pick.setup()

vim.keymap.set('n', '<leader>f', function()
    pick.builtin.cli({
        command = {
            'rg',
            '--files',
            -- '--no-follow',
            '--color=never',
            '--no-ignore-vcs',
            -- '--smart-case',
        },
    }, {
        source = {
            name = 'Files (rg --no-ignore-vcs)',
        },
    })
end, { desc = 'Search [F]iles' })
vim.keymap.set('n', '<leader>o', function()
    pick.builtin.files({ tool = 'git' })
end, { desc = 'Search files (git)' })
vim.keymap.set(
    'n',
    '<leader>g',
    pick.builtin.grep_live,
    { desc = 'Search in files' }
)
vim.keymap.set(
    'n',
    '<leader>i',
    pick.builtin.grep_live,
    { desc = 'Search in files (git)' }
)
