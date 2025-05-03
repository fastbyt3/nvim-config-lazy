require("globals")
require("keymaps")
require("custom-autocmd")
require("plugins")

vim.cmd.colorscheme("everforest")
-- set this for everforest to have the lsp signature highlight current arg in readable color
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#3a3a3a", fg = "#ffffff" })
