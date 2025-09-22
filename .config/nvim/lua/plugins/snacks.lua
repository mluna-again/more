return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      pane_gap = 0,
      sections = {
        { section = "header", gap = 0, padding = 0 },
        { section = "keys", gap = 0, padding = 0 },
        { section = "startup" },
      },
      preset = {
        header = [[
              ▄▄            ▗▄▖                                  
            ▇█▛▀█▇▃▃      ▐▇█▀█▇▙▃▖                              
            ██▍ ▂▂██▇▆▃▂▆▆██▙▂▔▔▜██▆▆▂▁                          
            ██▆▆███████████████▆▆▆█████▅▅▆▅▁▁                    
            ████████████████████████████████▊          ▄▄▅▄      
          ▃▄██████████████████████████████████▊     ▕█████▉      
          ██████▍▔██████████▋▔▜███████████████▙▂▃▂▃▇▇████▔▔      
          ▜█████▇▆███████████▆████████████████████████▛▔▔        
            ████████████████████████████████▛▀▀▀▀▀▘              
              ▀▀██████▛▀▜█████▛▀▀▀▀▀▜█████▛▀▘                    
                 ▔   ▔   ▔   ▔       ▔   ▔                       
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
}
