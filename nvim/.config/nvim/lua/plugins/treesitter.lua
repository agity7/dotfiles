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
				"lua",
				"javascript",
				"typescript",
				"vimdoc",
				"vim",
				"regex",
				"dockerfile",
				"toml",
				"json",
				"go",
				"gitignore",
				"yaml",
				"make",
				"cmake",
				"markdown",
				"markdown_inline",
				"bash",
				"css",
				"html",
				"php",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					node_decremental = "<M-space>",
				},
			},
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					keymaps = {
						["]["] = "@function.outer",
						["[]"] = "@function.outer",
						["[["] = "@class.outer",
						["]]"] = "@class.outer",
					},
				},
			},
		})
	end,
}
