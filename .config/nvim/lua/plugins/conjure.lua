return {
  "Olical/conjure",
  ft = {
    "clojure",
  },
  init = function()
    vim.g["conjure#mapping#enable_defaults"] = false
    vim.g["conjure#mapping#prefix"] = "<leader>c"
    vim.g["conjure#mapping#log_toggle"] = "l"
    vim.g["conjure#mapping#eval_buf"] = "b"
    vim.g["conjure#mapping#eval_root_form"] = "f"
    vim.g["conjure#mapping#eval_current_form"] = "F"
    vim.g["conjure#mapping#eval_visual"] = "v"
  end
}
