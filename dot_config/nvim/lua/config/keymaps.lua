local map = vim.keymap.set

--- Directory of the current buffer, or cwd if the buffer has no path.
local function buffer_dir()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    return vim.fn.fnamemodify(path, ":p:h")
  end
  return vim.fn.getcwd()
end

local function telescope_find_files_this_dir()
  local dir = buffer_dir()
  require("telescope.builtin").find_files({
    search_dirs = { dir },
    prompt_title = "Files (" .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

local function telescope_live_grep_this_dir()
  local dir = buffer_dir()
  require("telescope.builtin").live_grep({
    search_dirs = { dir },
    prompt_title = "Grep (" .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer sidebar" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fd", telescope_find_files_this_dir, { desc = "Find files (this directory)" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fs", telescope_live_grep_this_dir, { desc = "Live grep (this directory)" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- VSCode-like paste on selection: keep clipboard contents after replacing text.
map("x", "p", [["_dP]], { desc = "Paste without overriding clipboard" })

-- gitsigns: hunk 이동 (gitsigns 로드 후 사용 가능)
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev git hunk" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
