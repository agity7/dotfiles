return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		local ls = require("null-ls")
		local fmt = ls.builtins.formatting
		local diag = ls.builtins.diagnostics
		local tools = {
			"prettier",
			"stylua",
			"shfmt",
			"golangci-lint",
			"goimports",
		}
		local src = {
			fmt.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			fmt.stylua.with({ filetypes = { "lua", "luau" } }),
			fmt.shfmt.with({ filetypes = { "sh" } }),
			diag.golangci_lint.with({ filetypes = { "go" } }),
			fmt.goimports.with({ filetypes = { "go" } }),
		}
		require("mason-null-ls").setup({
			ensure_installed = tools,
			automatic_installation = true,
		})
		ls.setup({
			sources = src,
			on_attach = function(cl, buf)
				if not cl.supports_method("textDocument/formatting") then
					return
				end
				local grp = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
				vim.api.nvim_clear_autocmds({ group = grp, buffer = buf })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = grp,
					buffer = buf,
					callback = function()
						vim.lsp.buf.format({ async = false, bufnr = buf })
					end,
				})
			end,
		})
	end,
}
