return {
	"nvim-treesitter/nvim-treesitter",
	branch = vim.fn.has("nvim-0.12") == 1 and "main" or "master",
	lazy = false,
	build = ":TSUpdate",
	opts = {
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
		"svelte",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	},
	config = function(_, parsers)
		if vim.fn.has("nvim-0.12") == 1 then
			require("nvim-treesitter").install(parsers)
			return
		end
		require("nvim-treesitter.configs").setup({
			ensure_installed = parsers,
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
