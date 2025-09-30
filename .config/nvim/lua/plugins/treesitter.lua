return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
  opts = {
    ensure_installed = {
      "lua",
      "go",
      "elixir",
      "bash",
      "gdscript",
      "typescript",
      "javascript",
      "ruby",
      "c",
      "css",
      "cpp",
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = { enable = true },
  },
}
