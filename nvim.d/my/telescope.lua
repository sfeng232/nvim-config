local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    file_ignore_patterns = {
      'node_modules/',
      '.yarn/',
      'target/',
      'dist/',
      '.DS_Store/',
      'deps/',
      '_build/',
      '.git/',
      '.svg$', '.png$', '.jpg$', '.gif$', '.otf$', '.ttf$', '.pyc$'
    },

    -- shorten, smart, absolute
    path_display = { "absolute" },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<m-j>"] = actions.move_selection_next,
        ["<m-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<c-j>"] = actions.select_default,
        -- ["<c-j>"] = actions.select_tab,
        -- ["<C-x>"] = actions.select_horizontal,
        -- ["<C-v>"] = actions.select_vertical,

        -- ["<C-u>"] = actions.preview_scrolling_up,
        -- ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["jk"] = actions.close,
        ["<esc>"] = actions.close,
        ["<c-/>"] = actions.which_key,

        -- ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        -- ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        -- ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = false,
        -- ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      hidden = true,
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
    }
  },
}

telescope.load_extension('fzf')
