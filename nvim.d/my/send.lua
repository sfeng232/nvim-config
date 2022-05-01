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

M.send_line_to_pane = function(line, pane)
  if pane == "" then
    notify("Target pane not found", "error")
    return
  end
  last_line = line:gsub("'", [['\'']]):gsub("^ *", ""):gsub("\n *", "\n")
  local cmd = "tmux send-keys -t" .. pane .. " '" .. last_line .. "' enter"
  M.run_shell(cmd)
end

M.send_line_to_prev_pane = function(line)
  local pane = M.run_shell("tmux list-panes | grep active -B1 | head -n1"):gsub(": .*", "")
  M.send_line_to_pane(line, pane)
end

M.send_line_to_next_pane = function(line)
  local pane = M.run_shell("tmux list-panes | grep active -A1 | sed -n 2p"):gsub(": .*", "")
  M.send_line_to_pane(line, pane)
end

M.send_current_line = function(_dir)
  local line = vim.api.nvim_get_current_line()
  local dir = _dir or "next"
  if dir == "next" then
    M.send_line_to_next_pane(line)
  else
    M.send_line_to_prev_pane(line)
  end
end

M.send_last_line = function()
  if last_line == "" then
    notify("Last line not found", "error")
    return
  end
  M.send_line_to_next_pane(last_line)
end

M.send_highlighted_lines = function(_dir)
  vim.cmd([[normal "ay]])
  local cmd = vim.fn.getreg("a")
  local dir = _dir or "next"
  if dir == "next" then
    M.send_line_to_next_pane(cmd)
  else
    M.send_line_to_prev_pane(cmd)
  end
end

M.run_popup = function(cmd)
  local cwd = vim.fn.getcwd()
  local fullcmd = "cd " .. cwd .. "; [ -f .envrc ] && source .envrc; " .. cmd
  M.run_shell("tmux popup bash -ic '" .. fullcmd .. "'")
end

return M
