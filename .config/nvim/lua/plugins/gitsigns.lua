return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "Gitsigns" },
  opts = {
    current_line_blame = true,
  },
}
