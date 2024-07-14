return {
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
            { "<leader>ff",       "<cmd>Telescope find_files<cr>", desc = "Find file" },
            { "<leader>fg",       "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
            { "<leader>fb",       "<cmd>Telescope buffers<cr>",    desc = "Find buffer" },
            { "<leader><leader>", "<cmd>Telescope buffers<cr>",    desc = "Find buffer" },
            { "<leader>fh",       "<cmd>Telescope help_tags<cr>",  desc = "Help" },
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
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
}
