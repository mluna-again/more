vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "auto"
vim.opt.cursorline = false
vim.opt.hlsearch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.fillchars = {eob = " "}
vim.opt.foldenable = false
vim.wo.foldmethod = "expr"

-- Default LSP keybinds
vim.keymap.del({"n", "v"}, "gra")
vim.keymap.del({"n"}, "gri")
vim.keymap.del({"n"}, "grn")
vim.keymap.del({"n"}, "grr")
vim.keymap.del({"n"}, "grt")
-- Default LSP keybinds
vim.keymap.set("n", "<leader>lu", "<cmd>Telescope lsp_definitions<cr>", { desc = "Search definitions" })
vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Documentation" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "See inline diagnostics" })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Send diagnostics to qflist" })
vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { desc = "Signature" })
vim.keymap.set("i", "jj", "<esc>", { desc = "Enter NORMAL mode" })
vim.keymap.set("n", "<leader>ws", "<C-w>s<C-w><C-r>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>wv", "<C-w>v<C-w><C-r>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>wj", "<C-w><C-j>", { desc = "Focus window below" })
vim.keymap.set("n", "<leader>wk", "<C-w><C-k>", { desc = "Focus window above" })
vim.keymap.set("n", "<leader>wh", "<C-w><C-h>", { desc = "Focus window to the left" })
vim.keymap.set("n", "<leader>wl", "<C-w><C-l>", { desc = "Focus window to the right" })
vim.keymap.set("n", "<leader>wd", "<C-w><C-c>", { desc = "Close window" })
vim.keymap.set("n", "<leader>ww", "<C-w><C-w>", { desc = "Focus previous window" })
vim.keymap.set("n", "<leader>wL", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<leader>wH", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { desc = "Move window down" })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { desc = "Move window up" })
vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sl", "<cmd>SessionLoad<cr>", { desc = "Load session" })
vim.keymap.set("n", "<C-n>", "<cmd>cnext<cr>", { desc = "Go to next QuickList item" })
vim.keymap.set("n", "<C-p>", "<cmd>cprevious<cr>", { desc = "Go to prev QuickList item" })
vim.keymap.set("n", "<C-y>", [[:let @+ = substitute(expand("%:p") . ":" . line("."), getcwd(), ".", "")<cr>]], { desc = "Yanks the current file relative path to the system clipboard" })
vim.keymap.set("n", "gn", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "gr", "<cmd>tabprev<cr>", { desc = "Next tab" })
vim.keymap.set("n", "gt", "<cmd>tabnext<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "gd", "<cmd>tabclose<cr>", { desc = "Close current tab" })

vim.cmd "packadd cfilter"

vim.api.nvim_create_user_command("SessionSave", function()
  vim.cmd("mksession! session.vim")
end, {})

vim.api.nvim_create_user_command("SessionLoad", function()
  vim.cmd("source session.vim")
end, {})

vim.api.nvim_create_user_command("ShellCheck", function()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  vim.cmd("compiler shellcheck")
  vim.cmd("silent make %")

  if #vim.call("getqflist") == 0 then
    vim.cmd("cclose")
  else
    vim.cmd("cope")
  end
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_win_set_cursor(win, cursor)
end, {})

