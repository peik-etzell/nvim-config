local function call_clang_format()
    local indent = vim.system({
        'clang-format',
        '-dump-config',
        '|',
        'grep',
        '^IndentWidth:',
        '|',
        'awk',
        '{print $2}',
    }, { detach = true })

    local indent_width = tonumber(indent)
    vim.opt_local.softtabstop = indent_width
    vim.opt_local.shiftwidth = indent_width

    local columns = vim.system({
        'clang-format',
        '-dump-config',
        '|',
        'grep',
        '^ColumnLimit:',
        '|',
        'awk',
        '{print $2}',
    }, { detach = true })

    vim.opt_local.colorcolumn = columns
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'c', 'cpp', 'cuda' },
    callback = function(_)
        pcall(call_clang_format)
    end,
})
