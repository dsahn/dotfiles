local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 400
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded" },
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
})
