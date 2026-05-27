return {
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
	},
	{
		"tpope/vim-sleuth",
		event = "BufReadPre",
	},
	{
		"tpope/vim-fugitive",
		cmd = {
			"Git",
			"G",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
		},
	},
	{
		"tpope/vim-rhubarb",
		dependencies = {
			"tpope/vim-fugitive",
		},
		cmd = {
			"GBrowse",
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			signs = false,
		},
	},
	{
		"norcalli/nvim-colorizer.lua",
		cmd = {
			"ColorizerAttachToBuffer",
			"ColorizerDetachFromBuffer",
			"ColorizerReloadAllBuffers",
			"ColorizerToggle",
		},
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>" },
			{ "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>" },
			{ "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>" },
			{ "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>" },
			{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>" },
		},
	},
}
