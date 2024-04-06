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
			auto_install = true,
			ensure_installed = {
				"tsx",
				"javascript",
				"html",
				"css",
				"vue",
				"json",
				"json5",
				"lua",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<M-space>",
				},
			},
			highlight = { enable = true, use_languagetree = true },
			context_commentstring = { enable = true },
			indent = { enable = true },
			rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
			sync_install = true,
		},
	}
}
