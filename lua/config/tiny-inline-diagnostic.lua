require("tiny-inline-diagnostic").setup({
	preset = "powerline",
	options = {
		add_messages = {
			display_count = true,
			messages = true,
		},
		multilines = {
			always_show = true,
			enabled = true,
		},
	},
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	virtual_lines = false,
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
})
