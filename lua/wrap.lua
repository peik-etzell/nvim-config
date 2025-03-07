-- Turn on wrap and modify movement binds when entering a prose-based file
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = {
        'text',
        'markdown',
        'tex',
        'latex',
        'typst',
        -- 'dap-repl',
    },
    callback = function(_)
        if vim.fn.expand('%:t') == 'CMakeLists.txt' then
            return
        end

        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.colorcolumn = ''
        vim.opt_local.smoothscroll = true
        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = 'number'
        for _, key in pairs({ 'j', 'k', '$', '0' }) do
            vim.keymap.set(
                { 'n', 'v' },
                key,
                string.format('g%s', key),
                { silent = true, buffer = true }
            )
        end

        vim.keymap.set('n', '<leader>w', 'gqq', { silent = true })
        vim.keymap.set('v', '<leader>w', 'gq', { silent = true })
    end,
})
