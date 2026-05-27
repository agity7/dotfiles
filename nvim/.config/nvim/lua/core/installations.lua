local M = {}
function M.setup()
	local dir = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(dir) then
		local repo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, dir })
		if vim.v.shell_error ~= 0 then
			error("lazy.nvim clone failed:\n" .. out)
		end
	end
	vim.opt.rtp:prepend(dir)
end

return M
