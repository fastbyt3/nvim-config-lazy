return {
	'glepnir/dashboard-nvim',
	event = 'VimEnter',
	config = function()
		require('dashboard').setup {
			theme = 'hyper',
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
					icon = ' ',
					icon_hl = '@variable',
					desc = 'Files',
					group = 'Label',
					action = 'Telescope find_files',
					key = 'f',
					},
				},
			},
		}
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
