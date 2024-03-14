return {
    'saecki/crates.nvim',
    tag = 'stable',
		event = { "BufRead Cargo.toml" },
    config = function()
        local crates = require('crates')
				local opts = { silent = true }

				vim.keymap.set("n", "<leader>ct", crates.toggle, opts)

				vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
				vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
				vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)

				crates.setup()
    end,
}
