vim.g.use_mason = not vim.g.is_nixos

return {
    {
        enabled = vim.g.use_mason,
        event = 'VeryLazy',
        'williamboman/mason.nvim',
        config = function()
            local options = {
                registries = {
                    'file:' .. vim.fn.stdpath('config'),
                    'github:mason-org/mason-registry',
                },
                max_concurrent_installers = 10,
                ensure_installed = {
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
                    'shfmt',
                    'slang',
                    'stylua',
                    'superhtml',
                    'yaml-language-server',
                },
            }

            require('mason').setup(options)

            vim.api.nvim_create_user_command('MasonInstallAll', function()
                for _, pkg_name in ipairs(options.ensure_installed) do
                    local pkg = require('mason-registry').get_package(pkg_name)
                    if not pkg:is_installed() then
                        vim.cmd('MasonInstall ' .. pkg_name)
                    end
                end
            end, {})
        end,
    },
}
