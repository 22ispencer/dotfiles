return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 200
	end,
	opts = {},
	config = function()
		local builtin = require("telescope.builtin")
		require("which-key").register{
			["<leader>"] = {
				["<leader>"] = { "<cmd>Telescope find_files<cr>", "Find File" },
			},
		}
	end
}
