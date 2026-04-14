local treesitter_group = vim.api.nvim_create_augroup("fastbyte-treesitter-main", { clear = true })

-- Main autocmd for starting Treesitter
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = treesitter_group,
    callback = function(args)
        local buf = args.buf

        -- Skip special buffers
        if vim.bo[buf].buftype ~= "" then
            return
        end

        local filetype = vim.bo[buf].filetype
        if filetype == "" then
            return
        end

        -- Start highlighting (safest timing)
        pcall(vim.treesitter.start, buf)

        -- Handle indentation only if the language has indent queries
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang then
            return
        end

        local has_indents = pcall(function()
            return vim.treesitter.query.get(lang, "indents")
        end)

        if has_indents then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- Optional: Extra safety net on FileType (helps with some edge cases)
vim.api.nvim_create_autocmd("FileType", {
    group = treesitter_group,
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "Highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})
