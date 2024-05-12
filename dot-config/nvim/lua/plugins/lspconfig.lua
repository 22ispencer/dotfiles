return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.gopls.setup{}
        lspconfig.lua_ls.setup{
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }
        lspconfig.gleam.setup{}
    end,
}
