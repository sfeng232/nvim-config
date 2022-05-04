local capabilitiesWithoutFomatting = vim.lsp.protocol.make_client_capabilities()
capabilitiesWithoutFomatting.textDocument.formatting = false
capabilitiesWithoutFomatting.textDocument.rangeFormatting = false
capabilitiesWithoutFomatting.textDocument.range_formatting = false

local opts = {
  settings = {
    documentFormatting = false
  },
  capabilities = capabilitiesWithoutFomatting,
  init_options = {
    hostInfo = "neovim",
    preferences = {
      disableSuggestions = true,
    },
  },
}

return opts
