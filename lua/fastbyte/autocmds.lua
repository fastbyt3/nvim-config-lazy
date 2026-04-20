-- local treesitter_group = vim.api.nvim_create_augroup("fastbyte-treesitter-main", { clear = true })
--
-- -- Main autocmd for starting Treesitter
-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
--     group = treesitter_group,
--     callback = function(args)
--         local buf = args.buf
--
--         -- Skip special buffers
--         if vim.bo[buf].buftype ~= "" then
--             return
--         end
--
--         local filetype = vim.bo[buf].filetype
--         if filetype == "" then
--             return
--         end
--
--         -- Start highlighting (safest timing)
--         pcall(vim.treesitter.start, buf)
--
--         -- Handle indentation only if the language has indent queries
--         local lang = vim.treesitter.language.get_lang(filetype)
--         if not lang then
--             return
--         end
--
--         local has_indents = pcall(function()
--             return vim.treesitter.query.get(lang, "indents")
--         end)
--
--         if has_indents then
--             vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--         end
--     end,
-- })
--
-- -- Optional: Extra safety net on FileType (helps with some edge cases)
-- vim.api.nvim_create_autocmd("FileType", {
--     group = treesitter_group,
--     callback = function(args)
--         pcall(vim.treesitter.start, args.buf)
--     end,
-- })
--

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "Highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- Toggle Diagnostics via Snacks
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
	Snacks.toggle.diagnostics():toggle()
end, {})

local Path = require("plenary.path")

-- Copy current buffer's project relative file path to clipboard
vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
	-- Get the current buffer's file path
	local file_path = vim.api.nvim_buf_get_name(0)

	-- Create a Path object for the current directory and get the parent directory
	local project_root_parent_dir = Path:new(vim.fn.getcwd()):parent():absolute()

	-- Create a Path object for the file
	local path_obj = Path:new(file_path)

	-- Get the relative path from the project root
	local relative_path = path_obj:make_relative(project_root_parent_dir)

	-- Copy the relative path to the system clipboard
	vim.fn.setreg("+", relative_path)
end, {})

vim.api.nvim_create_user_command("CFP", function()
	vim.cmd(":CopyFilePathToClipboard")
end, {})
