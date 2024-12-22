require "core.options"
require "core.keymaps"

-- Install dependencies.
require("core.installations").setup()

-- Lazy.nvim setup.
require('lazy').setup(require("plugins"))

-- Colorscheme setup.
require("plugins.colorscheme").setup()

-- Activate runtime configurations.
require("core.activations").activate()
