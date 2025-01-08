# Isaac's Neovim Config

My current Neovim config uses [lazy.nvim](https://lazy.folke.io/) as a package
manager.

## Notable Packages

- [mini.nvim](https://github.com/echasnovski/mini.nvim) ([config](lua/plugins/mini.lua))
- [snacks.nvim](https://github.com/folke/snacks.nvim) ([config](lua/plugins/snacks.lua))
- [LSP](lua/plugins/lsp.lua) & [Formatting](lua/plugins/formatting.lua)
  - [lspconfig](https://github.com/neovim/nvim-lspconfig) (auto-setup of
    language servers)
  - [none-ls](https://github.com/nvimtools/none-ls.nvim)
  - [mason](https://github.com/williamboman/mason.nvim) (installing language
    servers & formatters)
    - [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)
    - [mason-null-ls](https://github.com/jay-babu/mason-null-ls.nvim)
- [telescope](https://github.com/nvim-telescope/telescope.nvim) ([config](lua/plugins/telescope.lua))
- [which-key](https://github.com/folke/which-key.nvim) ([config](lua/plugins/which.lua))
- [sonokai](https://github.com/sainnhe/sonokai) - my choice of color scheme
  sonokai-shusia
