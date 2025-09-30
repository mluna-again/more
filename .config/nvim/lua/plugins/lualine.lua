return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    options = {
      icons_enabled = true,
      theme = {
        normal = {
          a = "StatusLineNormalNormal",
          b = "StatusLineNormalNormal",
          c = "StatusLineNormalNormal",
        },
        insert = {
          a = "StatusLineNormalNormal",
          b = "StatusLineNormalNormal",
          c = "StatusLineNormalNormal",
        },
        visual = {
          a = "StatusLineNormalNormal",
          b = "StatusLineNormalNormal",
          c = "StatusLineNormalNormal",
        },
        replace = {
          a = "StatusLineNormalNormal",
          b = "StatusLineNormalNormal",
          c = "StatusLineNormalNormal",
        },
        command = {
          a = "StatusLineNormalNormal",
          b = "StatusLineNormalNormal",
          c = "StatusLineNormalNormal",
        },
        inactive = {
          a = "StatusLineNormalNormal",
          b = "StatusLineNormalNormal",
          c = "StatusLineNormalNormal",
        },
      },
      globalstatus = true,
      component_separators = "",
      padding = 0,
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "TelescopePrompt", "snacks_dashboard" },
        winbar = { "TelescopePrompt" },
      },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          color = {},
          icon = { " MODE ", color = "StatusLineModeIcon" },
          padding = { right = 1 },
        },
      },
      lualine_b = {
        {
          "filename",
          icons_enabled = true,
          symbols = {
            modified = "",
          },
          color = {},
          icon = { " FILE ", color = "StatusLineFileIcon" },
          padding = { right = 1 },
        },
      },
      lualine_c = {
        { "branch", padding = { right = 1 }, icon = { " BRANCH ", color = "StatusLineBranchIcon" } },
      },
      lualine_x = {
        {
          "diagnostics",
          diagnostics_color = {
            -- Same values as the general color option can be used here.
            error = "DiagnosticError", -- Changes diagnostics' error color.
            warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
            info = "DiagnosticInfo", -- Changes diagnostics' info color.
            hint = "DiagnosticHint", -- Changes diagnostics' hint color.
          },
          symbols = { error = "ERR ", warn = "WARN ", info = "INFO ", hint = "HINT " },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_y = {
        {
          "searchcount",
          padding = { right = 1 },
        },
        {
          "location",
          padding = { right = 1 },
        },
        {
          "progress",
          icon = { " POS ", color = "StatusLineProgressIcon", align = "right" },
        },
      },
      lualine_z = {
        {
          'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")',
          icon = { " DIR ", color = "StatusLineFolderIcon", align = "right" },
          padding = { left = 1 },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
