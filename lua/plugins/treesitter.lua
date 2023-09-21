return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			-- show treesitter nodes
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-textobjects", -- enable more advanced treesitter-aware text objects
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"css",
				"diff",
				"comment",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"javascript",
				"jsdoc",
				"json",
				"json",
				"json5",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"ruby",
				"rust",
				"typescript",
				"vim",
				"yaml",
				"tsx",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			highlight = { enable = true, use_languagetree = true },
			context_commentstring = { enable = true },
			indent = { enable = true },
			rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
		},
	}
}
