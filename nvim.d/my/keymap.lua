local opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }
local map = vim.keymap.set
local cancel = function(tbl, keys)
  for i, k in pairs(keys) do
    map(tbl, k, "<nop>", opts)
  end
end

cancel("", {"<space>"})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal
map("n", "q1", ":qa<cr>", opts)
map("n", "qw", ":w<cr>", opts)
map("n", "<c-c>", ":nohlsearch<cr>:redraw!<cr>", opts)
map("n", "<m-n>", ":set nu! rnu!<cr>", opts)
map("n", "<c-j>", "<<", opts)
map("n", "<c-k>", ">>", opts)
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", "hu", ":")
map("n", "hj", "/")
map("n", "HJ", "?")
map("n", "x", '"_x', opts)
map("n", "<m-a>", "ggVG", opts)
map("n", "<m-h>", ":BufferLineCyclePrev<cr>", opts)
map("n", "<m-l>", ":BufferLineCycleNext<cr>", opts)
map("n", "<leader><m-h>", ":BufferLineMovePrev<cr>", opts)
map("n", "<leader><m-l>", ":BufferLineMoveNext<cr>", opts)
map("n", "<m-b>", "<cmd>Telescope buffers theme=dropdown<cr>", opts)
map("n", "qf", "<cmd>bwipeout<cr>", opts)
map("n", "<leader>cl", ":let @+ = expand('%:p')<cr>", opts)     -- copy current file path to clipboard
map("n", "ss", require("my.send").send_current_line, opts)
map("n", "sb", require("my.send").send_last_line, opts)
map("n", "gV", '`[v`]', opts)
map("n", "<leader>ps", ':PackerSync<cr>', opts)
map("n", "hl", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>ca", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<c-f>", "<cmd>Telescope grep_string<cr>", opts)
map("n", "<c-t>", "<cmd>NvimTreeToggle<cr>", opts)
map("n", "<leader>t", "<cmd>TSPlaygroundToggle<cr>", opts)
map("n", "<leader>hg", '<cmd>echo synIDattr(synID(line("."),col("."),1),"name")<cr>', opts)
map("n", "<leader>tl", '<cmd>lua toggle_lsp()<cr>', opts)
map("n", "c*", '*Ncgn', opts)
map("n", "d*", '*Ndgn', opts)
cancel("n", {">>", "<<", ":", "/", "?", "Q", "qq", "<bs>", "<del>", "<cr>", "<up>", "<down>", "<left>", "<right>"})
-- map("n", "<C-h>", "<C-w>h", opts)    -- switch window
-- map("n", "<C-l>", "<C-w>l", opts)

-- Insert
map("i", "jk", "<esc>", opts)
map("i", "qw", "<esc>:w<cr>", opts)
map("i", "<c-l>", "<c-x><c-l>", opts)
map("i", "<c-n>", "<Cmd>lua require('cmp').complete()<CR>", opts)
cancel("i", {"<esc>", "<del>", "<cr>", "<up>", "<down>", "<left>", "<right>"})

-- Visual
map("v", "<c-j>", "<gv", opts)
map("v", "<c-k>", ">gv", opts)
map("v", "hu", ":")
map("v", "p", '"_dP', opts)
map("v", "ss", '<esc><cmd>lua require("my.send").send_highlighted_lines()<cr>', opts)
map("v", "sf", "<Plug>(comment_toggle_linewise_visual)", opts)
map("v", "<c-f>", "y<esc><cmd>Telescope live_grep default_text=<c-r>0<cr>", opts)
map("v", "c", '*<esc>Ncgn', {remap = true})
map("v", "d", '*<esc>Ndgn', {remap = true})
cancel("v", {">", "<", "<esc>", ":"})

-- Command
map("c", "jk", "<c-c>", opts)
map("c", "%%", "<c-r>=expand('%:h').'/'<cr>", opts) -- expand current path
map("c", "%$", "<c-r>=expand('%').'/'<cr>", opts) -- expand current path
cancel("c", {"<esc>", "<del>"})

vim.cmd "source ~/.config/nvim/lua/keymap.vim"
