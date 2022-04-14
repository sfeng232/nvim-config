local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local ok2, ultisnips = pcall(require, "cmp_nvim_ultisnips")
if not ok2 then
  return
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

ultisnips.setup {
  filetype_source = "treesitter",
  show_snippets = "all",
  -- documentation = function(snippet)
  --   return snippet.description
  -- end
}

vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<tab>"
vim.g.UltiSnipsEditSplit = "vertical"
vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
vim.cmd [[noremap <leader>u :UltiSnipsEdit<cr>]]

cmp.setup {
  -- completion = {
  --   autocomplete = true,
  -- },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<m-k>"] = cmp.mapping.select_prev_item(),
    ["<m-j>"] = cmp.mapping.select_next_item(),
    -- ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    -- ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<tab>"] = cmp.config.disable,
    ["<C-c>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<c-j>"] = cmp.mapping.confirm { select = false }, -- select = false means only confirm explicitly selected item
  }),
  formatting = {
    fields = { "abbr", "menu", "kind" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      vim_item.menu = ({
        ultisnips = "snip",
        nvim_lsp = "lsp",
        nvim_lua = "lua",
        buffer = "buf",
        path = "path",
        rg = "rg",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = "ultisnips" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = 'rg' },
    { name = "path" },
  }),
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = false,
  },
  view = {
    entries = "native",
  }
}

cmp.setup.cmdline {
  mapping = cmp.mapping.preset.cmdline({
  })
}
