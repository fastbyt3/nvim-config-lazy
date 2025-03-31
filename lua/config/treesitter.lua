require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"go",
		"lua",
		"python",
		"rust",
		"javascript",
		"json",
		"jsdoc",
		"tsx",
		"typescript",
		"vimdoc",
		"vim",
		"markdown",
	},
	ignore_install = {}, -- List of parsers to ignore installing
	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = true,
	sync_install = true,
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "help" }, -- list of language that will be disabled
	},
})
