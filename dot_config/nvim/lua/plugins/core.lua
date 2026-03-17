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
    commit = "2cc172c28e5550e00e6beead4599b1469469c1c7",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "toml",
        "vim",
        "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
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
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}
