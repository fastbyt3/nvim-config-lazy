-- Setup nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			-- For `ultisnips` user.
			-- vim.fn["UltiSnips#Anon"](args.body)

			-- For luasnip
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-e>"] = cmp.mapping.abort(),
		["<Esc>"] = function()
			cmp.mapping.close()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
		end,
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
	}),
	sources = {
		{ name = "nvim_lsp", priority = 100, group_index = 1 },
		{ name = "buffer", max_item_count = 5, group_index = 2 },
		{ name = "path", max_item_count = 3, group_index = 3 },
		{ name = "luasnip", max_item_count = 3, group_index = 5 },
		{ name = "nvim-lsp-signature-help" },
	},
	completion = {
		keyword_length = 1,
		completeopt = "menu,noselect",
	},
	view = {
		entries = "custom",
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			menu = {
				nvim_lsp = "[LSP]",
				-- ultisnips = "[US]",
				luasnip = "[LS]",
				path = "[Path]",
				buffer = "[Buffer]",
				emoji = "[Emoji]",
				omni = "[Omni]",
			},
			show_labelDetails = true,
			maxwidth = 40,
			ellipsis_char = "...",
		}),
	},
})

--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])
