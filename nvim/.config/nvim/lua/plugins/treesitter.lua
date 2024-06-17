return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "css",
        "dart",
        "diff",
        "gitignore",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "php",
        "sql",
        "http",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Mdx.
      vim.filetype.add({
        extension = {
          "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
