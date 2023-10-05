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
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
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
		vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true }) -- set up highlight grp for ghost_text

		cmp.setup({
			preselect = 'item',
			completion = {
				completeopt = 'menu,menuone,noinsert'
			},
			mapping = cmp.mapping.preset.insert({
				['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lua' },
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'nvim_lsp_signature_help' },
			}),
			experimental = { ghost_text = { hl_group = 'CmpGhostText' } },
		})

	end
}
