return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build =
			"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("fzf")
	end,
	keys = {
		{ "<leader>ff",       require("telescope.builtin").find_files },
		{ "<leader>fg",       require("telescope.builtin").live_grep },
		{ "<leader><leader>", require("telescope.builtin").buffers },
		{ "<leader>fh",       require("telescope.builtin").help_tags },
	},
}
