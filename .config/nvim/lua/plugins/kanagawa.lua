return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  lazy = false,
  config = function()
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

    vim.cmd([[colorscheme kanagawa-dragon]])
  end,
}
