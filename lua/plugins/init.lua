require('plugins.picker')
require('plugins.format')
require('plugins.completion')
require('plugins.lsp')
require('plugins.autopairs')
require('plugins.treesitter')
require('plugins.comment-toggle')
require('plugins.schemastore')
require('plugins.sidebar')
require('plugins.auto-save')
require('plugins.git')

if not vim.g.is_nixos then
    require('plugins.mason')
end
