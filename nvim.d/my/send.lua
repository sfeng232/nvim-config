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
