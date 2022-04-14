-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "",
    staged = "S",
    unmerged = "",
    renamed = "➜",
    deleted = "",
    untracked = "U",
    ignored = "◌",
  },
  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")
local open_file = require('nvim-tree.actions.open-file')

nvim_tree.setup {
  auto_reload_on_write = true,
  disable_netrw = true,
  hide_root_folder = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 60,
    height = 30,
    side = "left",
    auto_resize = true,
    number = false,
    relativenumber = false,
    mappings = {
      custom_only = false,
      list = {
        -- R: reload, a: add, d: del, r: rename, o/x: open/close folder
        -- t: open in tab, q: close
        { key = "<c-t>", action = "close" },
        { key = "t", action = "" },
        { key = "x", action = "close_node" },
        { key = "qf", action = "close" },
        -- { key = "<c-j>", action = "edit" },
        { key = "<c-j>", action = "xxx", action_cb = function()
          local node = lib.get_node_at_cursor()
          if node.nodes ~= nil then
            lib.expand_or_collapse(node)
          else
            open_file.fn("edit", node.absolute_path)
            view.close()
          end
        end },
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },
  update_to_buf_dir = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  quit_on_open = 0,
  git_hl = 1,
  disable_window_picker = 0,
  root_folder_modifier = ":t",
  show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
    tree_width = 30,
  },
}
