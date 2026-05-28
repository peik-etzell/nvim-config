vim.pack.add({
    {
        src = 'https://github.com/williamboman/mason.nvim',
    },
})

local ensure_installed = {
    'asm-lsp',
    'autotools-language-server',
    'bash-language-server',
    'black',
    'buf',
    'clang-format',
    'clangd',
    'css-lsp',
    'deno',
    'docker-compose-language-service',
    'docker-language-server',
    'eslint-lsp',
    'html-lsp',
    'json-lsp',
    'lemminx',
    'lua-language-server',
    'marksman',
    'neocmakelsp',
    'netcoredbg',
    'powershell-editor-services',
    'prettier',
    'shfmt',
    'slang',
    'stylua',
    'superhtml',
    'tree-sitter-cli',
    'yaml-language-server',
}

require('mason').setup({
    registries = {
        -- 'file:' .. vim.fn.stdpath('config'),
        'github:mason-org/mason-registry',
    },
})

vim.api.nvim_create_user_command('MasonInstallAll', function()
    require('mason-registry').update()
    for _, pkg_name in ipairs(ensure_installed) do
        local pkg = require('mason-registry').get_package(pkg_name)
        if not pkg:is_installed() then
            vim.cmd('MasonInstall ' .. pkg_name)
        end
    end
end, {})
