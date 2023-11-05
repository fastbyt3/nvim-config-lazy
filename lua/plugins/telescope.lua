return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make'
		}
	},
	config = function ()
		local telescope = require('telescope')
		telescope.setup({
			extensions = {
				fzf = {
					fuzzy = true,                    -- false will only do exact matching
					override_generic_sorter = true,  -- override the generic sorter
					override_file_sorter = true,     -- override the file sorter
					case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			},
			winblend = 0,
			border = {},
			borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
			color_devicons = true,
			set_env = {["COLORTERM"] = "truecolor"},
		})


		-- setup keybindings
		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>")
		keymap.set("n", "<C-p>", "<cmd>Telescope buffers<cr>")
	end
}
