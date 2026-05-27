return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"cmake",
				"css",
				"dockerfile",
				"go",
				"gitignore",
				"html",
				"javascript",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"php",
				"regex",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-Space>",
					node_incremental = "<C-Space>",
					node_decremental = "<M-Space>",
				},
			},
		})
	end,
}
