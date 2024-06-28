local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- General vim settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = ""
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>cl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Move with Leader
vim.keymap.set("n", "md", "<C-d>", { desc = "Half page down" })
vim.keymap.set("n", "mu", "<C-u>", { desc = "Half page up" })
vim.keymap.set("n", "mf", "<C-f>", { desc = "Page down" })
vim.keymap.set("n", "mb", "<C-b>", { desc = "Page up" })

-- Change split with leader
vim.keymap.set("n", "<Leader>wh", "<C-w>h", { desc = "Left" })
vim.keymap.set("n", "<Leader>wl", "<C-w>l", { desc = "Right" })
vim.keymap.set("n", "<Leader>wj", "<C-w>j", { desc = "Down" })
vim.keymap.set("n", "<Leader>wk", "<C-w>k", { desc = "Up" })

vim.keymap.set("n", "d/", "<cmd>noh<cr>", { desc = "Clear highlight" })

-- Lazy plugins
require("lazy").setup({
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			local modules = {
				"ai",
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
							{ mode = "n", keys = "m", desc = "+Move" },
						},
					},
				},
				"files",
				"indentscope",
				"jump",
				"jump2d",
				"notify",
				"pairs",
				{ "starter",
                    opts = {
                        items = {
                            require("mini.starter").sections.recent_files(5, true),
                            require("mini.starter").sections.recent_files(5, false),
                            require("mini.starter").sections.builtin_actions(),
                        }
                    }
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
					opts = module["opts"]
				else
					mod_name = module
				end
				require("mini." .. mod_name).setup(opts)
			end
		end,
	},
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			vim.g.sonokai_enable_italic = true
			vim.g.sonokai_style = "shusia"
			vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason-lspconfig").setup({})

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
							local path = client.workspace_folders[1].name
							if
								vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")
							then
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
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		opts = {
			handlers = {},
		},
		keys = {
			{ "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format buffer" },
			{ "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename symbol" },
		},
	},
	{

		"saadparwaiz1/cmp_luasnip",
		dependencies = { "L3MON4D3/LuaSnip" },
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"elixir",
					"heex",
					"javascript",
					"html",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			-- This is your opts table
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
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
			{ "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"LukasPietzschmann/telescope-tabs",
		config = function()
			require("telescope").load_extension("telescope-tabs")
			require("telescope-tabs").setup({
				-- Your custom config :^)
			})
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>ft", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "Help" },
		},
	},
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = vim.fn.bufnr(),
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 3000 })
	end,
})

-- Keybinds
-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
