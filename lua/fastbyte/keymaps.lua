-- cpy to system register
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system register" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy curr line to system register" })

local M = {}

-- LSP Keybinds (per-buffer)
M.map_lsp_keybinds = function(buffer_number)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol", buffer = buffer_number })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action", buffer = buffer_number })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition", buffer = buffer_number })
	-- vim.keymap.set(
	-- 	"n",
	-- 	"gr",
	-- 	require("telescope.builtin").lsp_references,
	-- 	{ desc = "LSP: Go to references", buffer = buffer_number }
	-- )
	-- vim.keymap.set(
	-- 	"n",
	-- 	"gi",
	-- 	require("telescope.builtin").lsp_implementations,
	-- 	{ desc = "LSP: Go to implementations", buffer = buffer_number }
	-- )
	-- vim.keymap.set(
	-- 	"n",
	-- 	"<leader>bs",
	-- 	require("telescope.builtin").lsp_document_symbols,
	-- 	{ desc = "LSP: Document symbols", buffer = buffer_number }
	-- )
	-- vim.keymap.set(
	-- 	"n",
	-- 	"<leader>ps",
	-- 	require("telescope.builtin").lsp_workspace_symbols,
	-- 	{ desc = "LSP: Workspace symbols", buffer = buffer_number }
	-- )

	local signature_help = function()
		return vim.lsp.buf.signature_help({ border = "rounded" })
	end

	local hover = function()
		return vim.lsp.buf.hover({ border = "rounded" })
	end

	vim.keymap.set("n", "K", hover, { desc = "LSP: Signature help", buffer = buffer_number })

	vim.keymap.set("i", "<C-k>", signature_help, { desc = "LSP: Signature help", buffer = buffer_number })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration", buffer = buffer_number })
	vim.keymap.set("n", "td", vim.lsp.buf.type_definition, { desc = "LSP: Type definition", buffer = buffer_number })
end

return M
