return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})
		require("telescope").load_extension("ui-select")
	end,
	keys = {
		{ "<leader>ff",       require("telescope.builtin").find_files },
		{ "<leader>fg",       require("telescope.builtin").live_grep },
		{ "<leader><leader>", require("telescope.builtin").buffers },
		{ "<leader>fh",       require("telescope.builtin").help_tags },
	},
}
