return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    {
      "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files",
    },
    {
      "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find expression",
    },
    {
      "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "File history",
    },
    {
      "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer",
    },
  },
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        mirror = false,
        prompt_position = "top",
      },
      prompt_prefix = "  ",
      selection_caret = "  ",
      mappings = {
        i = {
          ["<C-s>"] = function(buf)
            require("telescope.actions.set").edit(buf, "belowright split")
          end,
          ["<C-v>"] = function(buf)
            require("telescope.actions.set").edit(buf, "botright vsplit")
          end,
        },
        n = {
          ["<C-s>"] = function(buf)
            require("telescope.actions.set").edit(buf, "belowright split")
          end,
          ["<C-v>"] = function(buf)
            require("telescope.actions.set").edit(buf, "botright vsplit")
          end,
        },
      },
    }
  },
}
