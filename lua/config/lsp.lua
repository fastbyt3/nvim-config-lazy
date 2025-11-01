local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local lspconfig = require("lspconfig")

local utils = require("utils")

-- set quickfix list from diagnostics in a certain buffer, not the whole workspace
-- local set_qflist = function(buf_num, severity)
-- 	local diagnostics = nil
-- 	diagnostics = diagnostic.get(buf_num, { severity = severity })
--
-- 	local qf_items = diagnostic.toqflist(diagnostics)
-- 	vim.fn.setqflist({}, " ", { title = "Diagnostics", items = qf_items })
--
-- 	-- open quickfix by default
-- 	vim.cmd([[copen]])
-- end

local custom_attach = function(client, bufnr)
	-- Mappings.
	local map = function(mode, l, r, opts)
		opts = opts or {}
		opts.silent = true
		opts.buffer = bufnr
		keymap.set(mode, l, r, opts)
	end

	map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
	map("n", "<leader>gdv", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition({
			on_list = function(options)
				-- This callback runs after the definition is found
				vim.schedule(function()
					vim.cmd("cclose")
				end)
			end,
		})
	end, { desc = "open definition in vertical split" })
	map("n", "K", function()
		vim.lsp.buf.hover({ border = "single", max_height = 40 })
	end)
	map("n", "gI", vim.lsp.buf.implementation, { desc = "go to implementation" })
	map({ "n", "i" }, "<C-h>", function()
		vim.lsp.buf.signature_help({ border = "rounded", title_pos = "right" })
	end)
	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
	map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
	map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
	map("n", "<leader>lti", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, { desc = "LSP toggle inlay_hint" })

	-- Set some key bindings conditional on server capabilities
	-- Commenting it out since using conform with lsp as fallback
	-- if client.server_capabilities.documentFormattingProvider then
	-- 	map({ "n", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "format code with lsp" })
	-- end

	-- Uncomment code below to enable inlay hint from language server, some LSP server supports inlay hint,
	-- but disable this feature by default, so you may need to enable inlay hint in the LSP server config.
	-- vim.lsp.inlay_hint.enable(true, {buffer=bufnr})

	-- The blow command will highlight the current variable and its usages in the buffer.
	if client.server_capabilities.documentHighlightProvider then
		vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

		local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		api.nvim_create_autocmd("CursorHold", {
			group = gid,
			buffer = bufnr,
			callback = function()
				lsp.buf.document_highlight()
			end,
		})

		api.nvim_create_autocmd("CursorMoved", {
			group = gid,
			buffer = bufnr,
			callback = function()
				lsp.buf.clear_references()
			end,
		})
	end

	if vim.g.logging_level == "debug" then
		local msg = string.format("Language server %s started!", client.name)
		vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- required by nvim-ufo
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- For what diagnostic is enabled in which type checking mode, check doc:
-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#diagnostic-settings-defaults
-- Currently, the pyright also has some issues displaying hover documentation:
-- https://www.reddit.com/r/neovim/comments/1gdv1rc/what_is_causeing_the_lsp_hover_docs_to_looks_like/

if utils.executable("pyright") then
	local new_capability = {
		-- this will remove some of the diagnostics that duplicates those from ruff, idea taken and adapted from
		-- here: https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1989619482
		textDocument = {
			publishDiagnostics = {
				tagSupport = {
					valueSet = { 2 },
				},
			},
			hover = {
				contentFormat = { "plaintext" },
				dynamicRegistration = true,
			},
		},
	}
	local merged_capability = vim.tbl_deep_extend("force", capabilities, new_capability)

	vim.lsp.config("pyright", {
		-- cmd = { "delance-langserver", "--stdio" },
		on_attach = custom_attach,
		capabilities = merged_capability,
		settings = {
			pyright = {
				-- disable import sorting and use Ruff for this
				disableOrganizeImports = true,
				disableTaggedHints = false,
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					typeCheckingMode = "standard",
					useLibraryCodeForTypes = true,
					-- we can this setting below to redefine some diagnostics
					diagnosticSeverityOverrides = {
						deprecateTypingAliases = false,
					},
					-- inlay hint settings are provided by pylance?
					inlayHints = {
						callArgumentNames = "partial",
						functionReturnTypes = true,
						pytestParameters = true,
						variableTypes = true,
					},
				},
			},
		},
	})

	vim.lsp.enable("pyright")
