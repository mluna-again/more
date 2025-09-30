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
    format_on_save = false,
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
    },
  },
}
