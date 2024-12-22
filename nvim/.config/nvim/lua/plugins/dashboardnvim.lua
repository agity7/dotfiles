return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'doom', -- Use the doom theme
      config = {
        header = {
          [[                             ]],
          [[                             ]],
          [[                             ]],
          [[ _____ _   _ _ _             ]],
          [[|  _  | |_|_| |_|___ ___ ___ ]],
          [[|   __|   | | | | . | . | -_|]],
          [[|__|  |_|_|_|_|_|  _|  _|___|]],
          [[                |_| |_|      ]],
          [[                             ]],
          [[                             ]],
          [[                             ]],
        },
        center = {
          {
            icon = "󰱼 ",
            icon_hl = "DashboardIcon",
            desc = "Find File",
            desc_hl = "DashboardDesc",
            key = "f",
            key_hl = "DashboardKey",
            action = "Telescope find_files",
          },
          {
            icon = " ",
            icon_hl = "DashboardIcon",
            desc = "Find Word",
            desc_hl = "DashboardDesc",
            key = "w",
            key_hl = "DashboardKey",
            action = "Telescope live_grep",
          },
          {
            icon = " ",
            icon_hl = "DashboardIcon",
            desc = "Config",
            desc_hl = "DashboardDesc",
            key = "c",
            key_hl = "DashboardKey",
            action = "edit ~/.config/nvim/init.lua",
          },
          {
            icon = " ",
            icon_hl = "DashboardIcon",
            desc = "Quit",
            desc_hl = "DashboardDesc",
            key = "q",
            key_hl = "DashboardKey",
            action = "qa",
          },
        },
        footer = { "Never give up!" },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
