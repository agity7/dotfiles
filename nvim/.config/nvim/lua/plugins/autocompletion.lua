return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			build = function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return nil
				end
				return "make install_jsregexp"
			end,
		},
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local snip = require("luasnip")
		local icons = {
			Text = "󰉿",
			Method = "m",
			Function = "󰊕",
			Constructor = "",
			Field = "",
			Variable = "󰆧",
			Class = "󰌗",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰇽",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰊄",
		}
		require("luasnip.loaders.from_vscode").lazy_load()
		snip.config.setup({})
		cmp.setup({
			preselect = cmp.PreselectMode.Item,
			snippet = {
				expand = function(args)
					snip.lsp_expand(args.body)
				end,
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-l>"] = cmp.mapping(function()
					if snip.expand_or_locally_jumpable() then
						snip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if snip.locally_jumpable(-1) then
						snip.jump(-1)
					end
				end, { "i", "s" }),
				["<Tab>"] = cmp.mapping(function(fb)
					if cmp.visible() then
						cmp.select_next_item()
						return
					end
					if snip.expand_or_locally_jumpable() then
						snip.expand_or_jump()
						return
					end
					fb()
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fb)
					if cmp.visible() then
						cmp.select_prev_item()
						return
					end
					if snip.locally_jumpable(-1) then
						snip.jump(-1)
						return
					end
					fb()
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 900 },
				{ name = "luasnip", priority = 800 },
				{ name = "buffer", priority = 700 },
				{ name = "path", priority = 600 },
			}),
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(ent, item)
					item.kind = icons[item.kind] or item.kind
					item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[ent.source.name]
					return item
				end,
			},
		})
	end,
}
