-- Change commentstring from default "/* %s */" to "// %s"
-- For C++, C, header files and C# files
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'c', 'cpp', 'cuda', 'csharp', 'openscad' },
    callback = function()
        vim.bo.commentstring = '// %s'
    end,
})
