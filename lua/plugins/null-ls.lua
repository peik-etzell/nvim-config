return {
    {
        'nvimtools/none-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = 'VeryLazy',
        config = function()
            local null_ls = require('null-ls')
            local builtins = null_ls.builtins
            local fmt = builtins.formatting
            local diagnostics = builtins.diagnostics
            local code_actions = builtins.code_actions
            null_ls.setup({
                sources = {
                    -- Lua
                    fmt.stylua,

                    -- JS/TS
                    fmt.prettierd,

                    -- Shell
                    fmt.shfmt,
                    diagnostics.zsh,

                    -- Protobuf
                    diagnostics.buf,
                    fmt.buf,

                    -- Python
                    -- diagnostics.pylint,
                    fmt.black,

                    diagnostics.statix,
                    code_actions.statix,
                    fmt.nixfmt,

                    code_actions.refactoring,
                    code_actions.gitsigns,
                    diagnostics.gitlint,
                    code_actions.proselint,
                    diagnostics.proselint,

                    -- Markdown
                    -- fmt.markdownlint,
                    diagnostics.markdownlint.with({
                        args = { '--disable MD013' },
                    }),
                    builtins.hover.dictionary,

                    builtins.formatting.typstyle,

                    -- C/C++ / CMake / Make
                    diagnostics.cppcheck,
                    fmt.clang_format,
                    diagnostics.cmake_lint,
                    fmt.cmake_format,
                },
            })
        end,
    },
}
