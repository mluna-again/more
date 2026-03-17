vim.api.nvim_create_user_command("W", function()
  require("conform").format({
    bufnr = vim.api.nvim_get_current_buf(),
  })
  vim.cmd("write")
end, {})

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    notify_on_error = true,
    timeout_ms = 5000, -- rubocop is slow
    format_on_save = false,
    formatters = {
      sqlfluff = {
        args = { "fix", "$FILENAME" },
        stdin = false,
        exit_codes = { 0, 1 },
        cwd = function(_config, _ctx) return vim.fs.root(vim.env.PWD, { ".sqlfluff" }) end,
      }
    },
    formatters_by_ft = {
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      go = { "goimports" },
      lua = { "stylua" },
      elixir = { "mix" },
      python = { "black" },
      ruby = { "rubocop" },
      c = { "clang-format" },
      css = { "prettier" },
      cpp = { "clang-format" },
      sql = { "sqlfluff" },
      clojure = { "cljfmt" },
    },
  },
}
