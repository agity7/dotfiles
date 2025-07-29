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
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = require("telescope").extensions.file_browser.actions
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-l>"] = actions.select_default,
					},
					n = {
						["q"] = actions.close,
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
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					hidden = true,
				},
				buffers = {
					initial_mode = "normal",
					sort_lastused = true,
					mappings = {
						n = {
							["d"] = actions.delete_buffer,
							["l"] = actions.select_default,
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
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for _ = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for _ = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
		telescope.load_extension("file_browser")

		-- Keymaps using <leader>
		vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch existing [B]uffers" })
		vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks" })
		vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search [G]it [C]ommits" })
		vim.keymap.set("n", "<leader>gcf", builtin.git_bcommits, { desc = "Search [G]it [C]ommits for current [F]ile" })
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Search [G]it [B]ranches" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Search [G]it [S]tatus (diff view)" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]resume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader>fP", function()
			builtin.find_files({ cwd = require("lazy.core.config").options.root })
		end, { desc = "Find Plugin File" })

		-- Keymaps using ";"
		vim.keymap.set("n", ";f", function()
			builtin.find_files({ no_ignore = false, hidden = true })
		end, { desc = "Lists files in your current working directory, respects .gitignore" })
		vim.keymap.set("n", ";r", function()
			builtin.live_grep({ additional_args = { "--hidden" } })
		end, {
			desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
		})
		vim.keymap.set("n", ";t", builtin.help_tags, { desc = "Lists available help tags" })
		vim.keymap.set("n", ";;", builtin.resume, { desc = "Resume the previous telescope picker" })
		vim.keymap.set(
			"n",
			";e",
			builtin.diagnostics,
			{ desc = "Lists Diagnostics for all open buffers or a specific buffer" }
		)
		vim.keymap.set("n", ";s", builtin.treesitter, { desc = "Lists Function names, variables, from Treesitter" })
		vim.keymap.set("n", ";d", function()
			telescope.extensions.file_browser.file_browser({
				path = "%:p:h",
				cwd = vim.fn.expand("%:p:h"),
				respect_gitignore = false,
				hidden = true,
				grouped = true,
				previewer = false,
				initial_mode = "normal",
				layout_config = { height = 40 },
			})
		end, { desc = "Open File Browser with the path of the current buffer" })

		-- Keymaps not using <leader> or ";"
		vim.keymap.set("n", "\\", builtin.buffers, { desc = "Lists open buffers" })
	end,
}
