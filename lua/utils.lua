local fn = vim.fn
-- local version = vim.version

local M = {}

local fast_event_aware_notify = function(msg, level, opts)
	if vim.in_fast_event() then
		vim.schedule(function()
			vim.notify(msg, level, opts)
		end)
	else
		vim.notify(msg, level, opts)
	end
end

function M.info(msg)
	fast_event_aware_notify(msg, vim.log.levels.INFO, {})
end

function M.warn(msg)
	fast_event_aware_notify(msg, vim.log.levels.WARN, {})
end

function M.err(msg)
	fast_event_aware_notify(msg, vim.log.levels.ERROR, {})
end

function M.executable(name)
	if fn.executable(name) > 0 then
		return true
	end

	return false
end

--- check if we are inside a git repo
--- @return boolean
function M.inside_git_repo()
	local result = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
	if result.code ~= 0 then
		return false
	end

	-- Manually trigger a special user autocmd InGitRepo (used lazyloading.
	vim.cmd([[doautocmd User InGitRepo]])

	return true
end

return M
