-- Set lualine as statusline
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "craftzdog/solarized-osaka.nvim" },
	config = function()
		local colors = require("solarized-osaka.colors").setup()

		local function custom_status()
			local status = require("codeium.virtual_text").status()
			local icon = " " -- Nerd Font icon for Codeium

			if status.state == "idle" then
				return icon .. " " -- No active completions
			end

			if status.state == "waiting" then
				return icon .. " Waiting..." -- Waiting for a response
			end

			if status.state == "completions" and status.total > 0 then
				return string.format("%s Suggestions Count: %d", icon, status.total) -- Active completions
			end

			return icon .. "0" -- Default fallback
		end

		local codeium_status = {
			function()
				return custom_status()
			end,
			color = { fg = colors.green300, gui = "bold" }, -- Optional styling
		}
		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
			end,
		}

		local filename = {
			"filename",
			file_status = true, -- displays file status (readonly status, modified status)
			path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = false,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = false,
			symbols = { added = " ", modified = " ", removed = " " },
			cond = hide_in_width,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { filename, codeium_status },
				lualine_x = {
					diagnostics,
					diff,
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})
	end,
}
