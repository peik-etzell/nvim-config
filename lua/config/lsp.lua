local function indent_pure_vim()
    local cursor_pos = vim.fn.getcurpos()
    vim.cmd.normal('gg=G')
    vim.fn.setpos('.', cursor_pos)
end

vim.diagnostic.config({ virtual_text = false, severity_sort = true })

vim.lsp.config('*', {
    root_markers = { '.git' },
})

vim.lsp.enable({
    'asm_lsp',
    'autotools_ls',
    'bashls',
    'clangd',
    'neocmake',
    'cssls',
    'denols',
    'docker_compose_language_service',
    'dockerls',
    'elmls',
    'eslint',
    'fish_lsp',
    'html',
    'json',
    'jsonls',
    'lemminx',
    'lua_ls',
    'marksman',
    'nil_ls',
    'openscad_lsp',
    'postgres_lsp',
    'basedpyright',
    'slangd',
    'superhtml',
    'svelte',
    'texlab',
    'tinymist',
    'yamlls',
    'zls',
    -- 'basedpyright',
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP on_attach',
    callback = function(event)
        local function nmap(lhs, rhs, desc)
            vim.keymap.set(
                'n',
                lhs,
                rhs,
                { silent = true, buffer = event.buf, desc = desc }
            )
        end
        nmap('<C-S-k>', vim.lsp.buf.signature_help, 'Signature help')
        nmap('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
        nmap('K', function()
            -- if require('dap').status() ~= '' then
            --     require('dapui').eval()
            -- else
            vim.lsp.buf.hover({
                close_events = {
                    'CursorMoved',
                    'BufLeave',
                    'WinLeave',
                    'FocusLost',
                    'CmdlineEnter',
                },
            })
            -- end
        end, 'Symbol information')

        nmap('gt', vim.lsp.buf.type_definition, 'Goto type definition')
        nmap('grr', vim.lsp.buf.references, 'List references')
        nmap('gd', vim.lsp.buf.definition, 'Goto definition')
        nmap('gi', vim.lsp.buf.implementation, 'Goto implementation')
        nmap('<tab>', vim.lsp.buf.code_action, 'Code action')
    end,
})
