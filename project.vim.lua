local view_log = "tail -f /dev/null"
vim.keymap.set("n", "rl", console_ctl(view_log))

vim.keymap.set(
  "n", "<leader>ga",
  function()
    exec_in_popup([[git add * && git commit -am "untitled updates" && git push -u origin HEAD; any-key]])
  end
)
