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
                    code_actions.eslint_d,

                    -- XML
                    fmt.xmlformat,

                    -- Tex
                    fmt.latexindent,
                    diagnostics.chktex,

                    -- Shell
                    fmt.shfmt,
                    diagnostics.shellcheck,
                    code_actions.shellcheck,
                    fmt.beautysh,
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

                    -- C/C++ / CMake / Make
                    -- diagnostics.clang_check,
                    diagnostics.cpplint.with({
                        args = { '--linelength=120' }, -- ROS
                    }),
                    diagnostics.cppcheck,
                    fmt.clang_format,
                    diagnostics.cmake_lint,
                    fmt.cmake_format,
                },
            })
        end,
    },
}
