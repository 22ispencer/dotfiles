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

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	vim.g.mapleader = " "
	vim.o.shell = "pwsh"
	vim.o.backup = false
	vim.o.writebackup = false
	vim.o.undofile = true
	vim.o.mouse = "a"
	vim.o.cursorline = true
	vim.o.laststatus = 2
	vim.o.list = true
	vim.o.ruler = false
	vim.o.signcolumn = "yes"
	vim.o.splitbelow = true
	vim.o.splitright = true
	vim.o.termguicolors = true
	vim.o.background = "dark"
	vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
	vim.o.fillchars = table.concat({
		"eob: ",
		"fold:╌",
		"horiz:═",
		"horizdown:╦",
		"horizup:╩",
		"vert:║",
		"verthoriz:╬",
		"vertleft:╣",
		"vertright:╠",
	}, ",")
	vim.o.smartindent = true
	vim.o.autoindent = true
	vim.o.formatoptions = "rqnl1j"
	vim.o.shiftwidth = 4
	vim.o.tabstop = 4
	vim.o.expandtab = true
	vim.o.relativenumber = true
	vim.o.ignorecase = true
	vim.o.incsearch = true
	vim.o.infercase = true
	vim.o.scrolloff = 10
	vim.o.clipboard = "unnamed,unnamedplus"
	-- vim.opt.statuscolumn = '%=%{v:lnum}│%{v:relnum}'
	vim.opt.iskeyword:append("-")
	vim.opt.mouse = ""
	vim.o.spelllang = "de,en"
	vim.o.spelloptions = "camel"
	vim.opt.complete:append("kspell")
	vim.cmd("filetype plugin indent on")
	vim.cmd("colorscheme slate")
end)

later(function()
	require("mini.ai").setup()
end)
later(function()
	require("mini.align").setup()
end)
later(function()
	-- This is needed for mini.animate to work with mouse scrolling
	vim.opt.mousescroll = "ver:1,hor:1"
	local animate = require("mini.animate")
	animate.setup({
		scroll = {
			-- Disable Scroll Animations, as the can interfer with mouse Scrolling
			enable = false,
		},
		cursor = {
			timing = animate.gen_timing.cubic({ duration = 50, unit = "total" }),
		},
	})
end)
later(function()
	require("mini.basics").setup({
		options = {
			extra_ui = true,
			win_borders = "rounded",
		},
		mappings = {
			windows = true,
		},
	})
end)
later(function()
	require("mini.bracketed").setup()
end)
later(function()
	require("mini.bufremove").setup()
end)
later(function()
	require("mini.clue").setup({
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },
			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- `s` key
			{ mode = "n", keys = "s" },
			{ mode = "x", keys = "s" },

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
			{ mode = "n", keys = "<Leader>b", desc = " Buffer" },
			{ mode = "n", keys = "<Leader>c", desc = " Code" },
			{ mode = "n", keys = "<Leader>f", desc = " Find" },
			{ mode = "n", keys = "<Leader>g", desc = "󰊢 Git" },
			{ mode = "n", keys = "<Leader>i", desc = "󰏪 Insert" },
			{ mode = "n", keys = "<Leader>l", desc = "󰘦 LSP" },
			{ mode = "n", keys = "<Leader>q", desc = " NVim" },
			{ mode = "n", keys = "<Leader>s", desc = "󰆓 Session" },
			{ mode = "n", keys = "<Leader>u", desc = "󰔃 UI" },
			{ mode = "n", keys = "<Leader>w", desc = " Window" },
			function()
				MiniClue.gen_clues.g()
			end,
			function()
				MiniClue.gen_clues.builtin_completion()
			end,
			function()
				MiniClue.gen_clues.marks()
			end,
			function()
				MiniClue.gen_clues.registers()
			end,
			function()
				MiniClue.gen_clues.windows()
			end,
			function()
				MiniClue.gen_clues.z()
			end,
		},
		window = {
			delay = 300,
		},
	})
