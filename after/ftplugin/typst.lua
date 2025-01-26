local function typst_stop()
    if vim.g.typst_watching then
        vim.fn.jobstop(vim.g.typst_watching_job_id)
        vim.g.typst_watching = false
        vim.g.typst_watching_job_id = 0
    end
    if vim.g.zathura_id then
        vim.fn.jobstop(vim.g.zathura_id)
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

vim.keymap.set('n', '<leader>z', function()
    local current_file_base = vim.fn.expand('%:p:r')
    typst_watch(string.format('%s.typ', current_file_base))
    local zathura_id =
        vim.fn.jobstart({ 'zathura', (current_file_base .. '.pdf') })
    if zathura_id > 0 then
        vim.g.zathura_id = zathura_id
    end
end, {})

vim.api.nvim_create_user_command('TypstWatch', function(opts)
    local file = opts.fargs[1] or vim.fn.expand('%:p')
    typst_watch(file)
end, { nargs = '?', complete = 'file' })

vim.api.nvim_create_user_command('TypstStop', typst_stop, {})

vim.bo.commentstring = '// %s'
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
