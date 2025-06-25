return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
			enable_chat = true,
			enable_in_insert = true,
			virtual_text = {
				enabled = true,
				map_keys = true,
				accept_fallback = "<Tab>",
				idle_delay = 1,
			},
		})
	end,
}
