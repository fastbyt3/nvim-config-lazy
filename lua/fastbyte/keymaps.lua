-- Toggle undo tree
vim.keymap.set("n", "<leader>ut", function()
	require("undotree").open()
end, { desc = "Toggle undotree" })

-- cpy to system register
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system register" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy curr line to system register" })

-- Do not copy whitespace when using $ in visual mode
vim.keymap.set("x", "$", "g_", { desc = "Select till end of line" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "{", "{zz", { desc = "Jump to previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Jump to next paragraph and center" })
vim.keymap.set("n", "N", "Nzz", { desc = "Search previous and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Search next and center" })
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Go to beginning of file and center" })
vim.keymap.set("n", "gd", "gdzz", { desc = "Go to definition and center" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Jump forward in jump list and center" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Jump backward in jump list and center" })
vim.keymap.set("n", "%", "%zz", { desc = "Jump to matching bracket and center" })
vim.keymap.set("n", "*", "*zz", { desc = "Search for word under cursor and center" })
vim.keymap.set("n", "#", "#zz", { desc = "Search backward for word under cursor and center" })

-- Turn off highlighted search results
vim.keymap.set("n", "<leader>no", "<cmd>noh<cr>", { desc = "Toggle search highlighting" })

-- Diagnostics --
vim.keymap.set("n", "]d", function()
	local ok = pcall(vim.diagnostic.jump, { count = 1, float = false })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to next diagnostic and center" })

vim.keymap.set("n", "[d", function()
	local ok = pcall(vim.diagnostic.jump, { count = -1, float = false })
	if ok then
		vim.api.nvim_feedkeys("zz", "n", false)
	end
end, { desc = "Go to previous diagnostic and center" })

-- Quickfix navigation
vim.keymap.set("n", "<leader>cn", ":cnext<cr>zz", { desc = "Go to next quickfix item and center" })
vim.keymap.set("n", "<leader>cp", ":cprevious<cr>zz", { desc = "Go to previous quickfix item and center" })
vim.keymap.set("n", "<leader>co", ":copen<cr>zz", { desc = "Open quickfix list and center" })
vim.keymap.set("n", "<leader>cc", ":cclose<cr>zz", { desc = "Close quickfix list" })

-- Format current buffer
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({
		async = true,
		timeout_ms = 500,
		lsp_format = "fallback",
	})
end, { desc = "Format the current buffer" })

-- This keymap indents the selected visual block to the left and reselects it
vim.keymap.set("x", "<<", function()
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end, { desc = "Indent left and reselect visual block" })

vim.keymap.set("x", ">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end, { desc = "Indent right and reselect visual block" })

local M = {}

-- FzfLua Keybinds
M.map_fzflua_keybinds = function()
	local fzflua = require("fzf-lua")
	vim.keymap.set("n", "<C-p>", fzflua.buffers, { desc = "Buffer picker" })
	vim.keymap.set("n", "<leader>ff", fzflua.files, { desc = "File picker" })
	vim.keymap.set("n", "<leader>fw", fzflua.live_grep, { desc = "Live grep across worspace" })
	vim.keymap.set("n", "<leader>/", function()
		require("fzf-lua").lgrep_curbuf({ previewer = false })
	end, { desc = "Live grep current buff" })
	vim.keymap.set("v", "<leader>fw", fzflua.grep_visual, { desc = "Grep visual selection in workspace" })
	vim.keymap.set("n", "<leader>fW", fzflua.grep_cword, { desc = "Grep current word in worspace" })
	vim.keymap.set("n", '<leader>f"', fzflua.registers, { desc = "Register picker" })
	vim.keymap.set("n", "<leader>fo", function()
		fzflua.colorschemes({ winopts = { height = 0.45, width = 0.30 } })
	end, { desc = "Colorscheme picker" })
	vim.keymap.set("n", "<leader>ld", fzflua.lsp_definitions, { desc = "LSP definitions" })
	vim.keymap.set("n", "<leader>lr", fzflua.lsp_references, { desc = "LSP references" })
	vim.keymap.set("n", "<leader>li", fzflua.lsp_implementations, { desc = "LSP implementations" })
	vim.keymap.set("n", "<leader>ls", fzflua.lsp_document_symbols, { desc = "LSP current buffer symbols" })
	vim.keymap.set("n", "<leader>lS", fzflua.lsp_live_workspace_symbols, { desc = "LSP workspace symbols" })
	vim.keymap.set("n", "<leader>xx", fzflua.lsp_workspace_diagnostics, { desc = "LSP workspace diagnostics" })
end

-- LSP Keybinds (per-buffer)
M.map_lsp_keybinds = function(buffer_number)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol", buffer = buffer_number })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action", buffer = buffer_number })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition", buffer = buffer_number })

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

