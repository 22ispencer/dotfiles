local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "JetBrainsMono Nerd Font Mono" })

local os_name = io.popen("uname -s", "r"):read("*l")
if os_name then
	if os_name:lower() == "darwin" then
		config.font_size = 14
	end
end

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

	tab_bar = {
		background = "#211F21",

		active_tab = {
			bg_color = "#423F46",
			fg_color = "#e3e1e4",
		},
		inactive_tab = {
			bg_color = "#37343A",
			fg_color = "#e3e1e4",
		},
		inactive_tab_hover = {
			bg_color = "#2D2A2E",
			fg_color = "#e3e1e4",
		},
		new_tab = {
			bg_color = "#37343A",
			fg_color = "#e3e1e4",
		},
		new_tab_hover = {
			bg_color = "#2D2A2E",
			fg_color = "#e3e1e4",
		},
	},
}
config.native_macos_fullscreen_mode = true
config.use_fancy_tab_bar = false

return config
