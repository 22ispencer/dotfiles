-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set up both the traditional leader (for keymaps) as well as the local leader (for norg files)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.infercase = true

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"sainnhe/sonokai",
			lazy = false,
			priority = 1000,
			config = function()
				-- Optionally configure and load the colorscheme
				-- directly inside the plugin declaration.
				vim.g.sonokai_enable_italic = true
				vim.g.sonokai_style = "shusia"
				vim.cmd.colorscheme("sonokai")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			opts = {
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				highlight = { enable = true },
			},
			config = function(_, opts)
				require("nvim-treesitter.configs").setup(opts)
			end,
		},
		{
			"nvim-neorg/neorg",
			lazy = false,
			version = "*",
			config = function()
				require("neorg").setup({
					load = {
						["core.defaults"] = {},
						["core.concealer"] = {},
						["core.dirman"] = {
							config = {
								workspaces = {
									notes = "~/notes",
								},
								default_workspace = "notes",
							},
						},
						["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
						["core.qol.toc"] = {},
						["core.qol.todo_items"] = {},
						["core.looking-glass"] = {},
						["core.export"] = {},
						["core.export.markdown"] = { config = { extensions = "all" } },
						["core.summary"] = {},
						["core.tangle"] = { config = { report_on_empty = false } },
						["core.ui.calendar"] = {},
						["core.journal"] = {
							config = {
								strategy = "flat",
								workspace = "Notes",
							},
						},
					},
				})

				vim.wo.foldlevel = 99
				vim.wo.conceallevel = 2
			end,
		},
	},
})
