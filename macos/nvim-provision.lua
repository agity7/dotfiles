local function provision()
  require("lazy").load({ plugins = { "mason.nvim", "nvim-treesitter" } })
  require("mason").setup({ log_level = vim.log.levels.DEBUG })
  local packages = {
    "stylua",
    "shfmt",
    "prettier",
    "golangci-lint",
    "goimports",
    "emmet-language-server",
    "gopls",
    "typescript-language-server",
    "svelte-language-server",
    "eslint-lsp",
    "dockerfile-language-server",
    "docker-compose-language-service",
    "json-lsp",
    "yaml-language-server",
    "css-lsp",
    "texlab",
    "lua-language-server",
  }
  local registry = require("mason-registry")
  local async = require("mason-core.async")
  registry.refresh()
  local failures = {}
  print("[Fabriktor macOS] Installing Mason tools one at a time...")
  async.run_blocking(function()
    for i, name in ipairs(packages) do
      if not registry.has_package(name) then
        failures[#failures + 1] = name .. ": not found in Mason registry"
      else
        local pkg = registry.get_package(name)
        if pkg:is_installed() then
          print(("[Fabriktor macOS] %d/%d %s: already installed"):format(i, #packages, name))
        else
          print(("[Fabriktor macOS] %d/%d Installing %s..."):format(i, #packages, name))
          local result = async.wait(function(resolve)
            pkg:install({}, function(success, err)
              resolve({ success, err })
            end)
          end)
          if not result[1] then
            failures[#failures + 1] = name .. ": " .. tostring(result[2])
          elseif not pkg:is_installed() then
            failures[#failures + 1] = name .. ": installer finished but package is missing"
          end
        end
      end
    end
  end)
  if #failures > 0 then
    error("Mason installations failed:\n- " .. table.concat(failures, "\n- ") .. "\nSee :MasonLog for details.")
  end
  local ts = require("nvim-treesitter")
  assert(type(ts.install) == "function", "Expected current nvim-treesitter install API")
  local parsers = require("plugins.treesitter").opts
  print("[Fabriktor macOS] Installing " .. #parsers .. " Treesitter parsers...")
  ts.install(parsers):wait(900000)
  local installed = {}
  for _, parser in ipairs(ts.get_installed()) do
    installed[parser] = true
  end
  local missing_parsers = {}
  for _, parser in ipairs(parsers) do
    if not installed[parser] then
      table.insert(missing_parsers, parser)
    end
  end
  assert(#missing_parsers == 0, "Treesitter parsers missing: " .. table.concat(missing_parsers, ", "))
  print("[Fabriktor macOS] Mason tools and Treesitter parsers verified.")
end
local ok, err = xpcall(provision, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln("[Fabriktor macOS] " .. err)
  vim.cmd("cquit 1")
end
