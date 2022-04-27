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



local M = {}

local last_line = ""

local status_ok, notify = pcall(require, "notify")
if not status_ok then
  notify = vim.notify
else
  notify.setup({
    render = "minimal",
  })
end

M.run_shell = function(cmd)
  local handle = io.popen(cmd)
  local output = handle:read("*a")
  handle:close()
  return output
end

M.send_line_to_next_pane = function(line)
  local next_pane = M.run_shell("tmux list-panes | grep active -A1 | sed -n 2p"):gsub(": .*", "")
  if next_pane == "" then
    notify("Target pane not found", "error")
    return
  end
  last_line = line:gsub("'", [['\'']]):gsub("^ *", ""):gsub("\n *", "\n")
  local cmd = "tmux send-keys -t" .. next_pane .. " '" .. last_line .. "' enter"
  M.run_shell(cmd)
end

M.send_current_line = function()
  local line = vim.api.nvim_get_current_line()
  M.send_line_to_next_pane(line)
end

M.send_last_line = function()
  if last_line == "" then
    notify("Last line not found", "error")
    return
  end
  M.send_line_to_next_pane(last_line)
end

M.send_highlighted_lines = function()
  vim.cmd([[normal "ay]])
  local cmd = vim.fn.getreg("a")
  M.send_line_to_next_pane(cmd)
end

M.run_popup = function(cmd)
  local cwd = vim.fn.getcwd()
  local fullcmd = "cd " .. cwd .. "; [ -f .envrc ] && source .envrc; " .. cmd
  M.run_shell("tmux popup bash -ic '" .. fullcmd .. "'")
end

return M
