local config_dir = vim.fn.stdpath("config")
vim.opt.rtp:prepend(config_dir)
local lockfile = vim.env.FABRIKTOR_NVIM_LOCKFILE
assert(lockfile and lockfile ~= "", "FABRIKTOR_NVIM_LOCKFILE must be set")
require("core.installations").setup()
local specs = require("plugins")
for _, spec in ipairs(specs) do
  local repo = type(spec) == "table" and spec[1]
  if repo == "nvim-treesitter/nvim-treesitter" then
    spec.build = nil
    spec.config = function() end
  elseif repo == "neovim/nvim-lspconfig" or repo == "nvimtools/none-ls.nvim" then
    spec.config = function() end
  end
end
require("lazy").setup(specs, {
  lockfile = lockfile,
  install = { missing = false },
  checker = { enabled = false },
})
