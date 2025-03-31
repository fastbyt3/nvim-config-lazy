local utils = require("utils")
local api = vim.api
local fn = vim.fn

api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	group = api.nvim_create_augroup("git_repo_check", { clear = true }),
	pattern = "*",
	desc = "check if we are inside Git repo",
	callback = function()
		utils.inside_git_repo()
	end,
})

api.nvim_create_autocmd("BufReadPre", {
	group = api.nvim_create_augroup("large_file", { clear = true }),
	pattern = "*",
	desc = "optimize for large file",
	callback = function(ev)
		local file_size_limit = 524288 -- 0.5MB
		local f = ev.file

		if fn.getfsize(f) > file_size_limit or fn.getfsize(f) == -2 then
			vim.o.eventignore = "all"
			--  turning off relative number helps a lot
			vim.wo.relativenumber = false

			vim.bo.swapfile = false
			vim.bo.bufhidden = "unload"
			vim.bo.undolevels = -1
		end
	end,
})

api.nvim_create_autocmd({ "FileType" }, {
	desc = "Disable indentscope for certain filetypes",
	callback = function()
		local ignore_filetypes = {
			"snacks_dashboard",
			"aerial",
			"dashboard",
			"help",
			"snacks_dashboard",
			"lazy",
			"leetcode.nvim",
			"mason",
			"neo-tree",
			"NvimTree",
			"neogitstatus",
			"notify",
			"startify",
			"toggleterm",
			"Trouble",
		}
		if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
			vim.b.miniindentscope_disable = true
		end
	end,
})

api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(vim.lsp.status(), "info", {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

-- Format on save -> taken care by conform so commented out
-- api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })
