local snacks = require("snacks")
local M = {}

M.opts = {
	bigfile = { enabled = true },
	-- dashboard = { enabled = true },
	-- explorer = { enabled = true },
	-- indent = { enabled = true },
	notifier = {
		enabled = true,
		timeout = 3000,
	},
	-- picker = { enabled = true },
	quickfile = { enabled = true },
	-- scope = { enabled = true },
	-- scroll = { enabled = true },
	-- statuscolumn = { enabled = true },
	-- words = { enabled = true },
	styles = {
		notification = {
			wo = { wrap = true }, -- Wrap notifications
		},
	},
	input = {
		enabled = true,
		win = {
			relative = "cursor",
			backdrop = true,
		},
	},
	-- picker = { enabled = true },
}

M.keys = {
	{
		"<leader>bd",
		function()
			snacks.bufdelete()
		end,
		desc = "[B]uffer [D]elete",
	},
	{
		"<leader>nh",
		function()
			snacks.notifier.show_history()
		end,
		desc = "Notification History",
	},
}

return M
