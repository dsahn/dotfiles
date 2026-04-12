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

local function telescope_find_hidden_files()
  require("telescope.builtin").find_files({
    hidden = true,
    prompt_title = "Files (hidden)",
  })
end

local function telescope_find_hidden_files_this_dir()
  local dir = buffer_dir()
  require("telescope.builtin").find_files({
    hidden = true,
    search_dirs = { dir },
    prompt_title = "Files (hidden, " .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

local function telescope_live_grep_this_dir()
  local dir = buffer_dir()
  require("telescope.builtin").live_grep({
    search_dirs = { dir },
    prompt_title = "Grep (" .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

local function telescope_live_grep_hidden()
  require("telescope.builtin").live_grep({
    additional_args = function()
      return { "--hidden", "--glob", "!.git/*" }
    end,
    prompt_title = "Grep (hidden)",
  })
end

local function telescope_live_grep_hidden_this_dir()
  local dir = buffer_dir()
  require("telescope.builtin").live_grep({
    search_dirs = { dir },
    additional_args = function()
      return { "--hidden", "--glob", "!.git/*" }
    end,
    prompt_title = "Grep (hidden, " .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

local function toggleable_find_files(opts)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")
  opts = vim.tbl_extend("force", { hidden = false }, opts or {})
  local picker_opts = vim.deepcopy(opts)
  picker_opts.prompt_title = opts.prompt_title
  picker_opts.attach_mappings = function(prompt_bufnr, map_telescope)
    local function reopen_with_hidden()
      local prompt = action_state.get_current_line()
      actions.close(prompt_bufnr)
      opts.hidden = not opts.hidden
      if prompt ~= "" then
        opts.default_text = prompt
      end
      toggleable_find_files(opts)
    end

    map_telescope("i", "<M-h>", reopen_with_hidden)
    map_telescope("n", "<M-h>", reopen_with_hidden)
    return true
  end
  builtin.find_files(picker_opts)
end

local function toggleable_live_grep(opts)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")
  opts = vim.tbl_extend("force", { hidden = false }, opts or {})
  local picker_opts = vim.deepcopy(opts)
  picker_opts.prompt_title = opts.prompt_title
  picker_opts.additional_args = function()
    if opts.hidden then
      return { "--hidden", "--glob", "!.git/*" }
    end
    return {}
  end
  picker_opts.attach_mappings = function(prompt_bufnr, map_telescope)
    local function reopen_with_hidden()
      local prompt = action_state.get_current_line()
      actions.close(prompt_bufnr)
      opts.hidden = not opts.hidden
      if prompt ~= "" then
        opts.default_text = prompt
      end
      toggleable_live_grep(opts)
    end

    map_telescope("i", "<M-h>", reopen_with_hidden)
    map_telescope("n", "<M-h>", reopen_with_hidden)
    return true
  end
  builtin.live_grep(picker_opts)
end

local function telescope_find_files_toggle()
  toggleable_find_files({
    prompt_title = "Find Files",
  })
end

local function telescope_find_files_this_dir_toggle()
  local dir = buffer_dir()
  toggleable_find_files({
    search_dirs = { dir },
    prompt_title = "Files (" .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

local function telescope_live_grep_toggle()
  toggleable_live_grep({
    prompt_title = "Live Grep",
  })
end

local function telescope_live_grep_this_dir_toggle()
  local dir = buffer_dir()
  toggleable_live_grep({
    search_dirs = { dir },
    prompt_title = "Grep (" .. vim.fn.fnamemodify(dir, ":~") .. ")",
  })
end

local function open_cli_split(candidates, label)
  local cmd = nil
  for _, c in ipairs(candidates) do
    if vim.fn.executable(c) == 1 then
      cmd = c
      break
    end
  end

  if not cmd then
    vim.notify(label .. " CLI를 찾을 수 없습니다: " .. table.concat(candidates, ", "), vim.log.levels.WARN)
    return
  end

  vim.cmd("botright 12split")
  vim.fn.termopen({ cmd })
  vim.cmd("startinsert")
end

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>ff", telescope_find_files_toggle, { desc = "Find files" })
map("n", "<leader>fF", telescope_find_hidden_files, { desc = "Find files (hidden)" })
map("n", "<leader>fd", telescope_find_files_this_dir_toggle, { desc = "Find files (this directory)" })
map("n", "<leader>fD", telescope_find_hidden_files_this_dir, { desc = "Find files (hidden, this directory)" })
map("n", "<leader>fg", telescope_live_grep_toggle, { desc = "Live grep" })
map("n", "<leader>fG", telescope_live_grep_hidden, { desc = "Live grep (hidden)" })
map("n", "<leader>fs", telescope_live_grep_this_dir_toggle, { desc = "Live grep (this directory)" })
map("n", "<leader>fS", telescope_live_grep_hidden_this_dir, { desc = "Live grep (hidden, this directory)" })
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

-- External AI CLI launchers.
map("n", "<leader>ao", function()
  open_cli_split({ "opencode" }, "opencode")
end, { desc = "Open opencode CLI (split)" })

-- Claude Code → Codex → Cursor Agent (float). Selection/buffer 전송은 cursor-agent 전용.
local function open_ai_agent_primary()
  for _, bin in ipairs({ "claude", "codex" }) do
    if vim.fn.executable(bin) == 1 then
      vim.cmd("botright 12split")
      vim.fn.termopen({ bin })
      vim.cmd("startinsert")
      return
    end
  end
  if vim.fn.executable("cursor-agent") == 1 then
    vim.cmd("CursorAgent")
    return
  end
  vim.notify("AI CLI를 찾을 수 없습니다 (순서: claude, codex, cursor-agent)", vim.log.levels.WARN)
end

local function cursor_agent_buffer_cmds_ok()
  if vim.fn.executable("cursor-agent") ~= 1 then
    vim.notify("선택/버퍼 전송은 cursor-agent가 필요합니다", vim.log.levels.WARN)
    return false
  end
  return true
end

map("n", "<leader>ac", open_ai_agent_primary, { desc = "AI agent: claude → codex → cursor-agent" })
map("v", "<leader>ac", function()
  if not cursor_agent_buffer_cmds_ok() then
    return
  end
  vim.cmd("CursorAgentSelection")
end, { desc = "Send selection to Cursor Agent" })
map("n", "<leader>aC", function()
  if not cursor_agent_buffer_cmds_ok() then
    return
  end
  vim.cmd("CursorAgentBuffer")
end, { desc = "Send buffer to Cursor Agent" })

-- gitsigns: hunk 이동 (gitsigns 로드 후 사용 가능)
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev git hunk" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("n", "<leader>gS", "<cmd>Telescope git_status<cr>", { desc = "Git changed files (Telescope)" })
