return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
			enable_chat = true,
			enable_in_insert = true,
			virtual_text = {
				enabled = true,
				map_keys = true,
				accept_fallback = "<Tab>",
				idle_delay = 1,
				on_complete = function()
					local fname = vim.fn.expand("%:p")
					if fname ~= "" and vim.fn.filereadable(fname) == 1 then
						local encoding = vim.fn.system("file -b --mime-encoding " .. vim.fn.shellescape(fname))
						if not encoding:match("utf%-8") then
							vim.b.codeium_enabled = false
							return false
						end
					end
					return true
				end,
			},
		})
		vim.api.nvim_create_autocmd("BufReadPost", {
			callback = function(args)
				local bufnr = args.buf
				local bt = vim.bo[bufnr].buftype
				local ft = vim.bo[bufnr].filetype
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local disallowed_buftypes = {
					prompt = true,
					quickfix = true,
					help = true,
					terminal = true,
					nofile = true,
				}
				local disallowed_filetypes = {
					TelescopePrompt = true,
					TelescopeResults = true,
					SpectrePanel = true,
					[""] = true,
				}
				if disallowed_buftypes[bt] or disallowed_filetypes[ft] or fname:match("%.codeium/") then
					vim.b[bufnr].codeium_enabled = false
					return
				end
				if fname ~= "" and vim.fn.filereadable(fname) == 1 then
					local encoding = vim.fn.system("file -b --mime-encoding " .. vim.fn.shellescape(fname))
					if not encoding:match("utf%-8") and not encoding:match("us%-ascii") then
						vim.b[bufnr].codeium_enabled = false
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							if vim.api.nvim_win_get_buf(win) == bufnr then
								vim.schedule(function()
									vim.notify("[Codeium] Disabled on non-UTF-8 file: " .. fname, vim.log.levels.INFO)
								end)
								break
							end
						end
					end
				end
			end,
		})
	end,
}
