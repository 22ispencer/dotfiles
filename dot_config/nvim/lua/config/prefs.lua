-- general settings
vim.opt.relativenumber = true
-- code keybinds
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "perform code action" })
vim.keymap.set("n", "<leader>cd", "<C-w>d", { desc = "show diagnostics" })
