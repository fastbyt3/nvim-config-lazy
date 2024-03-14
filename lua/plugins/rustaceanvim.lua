return {
  "mrcjkb/rustaceanvim",
  version = "^3",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "lvimuser/lsp-inlayhints.nvim",
      opts = {}
    },
  },
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      inlay_hints = {
        highlight = "NonText",
      },
      tools = {
				enable_clippy = true,
				reload_workspace_from_cargo_toml = true,
        hover_actions = {
          auto_focus = false,
        },
      },
      server = {
        on_attach = function(client, bufnr)
          require("lsp-inlayhints").on_attach(client, bufnr)
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { silent = true, buffer=bufnr})
        end
      }
    }
		vim.cmd([[ autocmd BufWritePre *.rs lua vim.lsp.buf.format({async = false }) ]])
  end
}
