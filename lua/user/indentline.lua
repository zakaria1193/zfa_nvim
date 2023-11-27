local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#3f0d11" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#44310d" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#072a46" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#372311" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#223216" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#34103f" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#1e4c52" })
end)

require("ibl").setup {
  indent = { highlight = highlight },
  scope = { enabled = false },
}
