local keymap = vim.keymap -- for conciseness

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }

		-- set keybinds
		opts.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>FzfLua lsp_references<CR>", opts) -- show definition, references

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

		opts.desc = "Show LSP definition"
		keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definition

		opts.desc = "Open definition in split"
		keymap.set("n", "<leader>gdv", function()
			vim.cmd("vsplit")
			vim.lsp.buf.definition()
		end, opts)

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts) -- show lsp implementations

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", opts) -- show lsp type definitions

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

		-- opts.desc = "Show buffer diagnostics"
		-- keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

		-- opts.desc = "Show line diagnostics"
		-- keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts) -- jump to previous diagnostic in buffer
		--
		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts) -- jump to next diagnostic in buffer

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

		opts.desc = "Show signature help for method"
		keymap.set({ "n", "i" }, "<C-h>", function()
			vim.lsp.buf.signature_help({ border = "rounded", title_pos = "right" })
		end)

		opts.desc = "Toggle inlay hints"
		keymap.set("n", "<leader>lti", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end)

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
	end,
})

-- local severity = vim.diagnostic.severity

-- vim.diagnostic.config({
-- plugin tiny-inline-diagnostic.nvim is used so diagnostic is disabled
-- underline = false,
-- virtual_text = false,
-- virtual_lines = false,
-- signs = {
-- 	text = {
-- 		[severity.ERROR] = " ",
-- 		[severity.WARN] = " ",
-- 		[severity.HINT] = "󰠠 ",
-- 		[severity.INFO] = " ",
-- 	},
-- },
-- float = {
-- 	source = true,
-- 	header = "Diagnostics:",
-- 	prefix = " ",
-- 	border = "single",
-- },
-- })

-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	pattern = "*",
-- 	callback = function()
-- 		if #vim.diagnostic.get(0) == 0 then
-- 			return
-- 		end
--
-- 		if not vim.b.diagnostics_pos then
-- 			vim.b.diagnostics_pos = { nil, nil }
-- 		end
--
-- 		local cursor_pos = vim.api.nvim_win_get_cursor(0)
-- 		if cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2] then
-- 			vim.diagnostic.open_float()
-- 		end
--
-- 		vim.b.diagnostics_pos = cursor_pos
-- 	end,
-- })
