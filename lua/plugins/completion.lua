local function is_dap_buffer()
    return require('cmp_dap').is_dap_buffer()
end

return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            -- filetypes = {
            --     markdown = true,
            --     help = true,
            -- },
        },
    },
    {
        'saghen/blink.compat',
        version = '1.*',
        lazy = true,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        lazy = false, -- Lazy loading handled internally
        dependencies = {
            'rafamadriz/friendly-snippets',
            'rcarriga/cmp-dap',
            {
                'L3MON4D3/LuaSnip',
                build = not vim.g.is_windows
                        and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
                    or nil,
                config = function()
                    require('luasnip').config.set_config({
                        enable_autosnippets = true,
                    })
                    require('luasnip.loaders.from_lua').lazy_load({
                        paths = { '~/.config/nvim/snippets/' },
                    })
                end,
            },
        },

        -- Use a release tag to download pre-built binaries
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'super-tab',
                ['<Tab>'] = {
                    'select_and_accept',
                    function(cmp)
                        if vim.bo.filetype == 'dap-repl' then
                            cmp.show()
                            return true
                        else
                            return false
                        end
                    end,
                    'fallback',
                },
                ['<C-l>'] = { 'snippet_forward' },
                ['<C-h>'] = { 'snippet_backward' },
            },
            cmdline = {
                enabled = false,
                keymap = {
                    preset = 'super-tab',
                    ['<Tab>'] = {
                        'select_and_accept',
                        function(cmp)
                            cmp.show()
                        end,
                    },
                },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },

            snippets = {
                expand = function(snippet)
                    require('luasnip').lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require('luasnip').jumpable(filter.direction)
                    end
                    return require('luasnip').in_snippet()
                end,
                jump = function(direction)
                    require('luasnip').jump(direction)
                end,
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`

            enabled = function()
                return vim.bo.buftype ~= 'prompt' or is_dap_buffer()
            end,
            sources = {
                -- https://github.com/Saghen/blink.compat/issues/23#issuecomment-2563890260
                default = function()
                    if is_dap_buffer() then
                        return { 'dap', 'snippets', 'buffer' }
                    else
                        return { 'lsp', 'path', 'snippets', 'buffer' }
                    end
                end,
                providers = {
                    path = {
                        opts = {
                            get_cwd = function()
                                return vim.fn.getcwd()
                            end,
                        },
                    },
                    dap = { name = 'dap', module = 'blink.compat.source' },
                    buffer = {
                        name = 'Buffer',
                        transform_items = function(a, items)
                            if vim.bo[a.bufnr].filetype ~= 'typst' then
                                return items
                            end

                            -- keep case of first char
                            local keyword = a.get_keyword()
                            local correct, case
                            if keyword:match('^%l') then
                                correct = '^%u%l+$'
                                case = string.lower
                            elseif keyword:match('^%u') then
                                correct = '^%l+$'
                                case = string.upper
                            else
                                return items
                            end

                            -- avoid duplicates from the corrections
                            local seen = {}
                            local out = {}
                            for _, item in ipairs(items) do
                                local raw = item.insertText
                                if raw and raw:match(correct) then
                                    local text = case(raw:sub(1, 1))
                                        .. raw:sub(2)
                                    item.insertText = text
                                    item.label = text
                                end
                                if not seen[item.insertText] then
                                    seen[item.insertText] = true
                                    table.insert(out, item)
                                end
                            end
                            return out
                        end,
                    },
                },
            },

            completion = {
                accept = { auto_brackets = { enabled = true } },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                },
                menu = { draw = { treesitter = { 'lsp' } } },
                -- ghost_text = { enabled = true },
                list = {
                    selection = {
                        auto_insert = false,
                        preselect = true,
                    },
                    cycle = {
                        from_bottom = false,
                        from_top = false,
                    },
                },
            },

            signature = { enabled = true },
        },
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim', branch = 'master' },
        },
        -- build = 'make tiktoken',
        opts = {
            -- See Configuration section for options
        },
    },
}
