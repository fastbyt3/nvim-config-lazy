local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	---@diagnostic disable-next-line: missing-fields
	formatting = {
		fields = { "abbr", "menu", "kind" },
		format = function(entry, item)
			-- Define menu shorthand for different completion sources.
			local menu_icon = {
				nvim_lsp = "NLSP",
				nvim_lua = "NLUA",
				luasnip  = "LSNP",
				buffer   = "BUFF",
				path     = "PATH",
			}
			-- Set the menu "icon" to the shorthand for each completion source.
			item.menu = menu_icon[entry.source.name]

			-- Set the fixed width of the completion menu to 60 characters.
			-- fixed_width = 20

			-- Set 'fixed_width' to false if not provided.
			local fixed_width = fixed_width or false

			-- Get the completion entry text shown in the completion window.
			local content = item.abbr

			-- Set the fixed completion window width.
			if fixed_width then
				vim.o.pumwidth = fixed_width
			end

			-- Get the width of the current window.
			local win_width = vim.api.nvim_win_get_width(0)

			-- Set the max content width based on either: 'fixed_width'
			-- or a percentage of the window width, in this case 20%.
			-- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
			local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

			-- Truncate the completion entry text if it's longer than the
			-- max content width. We subtract 3 from the max content width
			-- to account for the "..." that will be appended to it.
			if #content > max_content_width then
				item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
			else
				item.abbr = content .. (" "):rep(max_content_width - #content)
			end
			return item
		end,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		['<C-e>'] = cmp.mapping.abort(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete {},
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
	},
}
