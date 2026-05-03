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

-- Plugin keybinds
vim.keymap.set("n", "<leader>fn", "<cmd>Oil<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find expressions" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find open buffers" })
-- Plugin keybinds

vim.cmd.packadd "cfilter"

vim.api.nvim_create_user_command("W", function()
  local ft = vim.bo.filetype
  local p = vim.api.nvim_buf_get_name(0)
  
  vim.cmd("write")

  local cmd = nil
  if ft == "ruby" then
    cmd = {"rubocop", "--autocorrect-all", "--format", "quiet", "--fail-level", "error", "--stderr", p}
  end

  if ft == "python" then
    cmd = {"black", p}
  end

  if ft == "go" then
    cmd = {"go", "fmt", p}
  end

  if cmd == nil then
    vim.notify(string.format("No formatted configured for %s.", ft), vim.log.levels.ERROR)
    return
  end

  local res = vim.system(cmd, { text = true }):wait()
  vim.cmd("edit")
  if res.code == 0 then
    return
  end

  vim.notify(res.stderr, vim.log.levels.ERROR)
end, {})

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


vim.pack.add({
  { src = "https://github.com/rebelot/kanagawa.nvim", version = "aef7f5c" },
  { src = "https://github.com/stevearc/oil.nvim", version = "0fcc838" },
  { src = "https://github.com/chaoren/vim-wordmotion", version = "81d9bd2" },
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "b9fd522" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "cfb85dc" },
  { src = "https://github.com/neovim/nvim-lspconfig", version = "9ccd58a" },
  { src = "https://github.com/hrsh7th/nvim-cmp", version = "a1d5048" },
  { src = "https://github.com/hrsh7th/cmp-cmdline", version = "d126061" },
  { src = "https://github.com/hrsh7th/cmp-buffer", version = "b74fab3" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp", version = "cbc7b02" },
  { src = "https://github.com/hrsh7th/cmp-path", version = "c642487" },
  { src = "https://github.com/L3MON4D3/LuaSnip", version = "642b0c5" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip", version = "98d9cb5" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "4916d65" },
})

require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
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
    ["gS"] = { function() require("oil").set_sort({{ "size", "asc" }}) end, mode = "n", desc = "Sort by reverse size" },
    ["gn"] = { function() require("oil").set_sort({{ "type", "asc" }, { "name", "asc" }}) end, mode = "n", desc = "Sort by name" },
    ["gN"] = { function() require("oil").set_sort({{ "type", "asc" }, { "name", "desc" }}) end, mode = "n", desc = "Sort by reverse name" },
    ["gd"] = { function() require("oil").set_sort({{ "mtime", "desc" }}) end, mode = "n", desc = "Sort by modified time" },
    ["gD"] = { function() require("oil").set_sort({{ "mtime", "asc" }}) end, mode = "n", desc = "Sort by reverse modified time" },
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
    },
  },
  skip_confirm_for_simple_edits = true,
})

require("telescope").setup({
  defaults = {
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " ", },
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
})

