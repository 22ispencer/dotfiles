local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- General vim settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = ""
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed,unnamedplus"
vim.g.mapleader = "<Space>"

-- Lazy plugins
require("lazy").setup({
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			local modules = {
				"ai",
				"files",
				"indentscope",
				"jump",
				"notify",
				"pairs",
				"starter",
				"statusline",
				"surround",
				"tabline",
				"trailspace",
			}

			for _, module in ipairs(modules) do
				require("mini." .. module).setup({})
			end
		end,
	},
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			vim.g.sonokai_enable_italic = true
			vim.g.sonokai_style = "shusia"
			vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})


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
                            Lua = {}
                        }
					})
				end,
			})
            vim.lsp.handlers["textDocument/diagnostic"] = vim.lsp.with(
                vim.lsp.diagnostic.on_diagnostic, {
                    underline = true,
                    virtual_text = {
                        spacing = 4,
                    },
                    signs = false
                }
            )
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
			handlers = {},
		},
	},
})
