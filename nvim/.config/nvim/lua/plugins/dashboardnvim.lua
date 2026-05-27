local function btn(icon, desc, key, action)
	return {
		icon = icon,
		icon_hl = "DashboardIcon",
		desc = desc,
		desc_hl = "DashboardDesc",
		key = key,
		key_hl = "DashboardKey",
		action = action,
	}
end
return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					[[                             ]],
					[[                             ]],
					[[                             ]],
					[[ _____ _   _ _ _             ]],
					[[|  _  | |_|_| |_|___ ___ ___ ]],
					[[|   __|   | | | | . | . | -_|]],
					[[|__|  |_|_|_|_|_|  _|  _|___|]],
					[[                |_| |_|      ]],
					[[                             ]],
					[[                             ]],
					[[                             ]],
				},
				center = {
					btn(" ", "Command", "c", function()
						vim.api.nvim_feedkeys(":", "n", false)
					end),
					btn("󰱼 ", "Find File", "f", "Telescope find_files"),
					btn(" ", "Files", "d", "Neotree toggle position=left"),
					btn(" ", "Find Word", "r", "Telescope live_grep"),
					btn("󰶆 ", "Lazy", "l", "Lazy"),
					btn("󰰐 ", "Mason", "m", "Mason"),
					btn("󰩈 ", "Quit", "q", "qa"),
				},
				footer = {
					"Never give up!",
				},
			},
		})
	end,
}
