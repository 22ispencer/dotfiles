---@diagnostic disable: undefined-global
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })
---@type function, function, function
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- vim options
vim.opt.cindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.foldmethod = "syntax"
vim.opt.signcolumn = "yes:2"
vim.opt.iskeyword:append("-")
vim.opt.wrap = false
vim.g.mapleader = " "
vim.keymap.set("n", "U", "<C-r>")
vim.keymap.set("n", "<Leader>qq", function()
	local is_saved = true
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buf, "modified") then
			is_saved = false
		end
	end
	if is_saved then
		vim.cmd.qa()
	end
	while true do
		vim.ui.input({ prompt = "There are unsaved buffers, would you like to write them (y/n)?: " }, function(input)
			if input:lower() == "y" then
				vim.cmd.wqa()
			elseif input:lower() == "n" then
				vim.notify("You must finish editing before quitting")
				return
			end
		end)
	end
end, { desc = "Quit" })
vim.keymap.set("n", "<Leader>wd", "<C-w>c")
vim.keymap.set("n", "<Leader>wn", "<C-w>n")

if not vim.g.vscode then
	now(function()
		add("sainnhe/sonokai")
		vim.opt.termguicolors = true
		vim.g.sonokai_enable_italic = true
		vim.g.sonokai_style = "shusia"
		vim.g.sonokai_better_performance = 1
		vim.cmd.colorscheme("sonokai")
		require("mini.sessions").setup()
		local starter = require("mini.starter")
		starter.setup({
			autoopen = false,
			items = {
				starter.sections.sessions(),
				starter.sections.recent_files(5, true),
				starter.sections.recent_files(5, false),
				starter.sections.builtin_actions(),
			},
		})
		require("mini.icons").setup()
		require("mini.statusline").setup()
		require("mini.tabline").setup()

		add({
			source = "nvim-treesitter/nvim-treesitter",
			-- Use 'master' while monitoring updates in 'main'
			checkout = "master",
			monitor = "main",
			-- Perform action after every checkout
			hooks = {
				post_checkout = function()
					vim.cmd("TSUpdate")
				end,
			},
		})
		-- Possible to immediately execute code which depends on the added plugin
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "vimdoc", "typescript", "css", "html", "astro", "markdown", "markdown_inline" },
			highlight = { enable = true },
		})

		-- nvim-lspconfig
		add("neovim/nvim-lspconfig")
		local lspconfig = require("lspconfig")
		lspconfig.gleam.setup({})

		-- mason
		add("williamboman/mason.nvim")
		require("mason").setup({
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		})

		-- mason-lspconfig
		add({
			source = "williamboman/mason-lspconfig.nvim",
			depends = {
				"williamboman/mason.nvim",
				"neovim/nvim-lspconfig",
				"hrsh7th/nvim-cmp",
				"hrsh7th/cmp-nvim-lsp",
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"gopls",
				"pyright",
				"ts_ls",
				"tailwindcss",
				"clangd",
				"html",
				"lua_ls",
				"marksman",
				"matlab_ls",
			},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				require("lspconfig").lua_ls.setup({
					on_init = function(client)
						if client.workspace_folders == nil then
							return
						end
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
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
						Lua = {},
					},
				})
			end,
		})
		vim.lsp.handlers["textDocument/diagnostic"] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
			underline = true,
			virtual_text = {
				spacing = 4,
			},
			signs = false,
		})

		vim.api.nvim_create_autocmd({ "VimEnter" }, {
			callback = function()
				local cwd = vim.fn.getcwd()
				if vim.fn.argc() > 0 then
					return
				end
				if vim.fn.filereadable(cwd .. "/Session.vim") == 1 then
					MiniSessions.read(nil, {
						force = true,
					})
				else
					MiniStarter.open()
				end
			end,
			nested = true,
			once = true,
		})
	end)
	now(function()
		add({
			source = "OXY2DEV/markview.nvim",
			depends = { "nvim-treesitter/nvim-treesitter" },
		})
	end)
	later(function()
		local miniclue = require("mini.clue")
		miniclue.setup({
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

				-- `[` & `]` clues
				{ mode = "n", keys = "[" },
				{ mode = "n", keys = "]" },
			},

			clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
				{ mode = "n", keys = "<Leader>q", desc = "+Neovim" },
				{ mode = "n", keys = "<Leader>f", desc = "+Find" },
				{ mode = "n", keys = "<Leader>s", desc = "+Sessions" },
				{ mode = "n", keys = "<Leader>c", desc = "+Code" },
				{ mode = "n", keys = "<Leader>d", desc = "+Debug" },
				{ mode = "n", keys = "<Leader>cl", desc = "+LSP" },
			},
		})
		require("mini.files").setup()
		vim.keymap.set("n", "<Leader>e", function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0))
		end, { desc = "File Explorer" })
		require("mini.cursorword").setup()
		require("mini.fuzzy").setup()
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
		require("mini.indentscope").setup()
		require("mini.notify").setup()
		require("mini.pick").setup()
		vim.keymap.set("n", "<Leader><Leader>", function()
			MiniPick.builtin.buffers({ include_current = false })
		end, { desc = "Buffer" })
		vim.keymap.set("n", "<Leader>ff", function()
			MiniPick.builtin.files({ tool = "fd" })
		end, { desc = "File" })
		vim.keymap.set("n", "<Leader>fh", function()
			MiniPick.builtin.help({ tool = "fd" })
		end, { desc = "Help" })
		vim.keymap.set("n", "<Leader>fg", function()
			MiniPick.builtin.grep_live({ tool = "rg" })
		end, { desc = "Grep" })
		-- Use mini.pick as a vim.ui.select replacement
		vim.ui.select = MiniPick.ui_select
		-- mini.sessions
		vim.keymap.set("n", "<Leader>fs", MiniSessions.select, { desc = "Session" })
		vim.keymap.set("n", "<Leader>sg", function()
			vim.ui.input(
				{ prompt = "Enter session name: " },
				---@param sessionName string
				function(sessionName)
					if sessionName ~= nil then
						MiniSessions.write(sessionName)
					else
						vim.notify("Canceled")
					end
				end
			)
		end, { desc = "Save (Global)" })
		vim.keymap.set("n", "<Leader>sl", function()
			MiniSessions.write("Session.vim")
		end, { desc = "Save (Local)" })
		vim.keymap.set("n", "<Leader>sd", function()
			MiniSessions.select("delete")
		end, { desc = "Delete" })
	end)
	later(function()
		add("christoomey/vim-tmux-navigator")
		vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
		vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
		vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
		vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
		vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")
	end)

	later(function()
		vim.keymap.set("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Expand LSP diagnostics" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Expand LSP diagnostics" })
		vim.keymap.set("n", "<Leader>cn", vim.diagnostic.goto_next, { desc = "Next Error" })
		vim.keymap.set("n", "<Leader>cp", vim.diagnostic.goto_prev, { desc = "Prev Error" })
		vim.keymap.set("n", "<leader>cf", function()
			vim.lsp.buf.format({ timeout_ms = 5000 })
		end, { desc = "Format buffer" })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
		vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Open code actions" })
		vim.keymap.set("n", "<Leader>cli", "<cmd>LspInfo<cr>", { desc = "Info" })
		vim.keymap.set("n", "<Leader>clr", "<cmd>LspRestart<cr>", { desc = "Restart" })
	end)

	later(function()
		add({ source = "nvimtools/none-ls.nvim", depends = { "nvim-lua/plenary.nvim" } })
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.prettier.with({
					timeout = 100000,
				}),
			},
			-- you can reuse a shared lspconfig on_attach callback here
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
	end)

	later(function()
		add({
			source = "jay-babu/mason-null-ls.nvim",
			depends = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
		})
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"gofumpt",
				"ruff",
				"black",
				"clang-format",
			},
			handlers = {},
		})
	end)

	later(function()
		add("mfussenegger/nvim-lint")
		local lint = require("lint")

		local gfortran_diagnostic_args = { "-Wall", "-Wextra", "-fmax-errors=5" }

		lint.linters_by_ft = {
			fortran = {
				"gfortran",
			},
		}

		local pattern = "^([^:]+):(%d+):(%d+):%s+([^:]+):%s+(.*)$"
		local groups = { "file", "lnum", "col", "severity", "message" }
		local severity_map = {
			["Error"] = vim.diagnostic.severity.ERROR,
			["Warning"] = vim.diagnostic.severity.WARN,
		}
		local defaults = { ["source"] = "gfortran" }

		local required_args = { "-fsyntax-only", "-fdiagnostics-plain-output" }
		local args = vim.list_extend(required_args, gfortran_diagnostic_args)

		lint.linters.gfortran = {
			cmd = "gfortran",
			stdin = false,
			append_fname = true,
			stream = "stderr",
			env = nil,
			args = args,
			ignore_exitcode = true,
			parser = require("lint.parser").from_pattern(pattern, groups, severity_map, defaults),
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end)

	later(function()
		add("edkolev/tmuxline.vim")
	end)

	later(function()
		add("mfussenegger/nvim-dap")

		local dap = require("dap")

		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "continue" })
		vim.keymap.set("n", "<leader>do", function()
			dap.step_over()
		end, { desc = "over" })
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, { desc = "into" })
		vim.keymap.set("n", "<leader>dO", function()
			dap.step_out()
		end, { desc = "out" })
		vim.keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "toggle breakpoint" })

		add("mfussenegger/nvim-dap-python")
		require("dap-python").setup(os.getenv("HOME") .. "/.virtualenvs/debugpy/bin/python")
	end)
end

later(function()
	require("mini.ai").setup()
	require("mini.align").setup()
	require("mini.basics").setup({
		options = {
			extra_ui = not vim.g.vscode,
		},
		mappings = {
			move_with_alt = true,
		},
		silent = true,
	})
	require("mini.bracketed").setup()
	require("mini.comment").setup()
	require("mini.completion").setup()
	require("mini.git").setup()
	require("mini.jump").setup()
	require("mini.jump2d").setup()
	require("mini.misc").setup()
	require("mini.pairs").setup()
	require("mini.splitjoin").setup()
	require("mini.surround").setup()
	require("mini.trailspace").setup()
	vim.keymap.set("n", "<Leader>ct", MiniTrailspace.trim, { desc = "Trim trailing spaces" })
	require("mini.extra").setup()
	vim.keymap.set("n", "<Leader>fe", MiniExtra.pickers.diagnostic, { desc = "Error" })
	vim.keymap.set("n", "<Leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
end)

later(function()
	add("leafOfTree/vim-svelte-plugin")
end)
