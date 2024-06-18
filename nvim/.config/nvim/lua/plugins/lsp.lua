return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				-- "luacheck",
				"shellcheck",
				"shfmt",
				"css-lsp",
				"dart-debug-adapter",
				"dockerfile-language-server",
				"gitlab-ci-ls",
				"gofumpt",
				"goimports",
				"gopls",
				"hadolint",
				"json-lsp",
				"lua-language-server",
				"prettier",
				"shfmt",
				"sqlfluff",
				"yaml-language-server",
			})
		end,
	},
}
