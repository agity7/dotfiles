local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
	-- General.
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	default_cursor_style = "BlinkingBar",
	color_scheme = "Mono Green (Gogh)",
	font = wezterm.font("FiraCode Nerd Font Mono", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	font_size = 18,
	line_height = 1,

	-- UI.
	background = {
		{
			source = {
				Color = "#000000",
			},
			width = "100%",
			height = "100%",
			opacity = 0.92,
		},
	},
	window_padding = {
		left = 3,
		right = 3,
		top = 0,
		bottom = 0,
	},
}

return config
