return {
	{ "echasnovski/mini.ai", version = false, opts = {} },
	{
		"echasnovski/mini.basics",
		version = false,
		opts = {

			mappings = {
				move_with_alt = true,
			},
		},
	},
	{ "echasnovski/mini.bracketed", version = false, opts = {} },
	{
		"echasnovski/mini.completion",
		version = false,
		opts = {},
		lazy = false,
		keys = {
			{ "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], mode = "i", expr = true },
			{ "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], mode = "i", expr = true },
		},
	},
	{ "echasnovski/mini.cursorword", version = false, opts = {} },
	{ "echasnovski/mini.diff", version = false, opts = {} },
	{
		"echasnovski/mini.files",
		version = false,
		opts = {},
		keys = {
			{
				"<leader>e",
				function()
					MiniFiles.open()
				end,
				desc = "file explorer",
			},
		},
	},
	{ "echasnovski/mini.icons", version = false, opts = {} },
	{ "echasnovski/mini.jump", version = false, opts = {} },
	{ "echasnovski/mini.jump2d", version = false, opts = {} },
	{ "echasnovski/mini.pairs", version = false, opts = {} },
	{ "echasnovski/mini.sessions", version = false, opts = {} },
	{
		"echasnovski/mini.snippets",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = false,
		config = function()
			local gen_loader = require("mini.snippets").gen_loader
			require("mini.snippets").setup({
				snippets = {
					gen_loader.from_lang(),
				},
			})
		end,
	},
	{ "echasnovski/mini.surround", version = false, opts = {} },
	{ "echasnovski/mini.tabline", version = false, opts = {} },
	{
		"echasnovski/mini.trailspace",
		version = false,
		opts = {},
		keys = {
			{
				"<leader>ct",
				function()
					MiniTrailspace.trim()
				end,
				desc = "remove trailing spaces",
			},
		},
	},
}
