-- General vim settings
vim.g.mapleader = " "
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

vim.keymap.set("n", "<Leader>cl", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Expand LSP diagnostics" })
vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "Open code actions" })

-- Change split with leader
vim.keymap.set("n", "<Leader>wh", "<C-w>h", { desc = "Left" })
vim.keymap.set("n", "<Leader>wl", "<C-w>l", { desc = "Right" })
vim.keymap.set("n", "<Leader>wj", "<C-w>j", { desc = "Down" })
vim.keymap.set("n", "<Leader>wk", "<C-w>k", { desc = "Up" })

vim.keymap.set("n", "d/", "<cmd>noh<cr>", { desc = "Clear highlight" })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
