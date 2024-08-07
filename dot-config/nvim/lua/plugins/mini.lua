return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		local modules = {
			"ai",
			{
				"basics",
				opts = {
					mappings = {
						windows = true,
					},
				},
			},
			{
				"clue",
				opts = {
					triggers = {
						-- Leader triggers
						{ mode = "n", keys = "<Leader>" },
						{ mode = "x", keys = "<Leader>" },

						-- Built-in completion
						{ mode = "i", keys = "<C-x>" },

						-- `g` key
						{ mode = "n", keys = "g" },
						{ mode = "x", keys = "g" },

						-- Marks
						{ mode = "n", keys = "'" },
						{ mode = "n", keys = "`" },
						{ mode = "x", keys = "'" },
						{ mode = "x", keys = "`" },

						-- Registers
						{ mode = "n", keys = '"' },
						{ mode = "x", keys = '"' },
						{ mode = "i", keys = "<C-r>" },
						{ mode = "c", keys = "<C-r>" },

						-- Window commands
						{ mode = "n", keys = "<C-w>" },

						-- `z` key
						{ mode = "n", keys = "z" },
						{ mode = "x", keys = "z" },
					},

					clues = {
						-- Enhance this by adding descriptions for <Leader> mapping groups
						require("mini.clue").gen_clues.builtin_completion(),
						require("mini.clue").gen_clues.g(),
						require("mini.clue").gen_clues.marks(),
						require("mini.clue").gen_clues.registers(),
						require("mini.clue").gen_clues.windows(),
						require("mini.clue").gen_clues.z(),
						{ mode = "n", keys = "<Leader>f", desc = "+Find" },
						{ mode = "n", keys = "<Leader>c", desc = "+Code" },
						{ mode = "n", keys = "<Leader>w", desc = "+Window" },
						{ mode = "n", keys = "<Leader>d", desc = "+Debug" },
						{ mode = "n", keys = "<Leader>s", desc = "+Sessions" },
					},
					window = {
						config = { width = "auto" },
					},
				},
			},
			"cursorword",
			{ "files", keys = { { "<Leader>fe", "<cmd>lua MiniFiles.open()<cr>", desc = "File Explorer" } } },
			"indentscope",
			"jump",
			"jump2d",
			"notify",
			"pairs",
			{
				"sessions",
				opts = {
					force = {
						delete = true,
					},
				},
				keys = {
					{ "<Leader>fs", "<cmd>lua MiniSessions.select()<cr>", desc = "Sessions" },
					{
						"<Leader>sg",
						function()
							local session_name
							vim.ui.input({ prompt = "Session name: " }, function(input)
								session_name = input
							end)
							MiniSessions.write(session_name)
						end,
						desc = "Save globally",
					},
					{ "<Leader>sl", "<cmd>lua MiniSessions.write('Session.vim')<cr>", desc = "Save locally" },
					{
						"<Leader>sd",
						"<cmd>lua MiniSessions.select('delete')<cr>",
						desc = "Delete session",
					},
				},
			},
			{
				"starter",
				opts = {
					items = {
						require("mini.starter").sections.sessions(),
						require("mini.starter").sections.recent_files(5, true),
						require("mini.starter").sections.recent_files(5, false),
						require("mini.starter").sections.builtin_actions(),
					},
				},
			},
			"statusline",
			"surround",
			"tabline",
			"trailspace",
		}

		for _, module in ipairs(modules) do
			local mod_name = nil
			local opts = {}
			if type(module) == "table" then
				mod_name = module[1]
				opts = module["opts"] or {}
				if type(module["keys"]) == "table" then
					for _, v in pairs(module["keys"]) do
						vim.keymap.set(v["mode"] or "n", v[1], v[2], { desc = v["desc"] })
					end
				end
			else
				mod_name = module
			end
			require("mini." .. mod_name).setup(opts)
		end
	end,
}
