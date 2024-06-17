return {
  -- Disable no information available notification.
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      opts.presets = {
        lsp_doc_border = true,
        inc_rename = true,
      }
    end,
  },
  -- Elongate notification timeout to 10 seconds.
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 10000,
    },
  },
  -- Enable floating status line in each window.
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = {
              guibg = colors.magenta500,
              guifg = colors.base04,
            },
            InclineNormalNC = {
              guifg = colors.violet500,
              guibg = colors.base03,
            },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+]" .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  -- Simplify buffers and tabs management.
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        modified_icon = "🍒",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  -- Use a theme for lualine.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "solarized-osaka",
      },
    },
  },
  -- Customize logo.
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
    ______      __         _ __   __            
   / ____/___ _/ /_  _____(_) /__/ /_____  _____
  / /_  / __ `/ __ \/ ___/ / //_/ __/ __ \/ ___/
 / __/ / /_/ / /_/ / /  / / ,< / /_/ /_/ / /    
/_/    \__,_/_.___/_/  /_/_/|_|\__/\____/_/     
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
  -- Allow navigation between tmux and nvim.
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
