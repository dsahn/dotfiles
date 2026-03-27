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
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      hijack_netrw = true,
      sync_root_with_cwd = true,
      view = {
        side = "left",
        width = 35,
      },
      filters = {
        dotfiles = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
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
    opts = {},
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
}
