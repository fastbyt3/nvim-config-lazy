return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			delay = 400,
			preset = "classic",
			filter = function(mapping)
				return mapping.desc ~= "Disable space (leader) in normal mode"
			end,
		},
	},
}
