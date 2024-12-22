return {
	require("plugins.neotree"),
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	require("plugins.autoformatting"),
	require("plugins.increname"),
	require("plugins.bufferline"),
	require("plugins.dashboardnvim"),
	require("plugins.lualine"),
	require("plugins.telescope"),
	require("plugins.treesitter"),
	require("plugins.autocompletion"),
	require("plugins.lsp"),
	require("plugins.gitsigns"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.codeium"),
	require("plugins.noice"),
	require("plugins.incline"),
}
