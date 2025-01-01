return {
	"neovim/nvim-lspconfig",
	{
		"williamboman/mason-lspconfig",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup_handlers({

				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						on_init = function(client)
							if client.workspace_folders then
								local path = client.workspace_folders[1].name
								if
										vim.loop.fs_stat(path .. "/.luarc.json")
										or vim.loop.fs_stat(path .. "/.luarc.jsonc")
								then
									return
								end
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
									-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
									-- library = vim.api.nvim_get_runtime_file("", true)
								},
							})
						end,
						settings = {
							Lua = {},
						},
					})
				end,
				elixirls = function()
					require("lspconfig").elixirls.setup({
						filetypes = { "elixir", "eelixir", "heex", "surface" },
						root_dir = require("lspconfig").util.root_pattern("mix.exs", ".git") or vim.loop.os_homedir(),
						cmd = { "elixir-ls" },
					})
				end,
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,
	},
}
