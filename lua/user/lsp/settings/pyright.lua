local lspconfig = require("lspconfig")

lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}
