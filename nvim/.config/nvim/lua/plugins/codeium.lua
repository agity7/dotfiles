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
			},
		})
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "InsertEnter", "BufReadPost" }, {
			callback = function()
				local bt = vim.bo.buftype
				local ft = vim.bo.filetype
				local fname = vim.fn.expand("%:p")
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
					vim.b.codeium_enabled = false
					return
				end
				if fname ~= "" and vim.fn.filereadable(fname) == 1 then
					local encoding = vim.fn.system("file -b --mime-encoding " .. vim.fn.shellescape(fname))
					if not encoding:match("utf%-8") then
						vim.b.codeium_enabled = false
						if vim.api.nvim_get_current_buf() == vim.api.nvim_get_current_win() then
							vim.notify("[Codeium] Disabled on non-UTF-8 file: " .. fname, vim.log.levels.INFO)
						end
					end
				end
			end,
		})
	end,
}
