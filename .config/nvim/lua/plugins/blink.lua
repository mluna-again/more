return {
  'saghen/blink.cmp',
  dependencies = { "neovim/nvim-lspconfig" },
  event = "InsertEnter",
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
          padding = { 1, 0 },
          components = {
            label = {
              text = function(ctx)
                return ctx.label
              end
            },
            kind = {
              highlight = "BlinkCmpKind",
              text = function(ctx)
                return string.format(" %s ", ctx.kind)
              end
            },
          },
          columns = {
            { "label" }, { "kind" }
          },
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        snippets = {
          opts = {
            friendly_snippets = false,
          },
        },
      },
    },
    fuzzy = { implementation = "lua" },
  },
  opts_extend = { "sources.default" }
}
