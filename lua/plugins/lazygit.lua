vim.pack.add({
    'https://github.com/kdheepak/lazygit.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
})

vim.g.lazygit_floating_window_scaling_factor = 1.0

vim.keymap.set(
    'n',
    '<leader>lz',
    require('lazygit').lazygit,
    { desc = 'Open LazyGit UI' }
)
