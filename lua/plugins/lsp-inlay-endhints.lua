vim.api.nvim_create_user_command("ToggleEndHints", function(_)
	require("lsp-endhints").toggle()
end, {
	desc = "Toggle LSP Inlay Endhints",
})

return {
	"chrisgrieser/nvim-lsp-endhints",
	event = "LspAttach",
	opts = {
		icons = {
			type = "󰠱 ",
			parameter = "󰜢  ",
			offspec = " ",
			unknown = " ",
		},
		label = {
			truncateAtChars = 200,
			-- padding = 1,
			-- marginLeft = 0,
			-- sameKindSeparator = ", ",
		},
	}, -- required, even if empty
}
