return {
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod", "gosum", "gowork" },
		build = ':lua require("go.install").update_all_sync()',
		dependencies = {
			"ray-x/guihua.lua",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup({
				-- LSP handled by nvim-lspconfig in lsp.lua
				lsp_cfg = false,
				lsp_keymaps = false,
				lsp_codelens = false,

				-- Formatting handled by conform.nvim
				gofmt = nil,
				fillstruct = nil,

				-- Testing
				test_runner = "go",
				run_in_floaterm = true,
				floaterm = {
					posititon = "bot",
					width = 0.8,
					height = 0.8,
				},

				-- Tools
				trouble = false,
				luasnip = true,
				dap_debug = false,
				tag_transfer = true,

				-- UI
				icons = { breakpoint = "", currentpos = "" },
			})

			-- Keybindings
			local map = vim.keymap.set

			-- Test commands
			-- map("n", "<leader>gt", function()
			-- 	require("go").test_func()
			-- end, { desc = "Go: Test function", buffer = true })
			--
			-- map("n", "<leader>gT", function()
			-- 	require("go").test_package()
			-- end, { desc = "Go: Test package", buffer = true })
			--
			-- map("n", "<leader>gf", function()
			-- 	require("go").test_file()
			-- end, { desc = "Go: Test file", buffer = true })
			--
			-- map("n", "<leader>gr", function()
			-- 	require("go").run({ floaterm = true })
			-- end, { desc = "Go: Run current file", buffer = true })
			--
			-- Code actions
			-- map("n", "<leader>gia", function()
			-- 	require("go").alternate()
			-- end, { desc = "Go: Alternate file (switch test/impl)", buffer = true })

			map("n", "<leader>gim", function()
				require("go").implement()
			end, { desc = "Go: Generate interface implementation", buffer = true })

			map("n", "<leader>gie", function()
				require("go").iferr()
			end, { desc = "Go: Add iferr", buffer = true })

			map("n", "<leader>giI", function()
				require("go").import()
			end, { desc = "Go: Add import", buffer = true })

			map("n", "<leader>gic", function()
				require("go").fillstruct()
			end, { desc = "Go: Fill struct", buffer = true })

			map("n", "<leader>gis", function()
				require("go").fillswitch()
			end, { desc = "Go: Fill switch", buffer = true })

			-- map("n", "<leader>giw", function()
			-- 	require("go").fillswag()
			-- end, { desc = "Go: Fill swagger comments", buffer = true })

			-- Coverage
			-- map("n", "<leader>gc", function()
			-- 	require("go").coverage()
			-- end, { desc = "Go: Show test coverage", buffer = true })
			--
			-- map("n", "<leader>gC", function()
			-- 	require("go").cleancoverage()
			-- end, { desc = "Go: Clear test coverage", buffer = true })

			-- Mod tidy/vendor
			map("n", "<leader>gmt", function()
				vim.cmd("GoModTidy")
			end, { desc = "Go: Mod tidy", buffer = true })

			map("n", "<leader>gmv", function()
				vim.cmd("GoModVendor")
			end, { desc = "Go: Mod vendor", buffer = true })

			-- Auto commands for Go files
			vim.api.nvim_create_augroup("go-keymaps", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = "go-keymaps",
				pattern = { "go", "gomod", "gosum", "gowork" },
				callback = function(args)
					-- Organize imports on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function()
							local params = vim.lsp.util.make_range_params()
							params.context = { only = { "source.organizeImports" } }
							local result = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 1000)
							for _, res in pairs(result or {}) do
								for _, action in pairs(res.result or {}) do
									if action.edit then
										vim.lsp.util.apply_workspace_edit(action.edit, "UTF-8")
									elseif action.command then
										vim.lsp.buf.execute_command(action.command)
									end
								end
							end
						end,
					})
				end,
			})
		end,
	},
}
