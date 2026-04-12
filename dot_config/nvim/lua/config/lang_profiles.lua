--- Optional language bundles keyed by chezmoi `nvim_languages` entries.
-- See docs/nvim.md (nvim_languages) for valid keys and chezmoi `[data] nvim_languages`.

local M = {}

--- @type table<string, string[]>
M.treesitter = {
  rust = { "rust" },
  typescript = { "javascript", "typescript", "tsx" },
  python = { "python" },
  go = { "go" },
  clang = { "c", "cpp" },
}

--- mason-lspconfig server names (merged into ensure_installed after lua_ls)
--- @type table<string, string[]>
M.mason = {
  rust = { "rust_analyzer" },
  typescript = { "ts_ls" },
  python = { "pyright" },
  go = { "gopls" },
  clang = { "clangd" },
}

--- filetype -> conform formatter list
--- @type table<string, table<string, string[]>>
M.conform = {
  rust = {
    rust = { "rustfmt" },
  },
  typescript = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
  },
  python = {
    python = { "black" },
  },
  go = {
    go = { "gofmt" },
  },
  clang = {
    c = { "clang_format" },
    cpp = { "clang_format" },
  },
}

--- @param capabilities table
function M.enable_lsp(lang, capabilities)
  if lang == "rust" then
    vim.lsp.config("rust_analyzer", { capabilities = capabilities })
    vim.lsp.enable("rust_analyzer")
  elseif lang == "typescript" then
    vim.lsp.config("ts_ls", { capabilities = capabilities })
    vim.lsp.enable("ts_ls")
  elseif lang == "python" then
    vim.lsp.config("pyright", { capabilities = capabilities })
    vim.lsp.enable("pyright")
  elseif lang == "go" then
    vim.lsp.config("gopls", { capabilities = capabilities })
    vim.lsp.enable("gopls")
  elseif lang == "clang" then
    vim.lsp.config("clangd", { capabilities = capabilities })
    vim.lsp.enable("clangd")
  end
end

return M
