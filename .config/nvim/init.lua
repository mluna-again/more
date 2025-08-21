-- OPTIONS
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
vim.opt.spelllang:append("es_MX")
vim.opt.spelllang:append("fr")
vim.opt.spelllang:append("jp")
vim.opt.fillchars = {eob = " "}

-- PLUGINS
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.cmd("packadd cfilter")

require("lazy").setup({
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        pane_gap = 1,
        sections = {
          {
            section = "terminal",
            cmd = "/bin/cat ~/.local/ascii/mewo.txt",
            height = 17,
            padding = 0,
          },
          { section = "header", padding = 0 },
          { section = "keys", gap = 0, padding = {2, 0} },
          { section = "startup" },
        },
        preset = {
          header = [[
⠀▄▄▄▄▄▄▄▄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀▌ MEWO ▐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀▀▀▀▀▀▀▀▀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  
⠀▌                                                     ▐  
⠀▌ Meow? (Waiting for something to happen?)            ▐  
⠀▌                                                     ▐  
⠀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ]],
          keys = {
            { icon = " ", key = "<leader>ff", desc = "Find Files", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "<leader>cn", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "<leader>fw", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "<leader>fo", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "<leader>co", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "<leader>sl", desc = "Restore Session", action = "<cmd>SessionLoad<cr>" },
            { icon = "󰒲 ", key = "<leader>L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    opts = {
      use_icons = false
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
    end,
  },
  {
    "mattn/emmet-vim",
    config = function()
    end
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require('leap').create_default_mappings()
    end
  },
  {
    "fatih/vim-go",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
      })
    end
  },
  {
    "chaoren/vim-wordmotion"
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
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
            OilBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },
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

            StatusLine = { bg = "none", fg = theme.ui.fg },
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
      vim.cmd("colorscheme kanagawa-dragon")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local telescopeConfig = require("telescope.config")

      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-s>"] = "select_horizontal",
            },
          },
          -- `hidden = true` is not supported in text grep commands.
          vimgrep_arguments = vimgrep_arguments,
        },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Find expression" })
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "File history" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffer" })
    end,
  },
  {
    "stevearc/oil.nvim",
    config = function()
      local oil = require("oil")

      require("oil").setup({
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = {
            callback = function()
              oil.select({ vertical = true })
              oil.close()
            end,
            desc = "Vertical Split",
            mode = "n",
          },
          ["<C-s>"] = {
            callback = function()
              oil.select({ horizontal = true })
              oil.close()
            end,
            desc = "Horizontal Split",
            mode = "n",
          },
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
          ["g."] = "actions.toggle_hidden",
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          border = "rounded",
          win_options = {
            winblend = 0,
            winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
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
            winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
          },
        },
        win_options = {
          winhighlight = "Normal:OilBackground,FloatBorder:OilBorder,FloatTitle:OilBorder,LineNr:OilBackground",
        },
        skip_confirm_for_simple_edits = true,
      })

      vim.keymap.set("n", "<leader>fn", "<cmd>Oil<cr>", { desc = "File explorer" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {},
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-n>"] = cmp.mapping.select_next_item(),

          ["<C-p>"] = cmp.mapping.select_prev_item(),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<C-k>"] = cmp.mapping.confirm({ select = true }),

          ["<C-Space>"] = cmp.mapping.complete({}),

          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),

          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local telescope = require("telescope.builtin")
          vim.keymap.set("n", "<leader>lu", telescope.lsp_definitions, { desc = "Search definitions" })
          vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, { desc = "Code actions" })
          vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Documentation" })
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
          vim.keymap.set("n", "<leader>lf", vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Diagnostics" })
          vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { desc = "Signature" })
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        gopls = {},
        elixirls = {},
        golangci_lint_ls = {},
        pyright = {},
        bashls = {},
        tsserver = {},
        cssls = {},
        clangd = {},
        solargraph = {},
      }

      require("mason").setup({})
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require("conform").setup({
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
      })
      vim.api.nvim_create_user_command("W", function()
        require("conform").format({
          bufnr = vim.api.nvim_get_current_buf(),
        })
      end, {})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "go",
        "elixir",
        "bash",
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    -- yes, i need this
    "karb94/neoscroll.nvim",
    opts = {},
  },
})

-- FUNCTIONS
vim.api.nvim_create_user_command("SessionSave", function() 
  vim.cmd("mksession! session.vim")
end, {})

vim.api.nvim_create_user_command("SessionLoad", function() 
  vim.cmd("source session.vim")
end, {})

-- KEYMAPS
vim.keymap.set("i", "jj", "<esc>", { desc = "Enter NORMAL mode" })
vim.keymap.set("n", "dh", "<cmd>nohlsearch<cr>", { desc = "Delete highlighted items" })
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
vim.keymap.set("n", "<C-y>", [[:let @+ = substitute(expand("%:p"), getcwd(), ".", "")<cr>]], { desc = "Yanks the current file relative path to the system clipboard" })
