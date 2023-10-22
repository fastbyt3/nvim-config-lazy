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
				"hrsh7th/cmp-vsnip",
				"hrsh7th/cmp-path",
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
			vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, {buffer = bufnr, remap = false})
			vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, {buffer = bufnr, remap = false})
		end)

		lsp.configure('lua_ls', {
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' }
					}
				}
			}
		})

		lsp.skip_server_setup({'rust_analyzer'})

		lsp.setup()

		-- rust
		local rust_tools = require('rust-tools')

		rust_tools.setup({
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
				end
			},
			-- options same as lsp hover / vim.lsp.util.open_floating_preview()
			hover_actions = {

				-- the border that is used for the hover window
				-- see vim.api.nvim_open_win()
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},

				-- Maximal width of the hover window. Nil means no max.
				max_width = nil,

				-- Maximal height of the hover window. Nil means no max.
				max_height = nil,

				-- whether the hover action window gets automatically focused
				-- default: false
				auto_focus = false,
			},
		})

		-- setup cmp
		local cmp = require('cmp')
		-- vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true }) -- set up highlight grp for ghost_text

		cmp.setup({
			preselect = 'item',
			completion = {
				completeopt = 'menu,menuone,noinsert'
			},
			experimental = { ghost_text = true },
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
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered()
			},
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'luasnip' },
				{ name = 'path' },
				{ name = 'buffer' },
				{ name = 'nvim_lua' },
				{ name = 'vsnip' },
			}),
		})
	end
}
