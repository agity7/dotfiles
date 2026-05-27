return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local wide = function()
			return vim.fn.winwidth(0) > 100
		end
		local mode = {
			"mode",
			fmt = function(s)
				return " " .. s
			end,
		}
		local file = {
			"filename",
			file_status = true,
			path = 0,
		}
		local diag = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = {
				error = " ",
				warn = " ",
				info = " ",
				hint = " ",
			},
			colored = false,
			update_in_insert = false,
			always_visible = false,
			cond = wide,
		}
		local diff = {
			"diff",
			colored = false,
			symbols = {
				added = " ",
				modified = " ",
				removed = " ",
			},
			cond = wide,
		}
		require("lualine").setup({
			options = {
				icons_enabled = true,
				section_separators = {
					left = "",
					right = "",
				},
				component_separators = {
					left = "",
					right = "",
				},
				disabled_filetypes = {
					"alpha",
					"dashboard",
					"neo-tree",
				},
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { file },
				lualine_x = {
					diag,
					diff,
					{ "encoding", cond = wide },
					{ "filetype", cond = wide },
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{ "location", padding = 0 },
				},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {
				"fugitive",
			},
		})
	end,
}
