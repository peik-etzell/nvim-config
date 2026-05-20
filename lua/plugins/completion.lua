-- local function is_dap_buffer()
--     return require('cmp_dap').is_dap_buffer()
-- end

vim.pack.add({
    {
        src = 'https://github.com/saghen/blink.cmp',
        version = vim.version.range('v1.*'),
    },
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/L3MON4D3/LuaSnip',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/Bilal2453/luvit-meta',
})

require('lazydev').setup({
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
})

require('luasnip').config.set_config({
    enable_autosnippets = true,
})
require('luasnip.loaders.from_lua').lazy_load({
    paths = { '~/.config/nvim/snippets/' },
})

require('blink.cmp').setup({
    keymap = {
        preset = 'super-tab',
        -- ['<Tab>'] = {
        --     'select_and_accept',
        --     function(cmp)
        --         if vim.bo.filetype == 'dap-repl' then
        --             cmp.show()
        --             return true
        --         else
        --             return false
        --         end
        --     end,
        --     'fallback',
        -- },
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
    sources = {
        default = { 'lsp', 'path', 'snippets' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
            path = {
                opts = {
                    get_cwd = function()
                        return vim.fn.getcwd()
                    end,
                },
            },
            snippets = { name = 'Snippets', score_offset = -2 },
            lsp = {
                async = false,
                fallbacks = { 'buffer' },
            },
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
                            local text = case(raw:sub(1, 1)) .. raw:sub(2)
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
})