else
	vim.notify("pyright not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("ruff") then
	vim.lsp.config("ruff", {
		on_attach = custom_attach,
		capabilities = capabilities,
		init_options = {
			-- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
			settings = {
				organizeImports = true,
			},
		},
	})
	vim.lsp.enable("ruff")
end

-- Disable ruff hover feature in favor of Pyright
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- vim.print(client.name, client.server_capabilities)

		if client == nil then
			return
		end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

if utils.executable("ltex-ls") then
	vim.lsp.config("ltex", {
		on_attach = custom_attach,
		cmd = { "ltex-ls" },
		filetypes = { "text", "plaintex", "tex", "markdown" },
		settings = {
			ltex = {
				language = "en",
			},
		},
		flags = { debounce_text_changes = 300 },
	})
	vim.lsp.enable("ltex")
end

if utils.executable("clangd") then
	vim.lsp.config("clangd", {
		on_attach = custom_attach,
		capabilities = capabilities,
		filetypes = { "c", "cpp", "cc" },
		flags = {
			debounce_text_changes = 500,
		},
	})
	vim.lsp.enable("clangd")
end

-- set up vim-language-server
if utils.executable("vim-language-server") then
	vim.lsp.config("vimls", {
		on_attach = custom_attach,
		flags = {
			debounce_text_changes = 500,
		},
		capabilities = capabilities,
	})
	vim.lsp.enable("vimls")
else
	vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up bash-language-server
if utils.executable("bash-language-server") then
	vim.lsp.config("bashls", {
		on_attach = custom_attach,
		capabilities = capabilities,
	})
	vim.lsp.enable("bashls")
end

-- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
if utils.executable("lua-language-server") then
	vim.lsp.config("lua_ls", {
		on_attach = custom_attach,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				hint = {
					enable = true,
				},
			},
		},
		capabilities = capabilities,
	})
	vim.lsp.enable("lua_ls")
end

if utils.executable("gopls") then
	vim.lsp.config("gopls", {
		on_attach = custom_attach,
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = false,
					parameterNames = false,
					rangeVariableTypes = true,
				},
			},
		},
	})
	vim.lsp.enable("gopls")
end

if utils.executable("csharp-ls") then
	vim.lsp.config("csharp_ls", {
		on_attach = custom_attach,
		settings = {},
	})
	vim.lsp.enable("csharp_ls")
end

if utils.executable("ruby-lsp") then
	vim.lsp.config("ruby_lsp", {})
end

if utils.executable("solargraph") then
	vim.lsp.config("solargraph", {})
end

lspconfig.ts_ls.setup({
	capabilities = capabilities,
	on_attach = custom_attach,
	single_file_support = true,
	init_options = {
		preferences = {
			includeCompletionsWithSnippetText = true,
			includeCompletionsWithInsertText = true,
		},
	},
	settings = {
		completions = {
			completeFunctionCalls = true,
		},
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})

local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup({
	nextls = { enable = true },
	elixirls = {
		enable = true,
		settings = elixirls.settings({
			dialyzerEnabled = false,
			enableTestLenses = false,
		}),
		on_attach = function(client, bufnr)
			custom_attach(client, bufnr)
			vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
			vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
			vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
		end,
	},
	projectionist = {
		enable = true,
	},
})

-- global config for diagnostic
diagnostic.config({
	underline = false,
	virtual_text = false,
	virtual_lines = false,
	-- signs = {
	-- 	text = {
	-- 		[vim.diagnostic.severity.ERROR] = "",
	-- 		[vim.diagnostic.severity.WARN] = "",
	-- 		[vim.diagnostic.severity.INFO] = "",
	-- 		[vim.diagnostic.severity.HINT] = "󰌵",
	-- 	},
	-- },
	severity_sort = true,
	float = {
		source = true,
		header = "Diagnostics:",
		prefix = " ",
		border = "single",
	},
})

api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		if #vim.diagnostic.get(0) == 0 then
			return
		end

		if not vim.b.diagnostics_pos then
			vim.b.diagnostics_pos = { nil, nil }
		end

		local cursor_pos = api.nvim_win_get_cursor(0)
		if cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2] then
			diagnostic.open_float()
		end

		vim.b.diagnostics_pos = cursor_pos
	end,
})