end)
later(function()
	require("mini.colors").setup()
end)
later(function()
	require("mini.comment").setup()
end)
-- later(function()
--     require("mini.completion").setup({
--         window = {
--             info = { border = "rounded" },
--             signature = { border = "rounded" },
--         },
--     })
-- end)
later(function()
	require("mini.cursorword").setup()
end)
later(function()
	require("mini.diff").setup()
end)
later(function()
	require("mini.doc").setup()
end)
later(function()
	require("mini.extra").setup()
end)
later(function()
	require("mini.files").setup({
		windows = {
			preview = true,
			width_preview = 80,
		},
		mappings = {
			go_out = "j",
			go_out_plus = "J",
		},
	})
end)
later(function()
	require("mini.fuzzy").setup()
end)
now(function()
	local hipatterns = require("mini.hipatterns")

	local censor_extmark_opts = function(_, match, _)
		local mask = string.rep("*", vim.fn.strchars(match))
		return {
			virt_text = { { mask, "Comment" } },
			virt_text_pos = "overlay",
			priority = 200,
			right_gravity = false,
		}
	end

	local password_table = {
		pattern = {
			"password: ()%S+()",
			"password_usr: ()%S+()",
		},
		group = "",
		extmark_opts = censor_extmark_opts,
	}

	hipatterns.setup({
		highlighters = {
			-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

			-- Cloaking Passwords
			pw = password_table,

			-- Highlight hex color strings (`#rrggbb`) using that color
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})

	vim.keymap.set("n", "<leader>up", function()
		if next(hipatterns.config.highlighters.pw) == nil then
			hipatterns.config.highlighters.pw = password_table
		else
			hipatterns.config.highlighters.pw = {}
		end
		vim.cmd("edit")
	end, { desc = "Toggle Password Cloaking" })
end)
-- We disable this, as we use our own Colorscheme through mini.colors
-- You can enable this by uncommenting
-- We Provide a Modus Vivendi inspired setup here
-- later(function() require('mini.hues').setup({ background = '#0d0e1c', foreground = '#feacd0' }) end)
later(function()
	require("mini.indentscope").setup({
		draw = {
			animation = function()
				return 1
			end,
		},
		symbol = "│",
	})
end)
later(function()
	require("mini.jump").setup()
end)
later(function()
	require("mini.jump2d").setup()
end)
later(function()
	require("mini.map").setup()
end)
later(function()
	require("mini.misc").setup()
end)
later(function()
	require("mini.move").setup({})
end)
later(function()
	-- We took this from echasnovski's personal configuration
	-- https://github.com/echasnovski/nvim/blob/master/init.lua
	local filterout_lua_diagnosing = function(notif_arr)
		local not_diagnosing = function(notif)
			return not vim.startswith(notif.msg, "lua_ls: Diagnosing")
		end
		notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
		return MiniNotify.default_sort(notif_arr)
	end
	require("mini.notify").setup({
		content = { sort = filterout_lua_diagnosing },
		window = { config = { border = "double" } },
	})
	-- vim.notify = MiniNotify.make_notify()
end)
later(function()
	require("mini.operators").setup()
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	local win_config = function()
		height = math.floor(0.618 * vim.o.lines)
		width = math.floor(0.618 * vim.o.columns)
		return {
			anchor = "NW",
			height = height,
			width = width,
			border = "rounded",
			row = math.floor(0.5 * (vim.o.lines - height)),
			col = math.floor(0.5 * (vim.o.columns - width)),
		}
	end
	require("mini.pick").setup({
		mappings = {
			choose_in_vsplit = "<C-CR>",
		},
		options = {
			use_cache = true,
		},
		window = {
			config = win_config,
		},
	})
	vim.ui.select = MiniPick.ui_select
end)
now(function()
	require("mini.sessions").setup({
		autowrite = true,
	})
end)
later(function()
	require("mini.splitjoin").setup()
end)
now(function()
	require("mini.starter").setup({
		autoopen = true,
		items = {
			require("mini.starter").sections.builtin_actions(),
			require("mini.starter").sections.recent_files(5, false),
			require("mini.starter").sections.recent_files(5, true),
			require("mini.starter").sections.sessions(5, true),
		},
		header = [[
                ███╗   ███╗██╗   ██╗██╗███╗   ███╗
                ████╗ ████║██║   ██║██║████╗ ████║
                ██╔████╔██║██║   ██║██║██╔████╔██║
                ██║╚██╔╝██║╚██╗ ██╔╝██║██║╚██╔╝██║
                ██║ ╚═╝ ██║ ╚████╔╝ ██║██║ ╚═╝ ██║
                ██║     ██║  ╚═══╝  ╚═╝██║     ██║
                ██║     ██║ini      nvi██║     ██║
                ╚═╝     ╚═╝            ╚═╝     ╚═╝]],
	})
end)
later(function()
	require("mini.statusline").setup({
		use_icons = true,
	})
end)
later(function()
	require("mini.surround").setup()
end)
later(function()
	require("mini.tabline").setup()
end)
later(function()
	require("mini.trailspace").setup()
end)
later(function()
	require("mini.visits").setup()
end)

later(function()
	add({
		source = "neovim/nvim-lspconfig",
		depends = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	})
	add("hrsh7th/cmp-nvim-lsp")
	add("hrsh7th/cmp-buffer")
	add("hrsh7th/cmp-path")
	add("hrsh7th/cmp-cmdline")
	add("hrsh7th/nvim-cmp")

	add({ source = "L3MON4D3/LuaSnip", checkout = "v2.3.0" })
	add("saadparwaiz1/cmp_luasnip")

	local luasnip = require("luasnip")
	local cmp = require("cmp")
	cmp.setup({
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})

	add({
		source = "nvimtools/none-ls.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
		},
	})
	require("mason").setup()
	require("mason-lspconfig").setup()
	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = {
					disable = { "lowercase-global", "undefined-global" },
				},
			},
		},
	})
	-- require("lspconfig").
	require("lspconfig").ansiblels.setup({})

	require("lspconfig").gopls.setup({})
	require("lspconfig").templ.setup({})

	require("lspconfig").tailwindcss.setup({})

	require("lspconfig").ruff_lsp.setup({})
	require("lspconfig").pyright.setup({})

	require("lspconfig").tsserver.setup({})
	require("lspconfig").eslint.setup({})

	require("lspconfig").omnisharp.setup({
		cmd = { [[C:\Users\isaac.spencer\Documents\omnisharp\OmniSharp.exe]] },
		settings = {
			FormattingOptions = {
				-- Enables support for reading code style, naming convention and analyzer
				-- settings from .editorconfig.
				EnableEditorConfigSupport = true,
				-- Specifies whether 'using' directives should be grouped and sorted during
				-- document formatting.
				OrganizeImports = nil,
			},
			MsBuild = {
				-- If true, MSBuild project system will only load projects for files that
				-- were opened in the editor. This setting is useful for big C# codebases
				-- and allows for faster initialization of code navigation features only
				-- for projects that are relevant to code that is being edited. With this
				-- setting enabled OmniSharp may load fewer projects and may thus display
				-- incomplete reference lists for symbols.
				LoadProjectsOnDemand = nil,
			},
			RoslynExtensionsOptions = {
				-- Enables support for roslyn analyzers, code fixes and rulesets.
				EnableAnalyzersSupport = nil,
				-- Enables support for showing unimported types and unimported extension
				-- methods in completion lists. When committed, the appropriate using
				-- directive will be added at the top of the current file. This option can
				-- have a negative impact on initial completion responsiveness,
				-- particularly for the first few completion sessions after opening a
				-- solution.
				EnableImportCompletion = nil,
				-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
				-- true
				AnalyzeOpenDocumentsOnly = nil,
			},
			Sdk = {
				-- Specifies whether to include preview versions of the .NET SDK when
				-- determining which version to use for project loading.
				IncludePrereleases = true,
			},
		},
	})
	-- require('lspconfig').yamlls.setup {}
	local null_ls = require("null-ls")
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
						-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
						vim.lsp.buf.format({ async = false })
					end,
				})
			end
		end,
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.gofumpt,
			null_ls.builtins.formatting.csharpier,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.rustywind.with({
				extra_filetypes = { "templ" },
			}),
		},
	})
end)

later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
	})
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "templ" },
		highlight = {
			enable = true,
		},
	})
end)

require("autocmds")
require("filetypes")
require("highlights")
require("keybinds")
