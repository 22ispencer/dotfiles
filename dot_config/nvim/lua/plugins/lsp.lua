return {
	"williamboman/mason-lspconfig",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
	},
	init = function()
		vim.opt.signcolumn = "yes"
	end,
	config = function()
		-- LspAttach is where you enable features that only work
		-- if there is a language server active in the file
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }

				vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.keymap.set("n", "gY", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
				vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			end,
		})

		local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

		require("mason-lspconfig").setup_handlers({
			elixirls = function()
				require("lspconfig").elixirls.setup({
					filetypes = { "elixir", "eelixir", "heex", "surface" },
					root_dir = require("lspconfig").util.root_pattern("mix.exs", ".git") or vim.loop.os_homedir(),
					cmd = { "elixir-ls" },
				})
			end,
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
			denols = function()
				local lspconfig = require("lspconfig")
				lspconfig.denols.setup({
					root_dir = function(filename)
						return vim.fs.root(filename, { "deno.json", "deno.jsonc", "deno.lock" })
					end,
				})
			end,
			ts_ls = function()
				local lspconfig = require("lspconfig")
				lspconfig.ts_ls.setup({
					root_dir = function(filename)
						local deno_root = vim.fs.root(filename, { "deno.json", "deno.jsonc", "deno.lock" })
						if deno_root then
							return nil
						else
							return vim.fs.root(filename, { "package.json" })
						end
					end,
					single_file_support = false,
				})
			end,
			tailwindcss = function()
				require("lspconfig").tailwindcss.setup({
					on_attach = function(client, bufnr)
						vim.bo[bufnr].iskeyword = vim.bo[bufnr].iskeyword .. ",-"
					end,
				})
			end,
			function(server_name)
				require("lspconfig")[server_name].setup({
					on_attach = function(client, bufnr)
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = augroup,
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ async = false })
								end,
							})
						end
					end,
				})
			end,
		})
	end,
}
