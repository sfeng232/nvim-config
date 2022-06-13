local M = {}

local last_line = ""

M.run_shell = function(cmd)
  local handle = io.popen(cmd)
  local output = handle:read("*a")
  handle:close()
  return output
end

M.send_line_to_pane = function(text, pane)
  if pane == "" then
    vim.notify("Target pane not found", "error")
    return
  end
  local cb = io.popen("tmux load-buffer -", "w")
  cb:write(text)
  cb:close()
  M.run_shell("tmux paste-buffer -t " .. pane)
end

M.send_line_to_prev_pane = function(line)
  local pane = M.run_shell("tmux list-panes | grep active -B1 | head -n1"):gsub(": .*", "")
  M.send_line_to_pane(line, pane)
end

M.send_line_to_next_pane = function(line)
  local pane = M.run_shell("tmux list-panes | grep active -A1 | sed -n 2p"):gsub(": .*", "")
  M.send_line_to_pane(line, pane)
end

M.send_current_line = function(dir)
  local line = vim.api.nvim_get_current_line() .. "\n"
  if (dir or "next") == "next" then
    M.send_line_to_next_pane(line)
  else
    M.send_line_to_prev_pane(line)
  end
end

M.send_last_line = function()
  if last_line == "" then
    vim.notify("Last line not found", "error")
    return
  end
  M.send_line_to_next_pane(last_line)
end

M.send_highlighted_lines = function(dir)
  vim.cmd([[normal "ay]])
  local cmd = vim.fn.getreg("a")
  if (dir or "next") == "next" then
    M.send_line_to_next_pane(cmd)
  else
    M.send_line_to_prev_pane(cmd)
  end
end

-- send a cell like jupyter, cell is separated by empty lines
M.send_current_cell = function(dir)
  local sl = vim.fn.search("^$", "bnW")
  local el = vim.fn.search("^$", "nW")
  if el == 0 then
    el = vim.fn.line("$")
  end
  local lines_tbl = vim.fn.getline(sl, el)
  local lines = table.concat(lines_tbl, "\n") .. "\n"
  local cmd = lines
  if (dir or "next") == "next" then
    M.send_line_to_next_pane(cmd)
  else
    M.send_line_to_prev_pane(cmd)
  end
end

M.yank_current_cell = function()
  local sl = vim.fn.search("^$", "bnW")
  local el = vim.fn.search("^$", "nW")
  if el == 0 then
    el = vim.fn.line("$")
  end
  local lines_tbl = vim.fn.getline(sl, el)
  local lines = table.concat(lines_tbl, "\n") .. "\n"
  local cb = io.popen("xclip -selection clipboard", "w")
  cb:write(lines)
  cb:close()
end

M.run_popup = function(cmd)
  local cwd = vim.fn.getcwd()
  local fullcmd = "cd " .. cwd .. "; [ -f .envrc ] && source .envrc; " .. cmd
  M.run_shell("tmux popup bash -ic '" .. fullcmd .. "'")
end

return M
