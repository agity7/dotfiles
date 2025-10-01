return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
			enable_chat = true,
			virtual_text = {
				enabled = true,
				map_keys = true,
				accept_fallback = "<Tab>",
				idle_delay = 1,
				filetypes = {
					[""] = false,
					TelescopePrompt = false,
					qf = false,
					help = false,
					gitcommit = false,
					proto = false,
					protobuf = false,
				},
				default_filetype_enabled = true,
			},
		})
	end,
}
