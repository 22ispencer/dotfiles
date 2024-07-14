return {
    {
        "williamboman/mason.nvim",
        opts = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.gleam.setup({})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "pyright",
                    "tsserver",
                    "tailwindcss",
                    "clangd",
                    "html",
                    "lua_ls",
                    "marksman",
                    "matlab_ls",
                },
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        on_init = function(client)
                            local path = client.workspace_folders[1].name
                            if
                                vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")
                            then
                                return
                            end

                            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {

                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = "LuaJIT",
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME,
                                        -- Depending on the usage, you might want to add additional paths here.
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    },
                                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                    -- library = vim.api.nvim_get_runtime_file("", true)
                                },
                            })
                        end,
                        settings = {
                            Lua = {},
                        },
                    })
                end,
            })
            vim.lsp.handlers["textDocument/diagnostic"] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
                underline = true,
                virtual_text = {
                    spacing = 4,
                },
                signs = false,
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            ensure_installed = {
                "prettier",
                "stylua",
                "gofumpt",
                "ruff",
                "black",
                "clang-format",
            },
            handlers = {
                -- prettier = function(source_name, methods)
                -- 	local null_ls = require("null-ls")
                -- 	null_ls.register(null_ls.builtins.formatting.prettier)
                -- end,
            },
        },
        keys = {
            { "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format buffer" },
            { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename symbol" },
        },
    },
}
