-- Private
local function get_input_options(actions)
	local options = {}
	for actionname, action in pairs(actions) do
		table.insert(options, actionname .. " -> '" .. action .. "'")
	end

	return options
end

---Insert a table onto another table
---@param table table
---@param other_table table
local function insert_all(table, other_table)
	for key, value in pairs(other_table) do
		table.insert(table, key, value)
	end
end

-- Public
local M = {}

local lists = nil

--- @alias action_list { [string]: string }

---Setup action lists
---@param opts { lists: { [string]: { actions: action_list } | { [string]: { actions: action_list, ft: string | nil }}}}
function M.setup(opts)
	lists = opts.lists
end

---Open action selector
---@param list_name string
function M.open(list_name)
	if lists == nil then
		vim.notify("No lists found! Did you forget to run setup(opts)?", vim.log.levels.ERROR)
		return
	end

	local list = lists[list_name]

	if list == nil then
		vim.notify("No action list with name: " .. list_name .. " found.", vim.log.levels.ERROR)
		return
	end

	local actions = list.actions

	if actions == nil then
		actions = {}

		local filetype = vim.bo.filetype

		---@diagnostic disable-next-line: unused-local
		for group, opts in pairs(actions) do
			local fts = opts.ft
			local group_actions = opts.actions or {}

			if fts == nil then
				for action, value in pairs(group_actions) do
					table.insert(actions, action, value)
				end
				goto continue
			end

			---@diagnostic disable-next-line: unused-local
			for index, ft in ipairs(fts) do
				if ft == filetype then
					insert_all(actions, group_actions)
				end
			end
			::continue::
		end
	end

	local options = get_input_options(actions)
	vim.ui.select(options, { prompt = "Run action... " }, function(item, id)
		if item == nil or id == nil then
			return
		end

		vim.cmd(actions[id])
	end)
end

return M
