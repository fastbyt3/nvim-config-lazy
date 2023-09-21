return {
	'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {
		  'hrsh7th/nvim-cmp', -- required
		  event = "InsertEnter",
		  dependencies = {
			  "hrsh7th/cmp-nvim-lsp",
			  "hrsh7th/cmp-buffer",
		  },
	  },
      {'L3MON4D3/LuaSnip'},     -- Required
      {'simrat39/rust-tools.nvim'},          -- Required for rust
    },
	config = function()
		local lsp = require('lsp-zero').preset({})

		lsp.on_attach(function(client, bufnr)
			-- see :help lsp-zero-keybindings
			-- to learn the available actions
			lsp.default_keymaps({buffer = bufnr})
		end)

		lsp.skip_server_setup({'rust_analyzer'})

		lsp.setup()

		-- rust
		local rust_tools = require('rust-tools')

		rust_tools.setup({
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
				end
			}
		})

		-- setup cmp
		local cmp = require('cmp')

		cmp.setup({
			preselect = 'item',
			completion = {
				completeopt = 'menu,menuone,noinsert'
			},
			mapping = {
				['<CR>'] = cmp.mapping.confirm({select = false}),
			}
		})

	end
}
