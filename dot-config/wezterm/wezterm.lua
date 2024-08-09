local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font")

config.colors = {
	foreground = "#e3e1e4",
	background = "#2d2a2e",

	cursor_bg = "#e3e1e4",
	cursor_fg = "#2d2a2e",
	cursor_border = "#e3e1e4",

	selection_fg = "#e3e1e4",
	selection_bg = "#354157",

	ansi = {
		"#2d2a2e",
		"#f85e84",
		"#9ecd6f",
		"#e5c463",
		"#ef9062",
		"#ab9df2",
		"#7accd7",
		"#e3e1e4",
	},
	brights = {
		"#848089",
		"#f85e84",
		"#9ecd6f",
		"#e5c463",
		"#ef9062",
		"#ab9df2",
		"#7accd7",
		"#e3e1e4",
	},

	compose_cursor = "#ef9062",
}

config.keys = {
	{
		key = "F11",
		mods = "",
		action = wezterm.action.ToggleFullscreen,
	},
}

return config
