function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  "stevearc/oil.nvim",
  keys = {
    {
      "<leader>fn", "<cmd>Oil<cr>", desc = "File explorer",
    },
  },
  cmd = "Oil",
  opts = {
    columns = {
      "icon",
      "permissions",
      "size",
      -- "mtime",
    },
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = false,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    constrain_cursor = "name",
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<Esc>"] = "actions.close",
      ["q"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["<BS>"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gz"] = { "actions.change_sort", mode = "n" },
      ["gs"] = { function() require("oil").set_sort({{ "size", "desc" }}) end, mode = "n", desc = "Sort by size" },
      ["gn"] = { function() require("oil").set_sort({{ "name", "asc" }}) end, mode = "n", desc = "Sort by name" },
      ["gS"] = { function() require("oil").set_sort({{ "size", "asc" }}) end, mode = "n", desc = "Sort by reverse size" },
      ["gN"] = { function() require("oil").set_sort({{ "name", "desc" }}) end, mode = "n", desc = "Sort by reverse name" },
      ["g."] = "actions.toggle_hidden",
      ["<C-s>"] = { "actions.select", opts = { horizontal = true, close = true, split = "belowright" } },
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      border = "rounded",
      win_options = {
        winblend = 0,
        -- winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
      },
      padding = 6,
    },
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    preview = {
      win_options = {
        winblend = 0,
        -- winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
      },
    },
    win_options = {
      winbar = "%!v:lua.get_oil_winbar()",
      -- winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
    },
    skip_confirm_for_simple_edits = true,
  },
}
