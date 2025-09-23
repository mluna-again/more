-- Set this settings in Godot/Editor/Editor Settings/Text Editor/External
-- Exec Path: nvim
-- Exec Flags: --server /tmp/godot.pipe --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"
-- Then start nvim like this: nvim --listen /tmp/godot.pipe
-- Although I think you don't need --listen if you don't care about clicking scripts in Godot and auto-opening them in nvim
return {
  filetypes = {"gd", "gdscript", "gdscript3"},
  root_pattern = { "project.godot", ".git" },
  cmd = function(dispatcher, config)
    return vim.lsp.rpc.connect('127.0.0.1', 6005)()
  end,
}
