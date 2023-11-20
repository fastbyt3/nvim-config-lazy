local vim = vim
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
-- opt.textwidth = 120 -- after configured number of characters, wrap line

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
opt.relativenumber = true -- show line numbers
opt.wrap = true -- turn on line wrapping
-- opt.wrapmargin = 8 -- wrap lines when coming within n characters from side
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

-- highlight current line number alone
opt.cursorline = true
opt.cursorlineopt="number"

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

-- Mappings
g.mapleader = ","

vim.api.nvim_set_keymap('n', '<C-f>', '<C-d>', { noremap = true, silent = true }) -- jump half page down
vim.api.nvim_set_keymap('n', '<C-b>', '<C-u>', { noremap = true, silent = true }) -- jump half page up

-- Inc / Dec search
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Previous search result' })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<NOP>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<ESC>', ':noh<CR>', { silent = true })

-- remap quit and write to use leader key
-- vim.api.nvim_set_keymap('n', ',qq', ':q<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', ',ww', ':w<CR>', { noremap = true, silent = true })

require("lazypkg")
