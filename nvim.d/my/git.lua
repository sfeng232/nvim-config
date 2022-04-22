local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
    map('n', 'gj', '<cmd>Gitsigns next_hunk<cr>')
    map('n', 'gk', '<cmd>Gitsigns prev_hunk<cr>')
    map('n', 'gr', '<cmd>Gitsigns reset_hunk<cr>')
    -- stage / reset hunk with whichkey, basically <leader>g + s/u/r
  end
}

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
map("n", "gh", ":call system('gitk')<cr>", opts)
map("n", "gH", ":call system('gitk ' . expand('%'))<cr>", opts)
map("n", "gs", "<cmd>Telescope git_status<cr>", opts)
map("n", "gu", "<cmd>call TmuxPopup('echo git pull...; git pull; any-key')<cr>", opts)
map("n", "gd", "<cmd>call GitDiff()<cr>", opts)
map("n", "gi", "<cmd>call GitCommit()<cr>", opts)
vim.cmd [[
  function! TmuxPopup(cmd)
    call system("tmux popup -E \"zsh -c 'cd `pwd`; pwd;" . a:cmd . "'\"")
  endfunction

  function! GitDiff()
    let cmd = 'git diff --color | diff-so-fancy | less'
    call system("tmux splitw \"zsh -c '" . cmd . "'\"")
  endfunction

  function! GitCommit()
    let cmd = 'git gui'
    call system("tmux splitw \"zsh -c '" . cmd . "'\"")
  endfunction
]]
