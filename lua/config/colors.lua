local default = 'habamax'
local store_path = vim.fn.stdpath('state') .. '/colorscheme'

local function load()
    local f = io.open(store_path, 'r')
    if not f then
        vim.cmd.colorscheme(default)
        return
    end

    local stored = f:read('*a')
    f:close()

    if not stored then
        vim.cmd.colorscheme(default)
        return
    end

    vim.cmd.colorscheme(stored)
end

load()

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        local f = io.open(store_path, 'w')
        if f then
            f:write(vim.g.colors_name)
            f:close()
        end
    end,
})
