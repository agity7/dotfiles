local wezterm = require("wezterm")
local cfg = wezterm.config_builder()
cfg.automatically_reload_config = true
cfg.enable_tab_bar = false
cfg.window_close_confirmation = "NeverPrompt"
cfg.window_decorations = "RESIZE"
cfg.color_scheme = "matrix"
cfg.font = wezterm.font("FiraCode Nerd Font Mono", {
	weight = "Regular",
	stretch = "Normal",
	style = "Normal",
})
cfg.font_size = 15
cfg.line_height = 1
cfg.background = {
	{
		source = {
			Color = "#000000",
		},
		width = "100%",
		height = "100%",
		opacity = 1,
	},
}
cfg.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}
return cfg
