return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local tel = require("telescope")
		local act = require("telescope.actions")
		local fb = tel.extensions.file_browser.actions
		tel.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = act.move_selection_previous,
						["<C-j>"] = act.move_selection_next,
						["<C-l>"] = act.select_default,
					},
					n = {
						["q"] = act.close,
					},
				},
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				winblend = 0,
			},
			pickers = {
				find_files = {
					file_ignore_patterns = {
						"node_modules",
						".git",
						".venv",
					},
					hidden = true,
				},
				buffers = {
					initial_mode = "normal",
					sort_lastused = true,
					mappings = {
						n = {
							["d"] = act.delete_buffer,
							["l"] = act.select_default,
						},
					},
				},
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				file_browser = {
					hidden = true,
					theme = "dropdown",
					hijack_netrw = true,
					mappings = {
						n = {
							["N"] = fb.create,
							["h"] = fb.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(buf)
								for _ = 1, 10 do
									act.move_selection_previous(buf)
								end
							end,
							["<C-d>"] = function(buf)
								for _ = 1, 10 do
									act.move_selection_next(buf)
								end
							end,
							["<PageUp>"] = act.preview_scrolling_up,
							["<PageDown>"] = act.preview_scrolling_down,
						},
					},
				},
			},
		})
		tel.load_extension("fzf")
		tel.load_extension("ui-select")
		tel.load_extension("file_browser")
	end,
}