-- Treesitter selection + textobjects
local treesitter_select = function()
	if not vim.treesitter.get_parser(0, nil, { error = false }) then
		return nil
	end

	local ok, select = pcall(require, "vim.treesitter._select")
	if ok then
		return select
	end

	return nil
end

local treesitter_select_parent = function()
	local select = treesitter_select()
	if select then
		select.select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end

local treesitter_select_child = function()
	local select = treesitter_select()
	if select then
		select.select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end

local treesitter_select_scope = function()
	local ok = pcall(require("nvim-treesitter-textobjects.select").select_textobject, "@local.scope", "locals")
	if not ok then
		treesitter_select_parent()
	end
end

local treesitter_textobject = function(query, query_group)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, query_group or "textobjects")
	end
end

local treesitter_move = function(method, query, query_group)
	return function()
		require("nvim-treesitter-textobjects.move")[method](query, query_group or "textobjects")
	end
end

vim.keymap.set("n", "<C-Space>", function()
	if treesitter_select() then
		vim.cmd.normal({ "van", bang = true })
	else
		vim.lsp.buf.selection_range(1)
	end
end, { desc = "Treesitter: Start incremental selection" })

vim.keymap.set("x", "<C-Space>", treesitter_select_parent, { desc = "Treesitter: Expand selection" })
vim.keymap.set("x", "<C-s>", treesitter_select_scope, { desc = "Treesitter: Expand to scope" })
vim.keymap.set("x", "<C-BS>", treesitter_select_child, { desc = "Treesitter: Shrink selection" })
vim.keymap.set("x", "<C-h>", treesitter_select_child, { desc = "Treesitter: Shrink selection" })

vim.keymap.set({ "x", "o" }, "aa", treesitter_textobject("@parameter.outer"), { desc = "Select outer parameter" })
vim.keymap.set({ "x", "o" }, "ia", treesitter_textobject("@parameter.inner"), { desc = "Select inner parameter" })
vim.keymap.set({ "x", "o" }, "af", treesitter_textobject("@function.outer"), { desc = "Select outer function" })
vim.keymap.set({ "x", "o" }, "if", treesitter_textobject("@function.inner"), { desc = "Select inner function" })
vim.keymap.set({ "x", "o" }, "ac", treesitter_textobject("@class.outer"), { desc = "Select outer class" })
vim.keymap.set({ "x", "o" }, "ic", treesitter_textobject("@class.inner"), { desc = "Select inner class" })

vim.keymap.set(
	{ "n", "x", "o" },
	"]m",
	treesitter_move("goto_next_start", "@function.outer"),
	{ desc = "Next function start" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"]]",
	treesitter_move("goto_next_start", "@class.outer"),
	{ desc = "Next class start" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"]M",
	treesitter_move("goto_next_end", "@function.outer"),
	{ desc = "Next function end" }
)
vim.keymap.set({ "n", "x", "o" }, "][", treesitter_move("goto_next_end", "@class.outer"), { desc = "Next class end" })
vim.keymap.set(
	{ "n", "x", "o" },
	"[m",
	treesitter_move("goto_previous_start", "@function.outer"),
	{ desc = "Previous function start" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"[[",
	treesitter_move("goto_previous_start", "@class.outer"),
	{ desc = "Previous class start" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"[M",
	treesitter_move("goto_previous_end", "@function.outer"),
	{ desc = "Previous function end" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"[]",
	treesitter_move("goto_previous_end", "@class.outer"),
	{ desc = "Previous class end" }
)

return M
