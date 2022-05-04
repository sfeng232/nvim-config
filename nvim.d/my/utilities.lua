local status_ok, notify = pcall(require, "notify")
if status_ok then
  notify.setup({
    timeout = 1000,
    -- render = "minimal",
  })
  vim.notify = notify
end

_G.run_cmd = function(cmd)
  local handle = io.popen(cmd)
  local output = handle:read("*a")
  handle:close()
  return output
end

_G.console_ctl = function(cmd)
  return function()
    local left_pane = run_cmd([[tmux list-panes -F '#{pane_id} #{pane_start_command}' | grep leftpane]])
    local paneId = left_pane:match("([^ ]+)") or ""

    local kill_pane = function()
      run_cmd("tmux send-keys -t " .. paneId .. " c-c 2>/dev/null; tmux send-keys -t " .. paneId .. " c-d 2>/dev/null")
    end
    local actual_cmd = "zsh -c 'echo leftpane > /dev/null && " .. cmd .. "'"
    local subed = string.gsub(cmd, '"', '\\"')

    if string.find(left_pane, subed, 0, true) then
      kill_pane()
    elseif paneId == "" then
      run_cmd('tmux splitw -dhb -p32 -- ' .. actual_cmd)
    else
      run_cmd('tmux splitw -dvb -t "' .. paneId .. '" -- ' .. actual_cmd)
      kill_pane()
    end
  end
end

_G.exec_in_split = function(cmd, tmux_arg)
  local cmd2 = "echo " .. cmd .. "; " .. cmd
  local cmd3 = "tmux splitw " .. (tmux_arg or "") .. " \"zsh -c '" .. cmd2 .. "'\""
  run_cmd(cmd3)
end

_G.exec_in_popup = function(cmd, tmux_arg)
  local c = string.gsub(cmd, '"', '\\"')
  local cmd2 = "tmux popup -E " .. (tmux_arg or "") ..
    " \"zsh -c 'cd `pwd`; pwd; [ -f .envrc ] && source .envrc;" .. c .. "'\""
  run_cmd(cmd2)
end

_G.ReloadConfig = function()
  for name,_ in pairs(package.loaded) do
    if name:match('^my') then
      package.loaded[name] = nil
    end
  end
  dofile("/home/loki/.config/nvim/init.lua")
end
vim.cmd [[command! ReloadConfig lua ReloadConfig()]]

_G.deprecate = function(alt)
  return function()
    vim.notify("Use " .. alt .. " instead", "error", {
      title = "Shortcut deprecated",
    })
  end
end

