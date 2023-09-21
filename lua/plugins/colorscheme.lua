return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			local catppuccin = require('catppuccin')
			catppuccin.setup({
				integrtions = {
					cmp = true,
					nvimtree = true,
				}
			})
			vim.cmd([[colorscheme catppuccin-macchiato]])
		end
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
	},
	{
		"dracula/vim",
		name = "dracula",
		lazy = true,
	},
}
