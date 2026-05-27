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
			replace = {
				cmd = "sd",
			},
		},
		is_block_ui_break = true,
	},
}
