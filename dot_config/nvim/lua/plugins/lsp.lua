return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = function()
      local ok, machine = pcall(require, "config.machine")
      local langs = ok and machine.languages or {}
      local profiles = require("config.lang_profiles")
      local ensure = { "lua_ls" }
      local seen = { lua_ls = true }
      for _, lang in ipairs(langs) do
        for _, srv in ipairs(profiles.mason[lang] or {}) do
          if not seen[srv] then
            seen[srv] = true
            ensure[#ensure + 1] = srv
          end
        end
      end
      return { ensure_installed = ensure }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      local ok, machine = pcall(require, "config.machine")
      local langs = ok and machine.languages or {}
      local profiles = require("config.lang_profiles")
      for _, lang in ipairs(langs) do
        profiles.enable_lsp(lang, capabilities)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function()
      local formatters_by_ft = {
        lua = { "stylua" },
      }
      local ok, machine = pcall(require, "config.machine")
      local langs = ok and machine.languages or {}
      local profiles = require("config.lang_profiles")
      for _, lang in ipairs(langs) do
        local ftmap = profiles.conform[lang]
        if ftmap then
          for ft, fmt in pairs(ftmap) do
            formatters_by_ft[ft] = fmt
          end
        end
      end
      return {
        notify_on_error = false,
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      }
    end,
  },
}
