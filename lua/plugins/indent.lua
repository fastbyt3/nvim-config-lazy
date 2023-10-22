return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	lazy = true,
	event = "BufReadPre",
	opts = {},
	config = function ()
		require("ibl").setup {
			enabled = true,
			debounce = 200,
			indent = {
				char = ".",
				tab_char = "=",
				smart_indent_cap = true,
				priority = 2,
			},
			whitespace = { remove_blankline_trail = true },
			scope = {
				enabled = true,
				char = "┆",
				show_start = false,
				show_end = false,
				injected_languages = true,
				priority = 1000,
			},
			exclude = {
				filetypes = {
					"dashboard",
				},
			},
		}
	end
}
