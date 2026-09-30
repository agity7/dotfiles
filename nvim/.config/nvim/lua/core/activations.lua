local M = {}
function M.activate()
	vim.cmd([[colorscheme solarized-osaka]])
	if vim.fn.has("nvim-0.12") == 0 then
		return
	end
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("TreesitterActivation", { clear = true }),
		callback = function(args)
			local filetype = vim.bo[args.buf].filetype
			if filetype == "" then
				return
			end
			local language = vim.treesitter.language.get_lang(filetype) or filetype
			if not vim.treesitter.language.add(language) then
				return
			end
			vim.treesitter.start(args.buf, language)
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end
return M
