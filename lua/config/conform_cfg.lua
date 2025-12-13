vim.api.nvim_create_user_command("ConformDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable conform-autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("ConformEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable conform-autoformat-on-save",
})

require("conform").setup({
	notify_on_error = false,
	default_format_opts = {
		async = true,
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		css = { "prettierd", stop_after_first = true },
		html = { "prettierd", stop_after_first = true },
		yaml = { "prettierd", stop_after_first = true },
		jsonc = { "prettierd", stop_after_first = true },
		json = { "prettierd", stop_after_first = true },
		javascript = { "biome", "prettierd", stop_after_first = true },
		typescript = { "biome", "prettierd", stop_after_first = true },
		typescriptreact = { "biome", "prettierd", stop_after_first = true },
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
	formatters = {
		biome = {
			condition = function(_, ctx)
				return vim.fs.find({ "biome.json", "biome.jsonc" }, {
					path = ctx.filename,
					upward = true,
					stop = vim.uv.os_homedir(),
				})[1] ~= nil
			end,
		},
		prettierd = {
			condition = function(_, ctx)
				return vim.fs.find({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
				}, {
					path = ctx.filename,
					upward = true,
					stop = vim.uv.os_homedir(),
				})[1] ~= nil
			end,
		},
	},
})
