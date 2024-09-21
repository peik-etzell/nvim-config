-- Change commentstring from default "/* %s */" to "// %s"
-- For C++, C, header files and C# files
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePost' }, {
    pattern = { '*.c', '*.cpp', '*.h', '*.hpp', '*.cs', '*.scad' },
    callback = function()
        vim.bo.commentstring = '// %s'
    end,
})
