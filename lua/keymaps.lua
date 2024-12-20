local nnoremap = vim.keymap.set
local silent = { silent = true }

-- Make ctrl-c behave like esc
-- nnoremap("!", "<C-c>", "<Esc>", silent)
-- nnoremap("n", "<C-c>", "<silent> <C-c>")

-- Run macro q
-- nnoremap({ 'n', 'v' }, "<C-q>", ":normal @q <CR>", silent)

-- Make global marks resume to prev line in buffer
-- nnoremap('n', "'M", "'M'\"zz")
-- nnoremap('n', "'N", "'N'\"zz")
-- nnoremap('n', "'J", "'J'\"zz")
-- nnoremap('n', "'K", "'K'\"zz")
-- nnoremap('n', "'L", "'L'\"zz")
-- nnoremap('n', "'H", "'H'\"zz")

nnoremap("n", "<C-f>", "<C-d>zz", silent)
nnoremap("n", "<C-b>", "<C-u>zz", silent)

-- resizing splits
-- local splits = require("smart-splits")
-- nnoremap('n', '<S-h>', splits.resize_left)
-- nnoremap('n', '<S-j>', splits.resize_down)
-- nnoremap('n', '<S-k>', splits.resize_up)
-- nnoremap('n', '<S-l>', splits.resize_right)

-- moving between splits
-- nnoremap('n', '<C-h>', splits.move_cursor_left)
-- nnoremap('n', '<C-j>', splits.move_cursor_down)
-- nnoremap('n', '<C-k>', splits.move_cursor_up)
-- nnoremap('n', '<C-l>', splits.move_cursor_right)

-- swapping buffers between windows
-- nnoremap('n', '<A-h>', splits.swap_buf_left)
-- nnoremap('n', '<A-j>', splits.swap_buf_down)
-- nnoremap('n', '<A-k>', splits.swap_buf_up)
-- nnoremap('n', '<A-l>', splits.swap_buf_right)

-- Fuzzy finding
-- local telescope = require('telescope.builtin')
-- nnoremap('n', '<C-e>', telescope.find_files)
-- nnoremap('n', '<C-g>', telescope.live_grep)
-- nnoremap('n', '<C-f>', telescope.buffers)

-- Open file explorer
nnoremap("n", "<leader>ee", ":Neotree toggle <CR>", silent)
nnoremap("n", "<leader>ef", ":Neotree reveal <CR>", silent)

-- paste without overwriting register
nnoremap("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- cpy to system register
nnoremap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system register" })
nnoremap("n", "<leader>Y", '"+Y', { desc = "Copy curr line to system register" })

nnoremap('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
nnoremap('n', '<C-p>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
nnoremap('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

nnoremap('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
nnoremap('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
nnoremap('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
nnoremap('n', '<leader>fw', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
nnoremap('n', '<leader>xx', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Format document
vim.keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
	{ silent = true, noremap = true, desc = "Format document" })

-- Open floatterm in float mode
vim.keymap.set('n', '<C-t>', ":ToggleTerm direction=float<CR>")
