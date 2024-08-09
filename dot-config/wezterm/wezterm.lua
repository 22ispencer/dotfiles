local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font")
config.color_scheme_dirs = { "~/dotfiles/dot-config/wezterm/colors/" }

config.color_scheme = "Sonokai (Gogh)"

return config
