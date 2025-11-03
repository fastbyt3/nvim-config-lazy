require("globals")
require("keymaps")
require("custom-autocmd")
require("plugins")
require("lsp")

vim.cmd.colorscheme("catppuccin-mocha")
-- set this for everforest to have the lsp signature highlight current arg in readable color
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#3a3a3a", fg = "#ffffff" })
