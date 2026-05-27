return {
	"b0o/incline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "BufReadPre",
	priority = 1200,
	config = function()
		local col = require("solarized-osaka.colors").setup()
		require("incline").setup({
			highlight = {
				groups = {
					InclineNormal = {
						guibg = col.magenta300,
						guifg = col.base04,
					},
					InclineNormalNC = {
						guibg = col.base03,
						guifg = col.violet500,
					},
				},
			},
			window = {
				margin = {
					vertical = 0,
					horizontal = 1,
				},
			},
			hide = {
				cursorline = true,
			},
			render = function(ctx)
				local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ctx.buf), ":t")
				if vim.bo[ctx.buf].modified then
					name = "[+]" .. name
				end
				local icon, color = require("nvim-web-devicons").get_icon_color(name)
				return {
					{ icon, guifg = color },
					{ " " },
					{ name },
				}
			end,
		})
	end,
}
