local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
	-- auto-completion engine
	{
		"hrsh7th/nvim-cmp",
		name = "nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				lazy = false,
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					--`friendly-snippets` contains a variety of premade snippets.
					-- https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"pyright",
				"eslint",
				"ruff",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	-- {
	--   "WhoIsSethDaniel/mason-tool-installer.nvim",
	--   opts = {
	--     ensure_installed = {
	--       "prettier", -- prettier formatter
	--       "stylua", -- lua formatter
	--       "isort", -- python formatter
	--       "black", -- python formatter
	--       "pylint",
	--       "eslint_d",
	--     },
	--   },
	--   dependencies = {
	--     "williamboman/mason.nvim",
	--   },
	-- },

	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		branch = "master",
		config = function()
			require("config.treesitter-textobjects")
		end,
	},
	-- replaced by mini.cursorword
	-- {
	-- 	"RRethy/vim-illuminate",
	-- 	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	-- 	lazy = true,
	-- },
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "FzfLua" },
		config = function()
			require("config.fzflua")
		end,
	},
	-- Colorschemes
	{
		"navarasu/onedark.nvim",
		lazy = true,
		opts = {
			toggle_style_key = "<leader>ts",
		},
	},
	{ "sainnhe/gruvbox-material", lazy = true },
	{ "sainnhe/everforest", lazy = true },
	{
		"nordtheme/vim",
		lazy = true,
	},
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").load()
		end,
	},
	"EdenEast/nightfox.nvim",
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		config = function()
			-- require("config.catppuccin_colors")
		end,
	},
	{ "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("config.lualine")
		end,
	},

	{
		"akinsho/bufferline.nvim",
		event = { "BufEnter" },
		config = function()
			require("config.bufferline")
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "VeryLazy",
		opts = {},
		init = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		config = function()
			require("config.nvim_ufo")
		end,
	},

	-- notification plugin
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			require("config.nvim-notify")
		end,
	},

	-- Manage your yank history
	-- {
	--   "gbprod/yanky.nvim",
	--   config = function()
	--     require("config.yanky")
	--   end,
	--   event = "VeryLazy",
	-- },
	--

	-- showing keybindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("config.which-key")
		end,
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = function()
			return require("config.snacks").opts
		end,
		keys = function()
			return require("config.snacks").keys
		end,
	},

	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		opts = {
			window = {
				width = 30,
			},
			filesystem = {
				filtered_items = {
					show_hidden_count = false,
				},
			},
		},
		keys = {
			{
				"<leader>ee",
				":Neotree toggle<cr>",
				desc = "Toggle neotree",
			},
			{
				"<leader>ef",
				":Neotree reveal<cr>",
				desc = "Reveal curr file in neotree",
			},
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = { -- set to setup table
		},
	},

	-- Git command inside vim
	{
		"tpope/vim-fugitive",
		event = "User InGitRepo",
		config = function()
			require("config.fugitive")
		end,
	},

	-- Better git log display
	{ "rbong/vim-flog", cmd = { "Flog" } },
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	{
		"ruifm/gitlinker.nvim",
		event = "User InGitRepo",
		config = function()
			require("config.git-linker")
		end,
	},

	-- Show git change (change, delete, add) signs in vim sign column
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config.gitsigns")
		end,
	},

	-- {
	-- 	"sindrets/diffview.nvim",
	-- },

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			require("config.conform_cfg")
		end,
		keys = {
			{
				"<leader>lf",
				function()
					require("conform")
				end,
				desc = "format buffer",
			},
		},
	},

	-- Go pkgs
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},

	{
		"echasnovski/mini.nvim",
		version = false,
		event = { "BufRead", "BufNewFile" },
		config = function()
			require("config.mini")
		end,
	},

	-- Rust
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
	},

	-- Elixir
	{
		"elixir-tools/elixir-tools.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- lifesaver =)
	{
		"mbbill/undotree",
		event = { "BufReadPost" },
		lazy = true,
	},

	-- markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			-- heading = {
			-- 	enabled = false,
			-- 	-- atx = true,
			-- 	-- setext = true,
			-- },
			overrides = { buftype = { ["nofile"] = { enabled = false } } }, -- disables for lsp
		},
	},

	-- Grug find! Grug replace! Grug Happy!
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
			"github/copilot.vim",
		},
		build = "make tiktoken",
		config = function()
			require("config.copilot-chat")
		end,
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("config.tiny-inline-diagnostic")
		end,
	},

	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
}

require("lazy").setup({
	spec = plugin_specs,
	install = { colorscheme = { "catppuccin" } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		border = "rounded",
		title = "Plugin Manager",
		title_pos = "center",
	},
	rocks = {
		enabled = false,
		hererocks = false,
	},
})
