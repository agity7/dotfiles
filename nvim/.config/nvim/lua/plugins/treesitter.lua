return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'lua',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'regex',
        'dockerfile',
        'toml',
        'json',
        'go',
        'gitignore',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        'css',
        'html',
        'php',
      },

      -- Autoinstall languages that are not installed.
      auto_install = true,

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
keymaps = {
  init_selection = '<C-space>',       -- Ctrl+Space to initiate selection.
  node_incremental = '<C-space>',     -- Ctrl+Space to incrementally expand selection.
  node_decremental = '<M-space>',     -- Alt+Space to decrementally shrink selection.
},
      },
textobjects = {
    move = {
      enable = true,
      set_jumps = true, 
      keymaps = {
        -- Move to the start of the function.
        [']['] = '@function.outer',
        -- Move to the end of the function.
        ['[]'] = '@function.outer',

        -- Move to the start of the struct.
        ['[['] = '@class.outer',
        -- Move to the end of the struct.
        [']]'] = '@class.outer',
      },
    },
  },
    }
  end,
}
