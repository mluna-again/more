require("lazy").setup({
  checker = { enabled = false },
  spec = {
    {
      "gpanders/nvim-parinfer",
      commit = "5ca09287ab3f4144f78ff7977fabc27466f71044",
    },
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
            prompt_prefix = "  ",
            selection_caret = "  ",
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
          ols = {},
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
  },
})

