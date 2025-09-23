return {
  'saghen/blink.cmp',
  event = "VeryLazy",
  -- dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    cmdline = {
      enabled = true,
      keymap = {
        preset = 'none',
      },
      completion = {
        menu = {
          draw = {
            columns = {
              { "label" }
            },
          },
        },
      },
    },
    keymap = {
      preset = 'none',
      ['<C-space>'] = {'show'},
      ["<C-k>"] = {"accept"},
      ["<C-p>"] = {"select_prev"},
      ["<C-n>"] = {"select_next"},
    },
    completion = {
      documentation = {
        auto_show = false ,
      },
      menu = {
        draw = {
          columns = {
            { "label" }, { "kind" }
          },
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = "lua" },
  },
  opts_extend = { "sources.default" }
}
