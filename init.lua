local opt = vim.opt
local cmd = vim.cmd
local g = vim.g
local o = vim.o
local fn = vim.fn
local env = vim.env

opt.backup = false -- don't use backup files
opt.writebackup = false -- don't backup the file while editing
opt.swapfile = false -- don't create swap files for new buffers
opt.updatecount = 0 -- don't write swap files after some number of updates

opt.history = 1000 -- store the last 1000 commands entered
opt.textwidth = 120 -- after configured number of characters, wrap line

-- searching
opt.ignorecase = true -- case insensitive searching
opt.smartcase = true -- case-sensitive if expresson contains a capital letter
opt.hlsearch = true -- highlight search results
opt.incsearch = true -- set incremental search, like modern browsers
opt.lazyredraw = false -- don't redraw while executing macros
opt.magic = true -- set magic on, for regular expressions


-- error bells
opt.errorbells = false
opt.visualbell = true
opt.timeoutlen = 500

-- Appearance
o.termguicolors = true
opt.number = true -- show line numbers
opt.wrap = true -- turn on line wrapping
opt.wrapmargin = 8 -- wrap lines when coming within n characters from side
opt.linebreak = true -- set soft wrapping
opt.showbreak = "↪"
opt.autoindent = true -- automatically set indent of new line
opt.ttyfast = true -- faster redrawing

-- Tab control
opt.smarttab = true -- tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
opt.tabstop = 4 -- the visible width of tabs
opt.softtabstop = 4 -- edit as if the tabs are 4 characters wide
opt.shiftwidth = 4 -- number of spaces to use for indent and unindent
opt.shiftround = true -- round indent to a multiple of 'shiftwidth'

-- Mappings
g.mapleader = ","

require("lazypkg")
