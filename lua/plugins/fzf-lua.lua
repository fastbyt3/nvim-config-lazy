local symbol_icons = {
	File = "",
	Module = "",
	Namespace = "󰅩",
	Package = "",
	Class = "󰌗",
	Method = "󰊕",
	Property = "",
	Field = "",
	Constructor = "",
	Enum = "",
	Interface = "󰠱",
	Function = "󰊕",
	Variable = "󰀫",
	Constant = "󰏿",
	String = "󰊄",
	Number = "󰎠",
	Boolean = "󰝖",
	Array = "",
	Object = "󰜫",
	Key = "󰌆",
	Null = "Ø",
	EnumMember = "",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {
		fzf_colors = true,
		previewers = {
			bat = { theme = "Catppuccin Mocha", args = "--color=always --style=default" },
		},
		winopts = {
			-- height = 0.85,
			-- width = 0.85,
			-- row = 0.2,
			-- col = 0.5,
			border = "rounded", -- matches most Catppuccin float borders
			preview = {
				border = "rounded",
				scrollbar = "border", -- or "float"
			},
		},
		lsp = {
			symbols = {
				path_shorten = 1,
				symbol_icons = symbol_icons,
			},
		},
	},
	---@diagnostic enable: missing-fields
	config = function()
		local fzflua = require("fzf-lua")
		fzflua.register_ui_select()

		require("fastbyte.keymaps").map_fzflua_keybinds()
	end,
}
