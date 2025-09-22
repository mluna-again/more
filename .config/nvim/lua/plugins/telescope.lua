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
      prompt_prefix = "  ",
      selection_caret = "  ",
    }
  },
}
