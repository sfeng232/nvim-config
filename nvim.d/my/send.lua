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
  last_line = line
  local cmd = "tmux send-keys -t " .. next_pane .. " '" .. line .. "' enter"
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
  local r1 = unpack(vim.api.nvim_buf_get_mark(0, "<")) - 1
  local r2 = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local text = vim.api.nvim_buf_get_lines(0, r1, r2, false)
  local line = table.concat(text, "\n")
  M.send_line_to_next_pane(line)
end

M.run_popup = function(cmd)
  local cwd = vim.fn.getcwd()
  local fullcmd = "cd " .. cwd .. "; [ -f .envrc ] && source .envrc; " .. cmd
  M.run_shell("tmux popup bash -ic '" .. fullcmd .. "'")
end

return M
