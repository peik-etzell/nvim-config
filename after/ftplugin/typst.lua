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

local function typst_preview()
    local current_file_base = vim.fn.expand('%:p:r')
    typst_watch(current_file_base .. '.typ')
    local pdf = current_file_base .. '.pdf'
    local zathura_id = vim.fn.jobstart(
        string.format(
            'while [ ! -f "%s" ]; do sleep 1; done; zathura %s',
            pdf,
            pdf
        )
    )
    if zathura_id > 0 then
        vim.g.zathura_id = zathura_id
    end
end

vim.keymap.set('n', '<leader>z', typst_preview, {})

vim.api.nvim_create_user_command('TypstWatch', function(opts)
    local file = opts.fargs[1] or vim.fn.expand('%:p')
    typst_watch(file)
end, { nargs = '?', complete = 'file' })

vim.api.nvim_create_user_command('TypstStop', typst_stop, {})
vim.api.nvim_create_user_command('TypstPreview', typst_preview, {})

vim.bo.commentstring = '// %s'
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

vim.o.spell = true
vim.bo.spelllang = "en_uk"
