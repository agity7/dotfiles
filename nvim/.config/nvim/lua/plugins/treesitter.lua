return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	-- Dependencies for additional features.
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},

	config = function()
		require("nvim-treesitter.configs").setup({
			-- Specify the languages to be installed.
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

			-- Automatically install missing languages.
			auto_install = true,

			-- Enable syntax highlighting.
			highlight = { enable = true },

			-- Enable smart indentation.
			indent = { enable = true },

			-- Keep new lines in comment mode when pressing Enter.
			auto_indent = {
				enable = true,
				indent_on_enter = {
					enable = true,
					keymaps = {
						["<CR>"] = {
							["*"] = { is_mapped = true, indent = 0 }, -- For line comments (e.g., "//").
							["--"] = { is_mapped = true, indent = 0 }, -- For block comments (e.g., "--[[ ... ]]").
						},
					},
				},
			},

			-- Enable incremental selection with key mappings.
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>", -- Ctrl+Space to initiate selection.
					node_incremental = "<C-space>", -- Ctrl+Space to expand selection incrementally.
					node_decremental = "<M-space>", -- Alt+Space to shrink selection incrementally.
				},
			},

			-- Configure text object movements.
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					keymaps = {
						-- Move to the start and end of a function.
						["]["] = "@function.outer",
						["[]"] = "@function.outer",

						-- Move to the start and end of a class or struct.
						["[["] = "@class.outer",
						["]]"] = "@class.outer",
					},
				},
			},
		})
	end,
}
