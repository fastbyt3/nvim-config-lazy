require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		css = { "prettier", "prettierd", stop_after_first = true },
		html = { "prettier", "prettierd", stop_after_first = true },
		yaml = { "prettier", "prettierd", stop_after_first = true },
		jsonc = { "prettier", "prettierd", stop_after_first = true },
		json = { "prettier", "prettierd", stop_after_first = true },
		javascript = { "prettier", "prettierd", stop_after_first = true },
		go = { "goimports", "gofmt" },
		terraform = { "terraform_fmt" },
	},
	format_on_save = function(bufnr)
		-- disable for these filetypes
		local ignore_filetypes = { "sql", "java" }
		if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
			return
		end

		-- disable for files in node_modules
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/node_modules/") then
			return
		end

		-- disable autoformat if set for workspace / buffer
		if vim.g.disable_autoformat or vim.b.disable_autoformat then
			return
		end

		return {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
})

-- FormatToggle will toggle formatting for workspace
-- FormatToggle! will toggle formatting just for curr buffer
vim.api.nvim_create_user_command("FormatToggle", function(args)
	if args.bang then
		vim.b.disable_autoformat = not vim.b.disable_autoformat
	else
		vim.g.disable_autoformat = not vim.g.disable_autoformat
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
