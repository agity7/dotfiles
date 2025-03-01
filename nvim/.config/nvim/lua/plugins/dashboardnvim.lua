return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
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
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Command",
						desc_hl = "DashboardDesc",
						key = "c",
						key_hl = "DashboardKey",
						action = function()
							vim.api.nvim_feedkeys(":", "n", false)
						end,
					},
					{
						icon = "󰱼 ",
						icon_hl = "DashboardIcon",
						desc = "Find File",
						desc_hl = "DashboardDesc",
						key = "f",
						key_hl = "DashboardKey",
						action = "Telescope find_files",
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Navigate",
						desc_hl = "DashboardDesc",
						key = "d",
						key_hl = "DashboardKey",
						action = function()
							vim.api.nvim_command("normal ;d")
						end,
					},
					{
						icon = " ",
						icon_hl = "DashboardIcon",
						desc = "Find Word",
						desc_hl = "DashboardDesc",
						key = "r",
						key_hl = "DashboardKey",
						action = "Telescope live_grep",
					},
					{
						icon = "󰶆 ",
						icon_hl = "DashboardIcon",
						desc = "Lazy",
						desc_hl = "DashboardDesc",
						key = "l",
						key_hl = "DashboardKey",
						action = "Lazy",
					},
					{
						icon = "󰰐 ",
						icon_hl = "DashboardIcon",
						desc = "Mason",
						desc_hl = "DashboardDesc",
						key = "m",
						key_hl = "DashboardKey",
						action = "Mason",
					},
					{
						icon = "󰩈 ",
						icon_hl = "DashboardIcon",
						desc = "Quit",
						desc_hl = "DashboardDesc",
						key = "q",
						key_hl = "DashboardKey",
						action = "qa",
					},
				},
				footer = { "Never give up!" },
			},
		})
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
