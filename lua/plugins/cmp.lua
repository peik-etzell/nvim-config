return {
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        dependencies = {
            'rafamadriz/friendly-snippets',
            {
                'L3MON4D3/LuaSnip',
                build = (not jit.os:find('Windows'))
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

        -- use a release tag to download pre-built binaries
        version = 'v0.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'super-tab',
                ['<Tab>'] = { 'select_and_accept', 'fallback' },
                ['<C-l>'] = { 'snippet_forward' },
                ['<C-h>'] = { 'snippet_backward' },
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

            sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

            completion = {
                accept = { auto_brackets = { enabled = true } },
                menu = { draw = { treesitter = { 'lsp' } } },
                -- ghost_text = { enabled = true },
            },

            signature = { enabled = true },
        },
        -- allows extending the enabled_providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { 'sources.completion.enabled_providers' },
    },
}
