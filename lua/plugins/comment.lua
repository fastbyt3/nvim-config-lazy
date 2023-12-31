return {
	{
		'numToStr/Comment.nvim',
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function ()
			require("Comment").setup({
				padding = true,
				sticky = true,
				ignore = "^$",
				toggler = {
					line = "gcc",
					block = "gbc",
				},
				mappings = {
					basic = true,
				},
			})
		end
	}
}