require("kanagawa").setup({
  undercurl = false,
  overrides = function(colors)
    local theme = colors.theme

    return {
      -- Save an hlgroup with dark background and dimmed foreground
      -- so that you can use it where your still want darker windows.
      -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark

      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      Normal = { fg = theme.ui.fg_dim, bg = theme.ui.bg },

      Input1 = { bg = theme.ui.bg_p1 },
      Input1Border = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
      Input2 = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      Input2Border = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
      Input3 = { bg = theme.ui.bg_dim },
      Input3Border = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

      OilBackground = { bg = theme.ui.bg },
      OilBorder = { bg = theme.ui.bg, fg = theme.ui.bg },
      OilPreviewBackground = { bg = theme.ui.bg_gutter },
      OilPreviewBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },

      -- Popular plugins that open floats will link to NormalFloat by default;
      -- set their background accordingly if you wish to keep them dark and borderless
      LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

      SnacksDashboardDesc = { fg = theme.syn.regex },
      SnacksDashboardIcon = { fg = theme.syn.identifier },
      SnacksDashboardKey = { fg = theme.syn.parameter },
      SnacksDashboardFooter = { fg = theme.syn.parameter },
      SnacksDashboardSpecial = { fg = theme.syn.identifier },
      SnacksDashboardHeader = { fg = theme.ui.fg_dim },

      TelescopeTitle = { fg = theme.syn.regex, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg_p1 },
      TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { bg = theme.ui.bg_dim },
      TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
      TelescopePromptTitle = { bg = theme.syn.identifier, fg = theme.ui.bg_dim },
      TelescopePreviewTitle = { bg = theme.syn.regex, fg = theme.ui.bg_dim },
      TelescopeResultsTitle = { bg = theme.syn.statement, fg = theme.ui.bg_dim },
      TelescopeMatching = { fg = theme.syn.regex },

      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
      PmenuExtra = { fg = theme.ui.fg, bg = theme.ui.bg },

      Search = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
      IncSearch = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
      CurSearch = { fg = theme.ui.bg_gutter, bg = theme.syn.constant },
      Substitute = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },
      Visual = { fg = theme.ui.bg_gutter, bg = theme.syn.identifier },

      NormalFloat = { bg = theme.ui.bg_gutter },
      FloatBorder = { bg = theme.ui.bg_gutter, fg = theme.ui.bg_gutter },
      FloatTitle = { bg = theme.ui.bg_gutter },
      MsgArea = { bg = theme.ui.bg },

      WinSeparator = { fg = theme.ui.bg_gutter, bg = theme.ui.bg },

      LineNr = { fg = theme.syn.comment, bg = theme.ui.bg },
      CursorLine = { bg = theme.syn.bg, fg = theme.ui.fg },
      CursorLineNr = { bg = theme.syn.bg, fg = theme.syn.comment },
      SignColumn = { fg = theme.syn.comment, bg = theme.ui.bg },
      GitSignsAdd = { fg = theme.syn.green, bg = theme.ui.bg },
      GitSignsAddNr = { fg = theme.syn.green, bg = theme.ui.bg },
      GitSignsAddLn = { fg = theme.syn.green, bg = theme.ui.bg },
      GitSignsChange = { fg = theme.syn.identifier, bg = theme.ui.bg },
      GitSignsChangeNr = { fg = theme.syn.identifier, bg = theme.ui.bg },
      GitSignsChangeLn = { fg = theme.syn.identifier, bg = theme.ui.bg },
      GitSignsDelete = { fg = theme.syn.operator, bg = theme.ui.bg },
      GitSignsDeleteNr = { fg = theme.syn.operator, bg = theme.ui.bg },
      GitSignsDeleteLn = { fg = theme.syn.operator, bg = theme.ui.bg },

      -- More colorful statusline
      -- StatusLine = { bg = "none", fg = theme.ui.fg },
      -- StatusLineModeIcon = { bg = theme.syn.regex, fg = theme.ui.bg_m1 },
      -- StatusLineFileIcon = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
      -- StatusLineBranchIcon = { bg = theme.syn.keyword, fg = theme.ui.bg_m1 },
      -- StatusLineProgressIcon = { bg = theme.syn.identifier, fg = theme.ui.bg_m1 },
      -- StatusLinePositionIcon = { bg = theme.syn.string, fg = theme.ui.bg_m1 },
      -- StatusLineFolderIcon = { bg = theme.syn.special2, fg = theme.ui.bg_m1 },
      -- StatusLineNormalNormal = { bg = theme.ui.bg_gutter, fg = theme.ui.fg },
      -- StatusLineNormalMode = { bg = theme.syn.regex, fg = theme.ui.fg },
      -- StatusLineInsertMode = { bg = theme.syn.identifier, fg = theme.ui.fg },
      -- StatusLineVisualMode = { bg = theme.syn.special1, fg = theme.ui.bg },
      -- StatusLineReplaceMode = { bg = theme.syn.constant, fg = theme.ui.fg },
      -- StatusLineCommandMode = { bg = theme.syn.keyword, fg = theme.ui.fg },
      -- StatusLineInactiveMode = { bg = theme.syn.comment, fg = theme.ui.fg },

      -- Monochrome statusline
      StatusLine = { bg = "none", fg = theme.ui.fg },
      StatusLineModeIcon = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
      StatusLineFileIcon = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
      StatusLineBranchIcon = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
      StatusLineProgressIcon = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
      StatusLinePositionIcon = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
      StatusLineFolderIcon = { bg = theme.ui.bg_p2, fg = theme.ui.fg },

      ErrorMsg = { fg = theme.syn.special2, bg = theme.ui.bg },

      -- Colorful
      -- DiagnosticError = { fg = theme.syn.special2, bg = theme.ui.bg_gutter },
      -- DiagnosticWarn = { fg = theme.syn.constant, bg = theme.ui.bg_gutter },
      -- DiagnosticInfo = { fg = theme.diag.info, bg = theme.ui.bg_gutter },
      -- DiagnosticHint = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },

      -- Monochrome
      DiagnosticError = { fg = theme.syn.special2, bg = "none" },
      DiagnosticWarn = { fg = theme.syn.constant, bg = "none" },
      DiagnosticInfo = { fg = theme.diag.info, bg = "none" },
      DiagnosticHint = { fg = theme.syn.identifier, bg = "none" },

      DiagnosticSignWarn = { fg = theme.syn.constant, bg = theme.ui.bg },
      DiagnosticSignError = { fg = theme.syn.special2, bg = theme.ui.bg },
      DiagnosticSignInfo = { fg = theme.diag.info, bg = theme.ui.bg },
      DiagnosticSignHint = { fg = theme.syn.identifier, bg = theme.ui.bg },
      DiagnosticFloatingError = { fg = theme.syn.special2, bg = theme.ui.bg_gutter },
      DiagnosticFloatingWarn = { fg = theme.syn.constant, bg = theme.ui.bg_gutter },
      DiagnosticFloatingInfo = { fg = theme.diag.info, bg = theme.ui.bg_gutter },
      DiagnosticFloatingHint = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },
      DiagnosticFloatingSignWarn = { fg = theme.syn.constant, bg = theme.ui.bg_gutter },
      DiagnosticFloatingSignError = { fg = theme.syn.special2, bg = theme.ui.bg_gutter },
      DiagnosticFloatingSignInfo = { fg = theme.diag.info, bg = theme.ui.bg_gutter },
      DiagnosticFloatingSignHint = { fg = theme.syn.identifier, bg = theme.ui.bg_gutter },

      BlinkCmpKind = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
      BlinkCmpMenu = { fg = theme.ui.fg, bg = theme.ui.bg_p2 },
      BlinkCmpMenuSelection = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
      BlinkCmpKindEnum = { fg = theme.ui.bg_p2, bg = theme.syn.constant },
      BlinkCmpKindFile = { fg = theme.ui.bg_p2, bg = theme.syn.special2 },
      BlinkCmpKindText = { fg = theme.ui.bg_p2, bg = theme.syn.special1 },
      BlinkCmpKindUnit = { fg = theme.ui.bg_p2, bg = theme.syn.identifier },
      BlinkCmpKindClass = { fg = theme.ui.bg_p2, bg = theme.syn.type },
      BlinkCmpKindColor = { fg = theme.ui.bg_p2, bg = theme.syn.special3 },
      BlinkCmpKindEvent = { fg = theme.ui.bg_p2, bg = theme.syn.comment },
      BlinkCmpKindField = { fg = theme.ui.bg_p2, bg = theme.syn.parameter },
      BlinkCmpKindValue = { fg = theme.ui.bg_p2, bg = theme.syn.special3 },
      BlinkCmpKindFolder = { fg = theme.ui.bg_p2, bg = theme.syn.special3 },
      BlinkCmpKindMethod = { fg = theme.ui.bg_p2, bg = theme.syn.fun },
      BlinkCmpKindModule = { fg = theme.ui.bg_p2, bg = theme.syn.operator },
      BlinkCmpKindStruct = { fg = theme.ui.bg_p2, bg = theme.syn.type },
      BlinkCmpKindCopilot = { fg = theme.ui.bg_p2, bg = theme.syn.deprecated },
      BlinkCmpKindKeyword = { fg = theme.ui.bg_p2, bg = theme.syn.keyword },
      BlinkCmpKindSnippet = { fg = theme.ui.bg_p2, bg = theme.syn.special2 },
      BlinkCmpKindConstant = { fg = theme.ui.bg_p2, bg = theme.syn.constant },
      BlinkCmpKindFunction = { fg = theme.ui.bg_p2, bg = theme.syn.fun },
      BlinkCmpKindOperator = { fg = theme.ui.bg_p2, bg = theme.syn.operator },
      BlinkCmpKindProperty = { fg = theme.ui.bg_p2, bg = theme.syn.special3 },
      BlinkCmpKindVariable = { fg = theme.ui.bg_p2, bg = theme.syn.special3 },
      BlinkCmpKindInterface = { fg = theme.ui.bg_p2, bg = theme.syn.type },
      BlinkCmpKindReference = { fg = theme.ui.bg_p2, bg = theme.syn.identifier },
      BlinkCmpKindEnumMember = { fg = theme.ui.bg_p2, bg = theme.syn.special3 },
      BlinkCmpKindConstructor = { fg = theme.ui.bg_p2, bg = theme.syn.fun },
      BlinkCmpKindTypeParameter = { fg = theme.ui.bg_p2, bg = theme.syn.parameter },

      TabLine = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
      TabLineSel = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
      TabLineFill = { bg = theme.ui.bg },

      IblIndent = { fg = theme.ui.bg_p1 },

      ["@string.special.url"] = { undercurl = false },
    }
  end,
  colors = {
    theme = {
      all = {
        ui = {
          bg = "none"
        },
      },
    },
  },
})

