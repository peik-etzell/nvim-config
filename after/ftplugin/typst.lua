vim.keymap.set('n', '<leader>z', function()
    vim.fn.system(
        string.format('zathura --fork %s.pdf &', vim.fn.expand('%:p:r'))
    )
end, {})

local function typst_stop()
    if vim.g.typst_watching then
        vim.fn.jobstop(vim.g.typst_watching_job_id)
        vim.g.typst_watching = false
        vim.g.typst_watching_job_id = 0
    end
end

local function typst_watch(file)
    typst_stop()

    local job_id = vim.fn.jobstart({ 'typst', 'watch', file })
    if job_id > 0 then
        vim.g.typst_watching = true
        vim.g.typst_watching_job_id = job_id
    else
        error('Failed to start `typst watch`', 0)
    end
end

if not vim.g.typst_watching then
    local main = vim.fn.findfile('main.typ', '.;')
    if main ~= '' then
        typst_watch(main)
    end
end

vim.api.nvim_create_user_command('TypstWatch', function(opts)
    local file = opts.fargs[1] or vim.fn.expand('%:p')
    typst_watch(file)
end, { nargs = '?', complete = 'file' })

vim.api.nvim_create_user_command('TypstStop', typst_stop, {})

vim.bo.commentstring = '// %s'
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
