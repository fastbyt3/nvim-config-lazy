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
		config = function ()
			require('rose-pine').setup({
				--- @usage 'auto'|'main'|'moon'|'dawn'
				variant = 'moon',
				--- @usage 'main'|'moon'|'dawn'
				dark_variant = 'moon',
				bold_vert_split = false,
				dim_nc_background = false,
				disable_background = false,
				disable_float_background = false,
				disable_italics = true,
				highlight_groups = {
					ColorColumn = { bg = 'rose' },

					-- Blend colours against the "base" background
					CursorLine = { bg = 'foam', blend = 10 },
					StatusLine = { fg = 'love', bg = 'love', blend = 10 },

					-- By default each group adds to the existing config.
					-- If you only want to set what is written in this config exactly,
					-- you can set the inherit option:
					Search = { bg = 'gold', inherit = false },
				}
			})

			-- vim.cmd([[colorscheme rose-pine]])
		end
	},
	{
		"dracula/vim",
		name = "dracula",
		lazy = true,
	},
}
