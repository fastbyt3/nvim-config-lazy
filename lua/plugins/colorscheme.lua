return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				-- float = {
				-- 	-- transparent = true,
				-- 	-- solid = false,
				-- },
				integrations = {
					diffview = true,
					fidget = true,
					fzf = true,
					harpoon = true,
					mason = true,
					native_lsp = { enabled = true },
					noice = true,
					notify = true,
					symbols_outline = true,
					snacks = {
						enabled = true,
						indent_scope_color = "mauve",
					},
					render_markdown = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					ufo = true,
					which_key = true,
				},
			})
			-- local palette = require("catppuccin.palettes").get_palette("macchiato")
			-- vim.cmd.colorscheme("catppuccin-macchiato")

			-- Hide all semantic highlights until upstream issues are resolved (https://github.com/catppuccin/nvim/issues/480)
			-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			-- 	vim.api.nvim_set_hl(0, group, {})
			-- end
		end,
	},
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
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
	},
}
