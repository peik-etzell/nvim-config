-- vim.api.nvim_create_autocmd('PackChanged', {
--     callback = function(ev)
--         local name, kind = ev.data.spec.name, ev.data.kind
--         if name == 'nvim-treesitter' and kind == 'update' then
--             if not ev.data.active then
--                 vim.cmd.packadd('nvim-treesitter')
--             end
--             vim.cmd('TSUpdate')
--         end
--     end,
-- })

vim.pack.add({
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
})

require('nvim-treesitter').setup()

local filetypes = {
    'bash',
    'c',
    'c_sharp',
    'cmake',
    'cpp',
    'gitcommit',
    'gitignore',
    'html',
    'javascript',
    'json',
    'lua',
    'make',
    'markdown',
    'nix',
    'proto',
    'python',
    'rust',
    'sql',
    'toml',
    'tsx',
    'typescript',
    'typst',
    'vim',
    'yaml',
    'zig',
}

require('nvim-treesitter').install(filetypes)

vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    callback = function()
        vim.treesitter.start()

        -- Folding
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'

        -- Indent
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
