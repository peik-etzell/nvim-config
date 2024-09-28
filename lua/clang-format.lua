local pattern = { '*.c', '*.cpp', '*.h', '*.hpp', '.cc' }

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = pattern,
    callback = function(_)
        local indent_handle = io.popen(
            "clang-format -dump-config | grep ^IndentWidth: | awk '{print $2}'"
        )
        if indent_handle then
            local indent_width = tonumber(indent_handle:read('*a'))
            indent_handle:close()
            vim.opt_local.tabstop = indent_width
            vim.opt_local.shiftwidth = indent_width
        end

        local column_handle = io.popen(
            "clang-format -dump-config | grep ^ColumnLimit: | awk '{print $2}'"
        )
        if column_handle then
            local columns = tonumber(column_handle:read('*a'))
            column_handle:close()
            vim.opt_local.colorcolumn = string.format('%d', columns)
        end
    end,
})
