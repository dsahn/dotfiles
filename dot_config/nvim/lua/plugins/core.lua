return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    opts = function()
      local base = {
        "bash",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "toml",
        "vim",
        "yaml",
      }
      local ok, machine = pcall(require, "config.machine")
      local langs = ok and machine.languages or {}
      local profiles = require("config.lang_profiles")
      local seen = {}
      local parsers = {}
      for _, p in ipairs(base) do
        if not seen[p] then
          seen[p] = true
          parsers[#parsers + 1] = p
        end
      end
      for _, lang in ipairs(langs) do
        for _, p in ipairs(profiles.treesitter[lang] or {}) do
          if not seen[p] then
            seen[p] = true
            parsers[#parsers + 1] = p
          end
        end
      end
      return {
        ensure_installed = parsers,
        auto_install = true,
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "left",
            source = "filesystem",
            reveal = true,
          })
        end,
        desc = "Toggle file tree (neo-tree)",
      },
      {
        "<leader>gE",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "left",
            source = "git_status",
          })
        end,
        desc = "Toggle git status tree (neo-tree)",
      },
    },
    ---@module "neo-tree"
    ---@type neotree.Config
    opts = {
      sources = { "filesystem", "git_status" },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem", display_name = "󰉓 " },
          { source = "git_status", display_name = "󰊢 " },
        },
      },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy", "notify" },
      window = {
        position = "left",
        width = 35,
      },
      filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        hijack_netrw_behavior = "open_default",
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    commit = "47a8530e79a484d55ba5efa3768fc0b0c023d497",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs_staged_enable = true,
    },
  },
  {
    "petertriho/nvim-scrollbar",
    dependencies = { "lewis6991/gitsigns.nvim" },
    opts = {
      handlers = {
        gitsigns = true,
        diagnostic = true,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>a", group = "AI" },
        { "<leader>g", group = "Git" },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "xTacobaco/cursor-agent.nvim",
    commit = "e0b86624ccfd5f98af46a780049037fa07521331",
    cmd = { "CursorAgent", "CursorAgentSelection", "CursorAgentBuffer" },
    config = function()
      require("cursor-agent").setup({
        cmd = "cursor-agent",
        args = {},
      })
    end,
  },
}
