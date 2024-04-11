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
opt.tabstop = 2       -- the visible width of tabs
opt.softtabstop = 2   -- edit as if the tabs are 4 characters wide
opt.shiftwidth = 2    -- number of spaces to use for indent and unindent
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

g.mapleader = ","
