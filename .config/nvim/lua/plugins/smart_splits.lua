return {
  'mrjones2014/smart-splits.nvim',
  -- some bug in the 2.0.5 version...
  -- version = '2.0.5',
  commit = "601cc6422b2b94af2e88d14358b81cf7dfb5db5f",
  keys = {
    { "<leader>wh", function() require("smart-splits").move_cursor_left() end, desc =  "Go to left window" },
    { "<leader>wl", function() require("smart-splits").move_cursor_right() end, desc =  "Go to right window" },
    { "<leader>wk", function() require("smart-splits").move_cursor_up() end, desc =  "Go to the window above" },
    { "<leader>wj", function() require("smart-splits").move_cursor_down() end, desc =  "Go to the window below" },

    { "<C-\\><C-l>", function() require("smart-splits").move_cursor_left() end, desc =  "Go to left window", mode = { "i", "n" } },
    { "<C-\\><C-h>", function() require("smart-splits").move_cursor_right() end, desc =  "Go to right window", mode = { "i", "n" } },
    { "<C-\\><C-k>", function() require("smart-splits").move_cursor_up() end, desc =  "Go to the window above", mode = { "i", "n" } },
    { "<C-\\><C-j>", function() require("smart-splits").move_cursor_down() end, desc =  "Go to the window below", mode = { "i", "n" } },
  },
  opts = {
    ignored_buftypes = {},
    ignored_filetypes = {},
    default_amount = 3,
    at_edge = 'wrap',
    -- Desired behavior when the current window is floating:
    -- 'previous' => Focus previous Vim window and perform action
    -- 'mux' => Always forward action to multiplexer
    float_win_behavior = 'previous',
    move_cursor_same_row = false,
    cursor_follows_swapped_bufs = false,
    ignored_events = {
      'BufEnter',
      'WinEnter',
    },
    multiplexer_integration = nil,
    disable_multiplexer_nav_when_zoomed = true,
    kitty_password = nil,
    zellij_move_focus_or_tab = false,
    log_level = 'info',
  }
}