require("luasnip.loaders.from_vscode").load({ paths = {"./snippets"} })
local cmp = require("cmp")
require("cmp").setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-k>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").locally_jumpable(1) then
        require("luasnip").jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").locally_jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
require("cmp").setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

function enable_lsp_server(server)
  local cmp_caps = require('cmp_nvim_lsp').default_capabilities()
  vim.lsp.config(server, {capabilities = cmp_caps})
  vim.lsp.enable(server)
end

enable_lsp_server("pyright")
enable_lsp_server("solargraph")
enable_lsp_server("gopls")
enable_lsp_server("elixir-ls")
enable_lsp_server("rust-analyzer")
enable_lsp_server("typescript-language-server")
enable_lsp_server("tailwind-language-server")
enable_lsp_server("clangd")

vim.cmd.colorscheme "kanagawa-dragon"

local treesitter_langs = {
  "ruby",
  "python",
  "javascript",
  "typescript",
  "elixir",
  "rust",
  "bash",
  "go",
  "c",
  "cpp",
}
require('nvim-treesitter').install(treesitter_langs)
vim.api.nvim_create_autocmd('FileType', {
  pattern = treesitter_langs,
  callback = function(c)
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
-- Special case: i want *.sh files to be treated as bash
vim.api.nvim_create_autocmd('BufRead', {
  pattern = { "*.sh" },
  callback = function(c)
    vim.treesitter.start(c.buf, "bash")
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
