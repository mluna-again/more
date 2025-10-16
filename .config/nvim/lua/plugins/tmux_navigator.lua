return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<leader>wh", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window" },
    { "<leader>wj", "<cmd>TmuxNavigateDown<cr>", desc = "Go to down window" },
    { "<leader>wk", "<cmd>TmuxNavigateUp<cr>", desc = "Go to up window" },
    { "<leader>wl", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window" },
  },
}
