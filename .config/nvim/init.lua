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
vim.opt.expandtab = true

-- PLUGINS
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa-dragon")
    end
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
			require("telescope").setup({})

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
			require("oil").setup()
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
					go = { "goimports" },
					lua = { "stylua" },
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

-- KEYMAPS
vim.keymap.set("i", "jj", "<esc>", { desc = "Enter NORMAL mode" })
vim.keymap.set("n", "dh", "<cmd>nohlsearch<cr>", { desc = "Delete highlighted items" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Horizontal split" })
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
