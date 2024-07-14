return {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true
        vim.g.sonokai_enable_italic = true
        vim.g.sonokai_style = "shusia"
        vim.cmd.colorscheme("sonokai")
    end,
}
