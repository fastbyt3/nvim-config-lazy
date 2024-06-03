-- Install plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

-- Install and configure plugins
require('lazy').setup({

	-- Colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			term_colors = true,
			transparent_background = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
			},
			integrations = {
				telescope = {
					enabled = true,
					style = "nvchad",
				},
				dropbar = {
					enabled = true,
					color_mode = true,
				},
			},
		},
		-- config = function()
		-- 	require("plugin_configs.catppuccin")
		-- end
	},
	{
		'maxmx03/solarized.nvim',
		lazy = false,
		priority = 1000,
	},

	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	{
		'ethanholz/nvim-lastplace',
		config = function()
			require("nvim-lastplace")
		end
	},

	-- Icons
	{
		'nvim-tree/nvim-web-devicons',
		config = function()
			require("plugin_configs.devicons")
		end
	},

	-- Makes resizing splits more intuitive
	{
		'mrjones2014/smart-splits.nvim',
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("plugin_configs.neotree")
		end
	},

	-- RBG color highlighting
	{
		'norcalli/nvim-colorizer.lua',
		config = function()
			require("colorizer").setup()
		end
	},

	-- Scrollbar + diagnostics on the right side
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("plugin_configs.scrollbar")
		end
	},

	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require("bufferline").setup()
		end
	},

	-- Markdown previewing (using browser)
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- Statusline
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("plugin_configs.lualine")
		end
	},

	-- "gc" to comment visual regions/lines
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},

	-- Fuzzy Finder
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require("plugin_configs.telescope")
		end
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},

	-- Add indentation guides even on blank lines
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {},
		config = function()
			require("ibl").setup()
		end
	},

	-- LSP Configuration & Plugins
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{
				'williamboman/mason.nvim',
				config = true
			},
			'williamboman/mason-lspconfig.nvim',
			{
				'j-hui/fidget.nvim',
				tag = 'legacy',
				opts = {}
			},
			'folke/neodev.nvim',
		},
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
		config = function()
			require("plugin_configs.cmp")
		end
	},

	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',

		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			require("plugin_configs.treesitter")
		end
	},

	-- Adds git releated signs to the gutter, as well as utilities for managing changes
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			-- on_attach = function(bufnr)
			-- 	vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
			-- 		{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
			-- 	vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
			-- 		{ buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
			-- 	vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
			-- 		{ buffer = bufnr, desc = '[P]review [H]unk' })
			-- end,
		}
	},

	-- Rust
	-- {
	-- 	'mrcjkb/rustaceanvim',
	-- 	version = '^4', -- Recommended
	-- 	ft = { 'rust' },
	-- 	config = function()
	-- 		require('plugin_configs.rustacean')
	-- 	end
	-- },
	{
		'saecki/crates.nvim',
		tag = 'stable',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup()
		end,
	},

	-- gleam
	{
		"gleam-lang/gleam.vim"
	},

	-- whichKey
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		lazy = true,
	},

	-- autopairs
	{
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)

			-- setup cmp for autopairs
			local cmp_autopairs = require "nvim-autopairs.completion.cmp"
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
})
