return {
	"nvim-pack/nvim-spectre",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-tree/nvim-web-devicons",
			optional = true,
		},
	},
	opts = {
		default = {
			find = {
				cmd = "rg",
				options = { "ignore-case", "hidden" },
			},
			replace = {
				cmd = "sd",
			},
		},
		is_block_ui_break = true,
	},
}
