local vim = vim
local opt = vim.opt
local cmd = vim.cmd
local g = vim.g
local o = vim.o
local fn = vim.fn
local env = vim.env

opt.backup = false      -- don't use backup files
opt.writebackup = false -- don't backup the file while editing
opt.swapfile = false    -- don't create swap files for new buffers
opt.updatecount = 0     -- don't write swap files after some number of updates

opt.history = 1000      -- store the last 1000 commands entered
-- opt.textwidth = 120 -- after configured number of characters, wrap line

-- searching
opt.ignorecase = true  -- case insensitive searching
opt.smartcase = true   -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true    -- highlight search results
opt.incsearch = true   -- set incremental search, like modern browsers
opt.lazyredraw = false -- don't redraw while executing macros
opt.magic = true       -- set magic on, for regular expressions


-- error bells
opt.errorbells = false
opt.visualbell = true
opt.timeoutlen = 500

-- Appearance
o.termguicolors = true
opt.number = true         -- show line numbers
opt.relativenumber = true -- show line numbers
opt.wrap = true           -- turn on line wrapping
-- opt.wrapmargin = 8 -- wrap lines when coming within n characters from side
opt.linebreak = true      -- set soft wrapping
opt.showbreak = "↪"
opt.autoindent = true     -- automatically set indent of new line
opt.ttyfast = true        -- faster redrawing

-- Tab control
opt.smarttab = true   -- tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
opt.tabstop = 4       -- the visible width of tabs
opt.softtabstop = 4   -- edit as if the tabs are 4 characters wide
opt.shiftwidth = 4    -- number of spaces to use for indent and unindent
opt.shiftround = true -- round indent to a multiple of 'shiftwidth'

-- highlight current line number alone
opt.cursorline = true
opt.cursorlineopt = "number"

--[[
-- Ruler(120 chars) except for md
_G.setup_vertical_ruler = function()
	local filetype = vim.bo.filetype
	if filetype ~= 'markdown' then
		cmd('setlocal colorcolumn=120')
	else
		cmd('setlocal colorcolumn=')
	end
end

cmd('autocmd BufEnter * lua setup_vertical_ruler()')
setup_vertical_ruler()
]]
--

-- Terraform file recognition
cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
cmd([[let g:terraform_fmt_on_save=1]])
cmd([[let g:terraform_align=1]])

-- Add `templ` as filetype
vim.filetype.add({ extension = { templ = "templ" } })

-- templ format
vim.api.nvim_create_autocmd({ "BufWritePost" },
	{ -- IDK the docs said to do the format before saving the file, but it only makes the formatter freak out.
		pattern = { "*.templ" },
		callback = function()
			local file_name = vim.api.nvim_buf_get_name(0) -- Get file name of file in current buffer
			vim.cmd(":silent !templ fmt " .. file_name)

			local bufnr = vim.api.nvim_get_current_buf()
			if vim.api.nvim_get_current_buf() == bufnr then
				vim.cmd('e!')
			end
		end
	})

-- Go format on save
-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.go",
-- 	callback = function()
-- 		require('go.format').gofmt()
-- 	end,
-- 	group = format_sync_grp,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if not client then return end
--
-- 		local callbackFn = nil
--
-- 		if vim.bo.filetype == 'go' then
-- 			callbackFn = require('go.format').gofmt
-- 		elseif client.supports_method("textDocument/formatting") then
-- 			callbackFn = function()
-- 				vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
-- 			end
-- 		end
-- 		if callbackFn then
-- 			vim.api.nvim_create_autocmd('BufWritePre', {
-- 				buffer = args.buf,
-- 				callback = callbackFn,
-- 			})
-- 		end
-- 	end
-- })

g.mapleader = ","
