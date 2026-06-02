return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local pick = require("telescope.builtin")
		local cap = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)
		local srv = {
			emmet_language_server = {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascriptreact",
					"typescriptreact",
					"svelte",
				},
			},
			gopls = {
				settings = {
					gopls = {
						staticcheck = true,
						gofumpt = true,
						analyses = {
							shadow = true,
							unused = true,
							unusedparams = true,
							unusedvariable = true,
							unusedwrite = true,
						},
					},
				},
			},
			ts_ls = {},
			svelte = {},
			eslint = {},
			dockerls = {},
			docker_compose_language_service = {},
			jsonls = {},
			yamlls = {},
			cssls = {},
			texlab = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
					},
				},
			},
		}
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp", { clear = true }),
			callback = function(ev)
				local cl = vim.lsp.get_client_by_id(ev.data.client_id)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
				end
				if cl and cl.name ~= "null-ls" then
					cl.server_capabilities.documentFormattingProvider = false
					cl.server_capabilities.documentRangeFormattingProvider = false
				end
				map("n", "gd", pick.lsp_definitions, "Definition")
				map("n", "gr", pick.lsp_references, "References")
				map("n", "gI", pick.lsp_implementations, "Implementation")
				map("n", "gD", vim.lsp.buf.declaration, "Declaration")
				map("n", "<leader>lt", pick.lsp_type_definitions, "Type definition")
				map("n", "<leader>ls", pick.lsp_document_symbols, "Document symbols")
				map("n", "<leader>lw", pick.lsp_dynamic_workspace_symbols, "Workspace symbols")
				map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
				if cl and cl.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local grp = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = ev.buf,
						group = grp,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = ev.buf,
						group = grp,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(x)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = grp, buffer = x.buf })
						end,
					})
				end
				if cl and cl.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("n", "<leader>lh", function()
						vim.lsp.inlay_hint.enable(
							not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
							{ bufnr = ev.buf }
						)
					end, "Toggle hints")
				end
			end,
		})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(srv),
		})
		for name, cfg in pairs(srv) do
			cfg.capabilities = vim.tbl_deep_extend("force", {}, cap, cfg.capabilities or {})
			vim.lsp.config(name, cfg)
			vim.lsp.enable(name)
		end
	end,
}
