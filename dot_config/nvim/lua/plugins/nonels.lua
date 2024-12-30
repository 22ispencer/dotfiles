local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
return {
	{
		"nvimtools/none-ls.nvim",
		opts = {
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
		},
		keys = {
			{ "<leader>cf", function() vim.lsp.buf.format({ async = false }) end }
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		opts = {},
		lazy = false
	}
}
