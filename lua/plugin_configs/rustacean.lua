vim.g.rustaceanvim = {
	tools = {
		enable_clippy = true,
		reload_workspace_from_cargo_toml = true,
		hover_actions = {
			auto_focus = false,
		},
	},
	-- LSP configuration
	server = {
		on_attach = function(_, bufnr)
			-- you can also put keymaps in here
			vim.keymap.set(
				"n",
				"<leader>ca",
				function()
					vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
					-- or vim.lsp.buf.codeAction() if you don't want grouping.
				end,
				{ silent = true, buffer = bufnr }
			)
		end,
		default_settings = {
			-- rust-analyzer language server configuration
			['rust-analyzer'] = {
			},
		},
	},
	-- DAP configuration
	dap = {
	},
}
