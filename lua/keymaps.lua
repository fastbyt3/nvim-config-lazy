local map = vim.keymap.set
-- local utils = require("utils")

map("n", "<C-f>", "<C-d>zz", { silent = true })
map("n", "<C-b>", "<C-u>zz", { silent = true })

map("n", "gg", "ggzz", { desc = "Go to beginning of file and center" })

map("n", "G", "Gzz", { desc = "Go to end of file and center" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
map("x", "$", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Use Esc to quit builtin terminal
map("t", "<Esc>", [[<c-\><c-n>]])

-- cpy to system register
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system register" })
map("n", "<leader>Y", '"+Y', { desc = "Copy curr line to system register" })

-- Diagnostic keymaps
-- map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to previous diagnostic message" })
-- map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic message" })
-- map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Format document -> using conform
-- map(
-- 	"n",
-- 	"<leader>lf",
-- 	"<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
-- 	{ silent = true, noremap = true, desc = "Format document" }
-- )

-- Double esc to clear search highlight
map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR>", { silent = true })

-- Search and Replace
-- 'c.' for word, 'c>' for WORD
-- 'c.' in visual mode for selection
map("n", "c.", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "search and replace word under cursor" })
map("n", "c>", [[:%s/\V<C-r><C-a>//g<Left><Left>]], { desc = "search and replace WORD under cursor" })
map("x", "c.", [[:<C-u>%s/\V<C-r>=luaeval("require'utils'.get_visual_selection(true)")<CR>//g<Left><Left>]], {})

-- Quickfix navigation
vim.keymap.set("n", "<leader>cn", ":cnext<cr>zz", { desc = "Go to next quickfix item and center" })
vim.keymap.set("n", "<leader>cp", ":cprevious<cr>zz", { desc = "Go to previous quickfix item and center" })
vim.keymap.set("n", "<leader>cc", ":cclose<cr>zz", { desc = "Close quickfix list" })

-- Copilot chat
map("n", "<space>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
