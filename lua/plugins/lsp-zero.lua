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
				-- "hrsh7th/cmp-vsnip",
				-- "hrsh7th/vim-vsnip",
				"hrsh7th/cmp-path",
				-- "rafamadriz/friendly-snippets",
			},
		},
		-- {'L3MON4D3/LuaSnip'},     -- Required
		{'simrat39/rust-tools.nvim'},          -- Required for rust
	},
	config = function()
		local lsp = require('lsp-zero')
		lsp.preset("recommended")

		lsp.on_attach(function(client, bufnr)
			-- see :help lsp-zero-keybindings
			-- to learn the available actions
			lsp.default_keymaps({buffer = bufnr})
			local opts = {buffer = bufnr, remap = false}
			vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
			vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
			vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		end)

		lsp.skip_server_setup({'rust_analyzer'})

		lsp.setup()

		-- Fix Undefined global 'vim'
		require('lspconfig').lua_ls.setup({
			workspace = {
				preloadFileSize = 1000
			}
		})
		-- require'lspconfig'.lua_ls.setup{
		-- 	settings = {
		-- 		Lua = {
		-- 			runtime = {
		-- 				version = "LuaJIT"
		-- 			},
		-- 			workspace = {
		-- 				preloadFileSize = 1000
		-- 			},
		-- 			diagnostics = {
		-- 				globals = { 'vim' }
		-- 			}
		-- 		}
		-- 	}
		-- }

		-- Go
		require'lspconfig'.gopls.setup{
			on_attach = function(_, bufnr)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=bufnr})
			end
		}

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
		-- rust_tools.inlay_hints.enable() // enable inline hints
		vim.cmd([[ autocmd BufWritePre *.rs lua vim.lsp.buf.format({async = false }) ]])

		-- setup cmp
		local cmp = require('cmp')

		-- local has_words_before = function()
		-- 	unpack = unpack or table.unpack
		-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		-- 	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		-- end

		-- local feedkey = function(key, mode)
		-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
		-- end

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				-- expand = function(args)
				-- 	vim.fn["vsnip#anonymous"](args.body)
				-- end,
			},
			preselect = 'item',
			completion = {
				completeopt = 'menu,menuone,noinsert'
			},
			mapping = cmp.mapping.preset.insert({
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				-- ['<Down>'] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_next_item()
				-- 	elseif vim.fn["vsnip#available"](1) == 1 then
				-- 		feedkey("<Plug>(vsnip-expand-or-jump)", "")
				-- 	elseif has_words_before() then
				-- 		cmp.complete()
				-- 	else
				-- 		fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
				-- 	end
				-- end, { "i", "s" }),
				-- ['<Up>'] = cmp.mapping(function()
				-- 	if cmp.visible() then
				-- 		cmp.select_prev_item()
				-- 	elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				-- 		feedkey("<Plug>(vsnip-jump-prev)", "")
				-- 	end
				-- end, { "i", "s" }),
				-- ["<Tab>"] = cmp.mapping(function(fallback)
				-- 	if cmp.visible() then
				-- 		cmp.select_next_item()
				-- 	elseif vim.fn["vsnip#available"](1) == 1 then
				-- 		feedkey("<Plug>(vsnip-expand-or-jump)", "")
				-- 	elseif has_words_before() then
				-- 		cmp.complete()
				-- 	else
				-- 		fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
				-- 	end
				-- end, { "i", "s" }),
				-- ["<S-Tab>"] = cmp.mapping(function()
				-- 	if cmp.visible() then
				-- 		cmp.select_prev_item()
				-- 	elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				-- 		feedkey("<Plug>(vsnip-jump-prev)", "")
				-- 	end
				-- end, { "i", "s" }),
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered()
			},
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'buffer' },
				-- { name = 'vsnip' },
				-- { name = 'luasnip' },
				{ name = 'path' },
				{ name = 'nvim_lua' },
			}),
			experimental = {
				ghost_text = true
			}
		})
	end
}
