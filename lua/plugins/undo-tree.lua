return {
	"mbbill/undotree",
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = function ()
		vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
	end
}
