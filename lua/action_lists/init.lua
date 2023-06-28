-- Private

local function get_action_infos(actions)
	local action_infos = {}
	for key, action in pairs(actions) do
		table.insert(action_infos, {
			key = key,
			command = action,
		})
	end
	return action_infos
end

---Insert a table onto another table
---@param table table
---@param other_table table
local function insert_all(table, other_table)
	for key, value in pairs(other_table) do
		table[key] = value
	end
end

local function select_action(actions)
	local action_infos = get_action_infos(actions)

	vim.ui.select(action_infos, {
		prompt = "Run action",
		kind = "actionlist",
		format_item = function(action_info)
			return action_info.key
		end,
	}, function(action_info)
		if action_info == nil then
			return
		end

		vim.cmd(actions[action_info.key])
	end)
end

---From https://github.com/stevearc/dressing.nvim/blob/master/lua/dressing/select/telescope.lua
local function custom_kind(opts, defaults, items)
	local entry_display = require("telescope.pickers.entry_display")
	local finders = require("telescope.finders")
	local displayer

	local function make_display(entry)
		local columns = {
			{ entry.idx .. ":", "TelescopePromptPrefix" },
			entry.text,
			{ entry.command, "Comment" },
		}
		return displayer(columns)
	end

	local entries = {}
	local command_width = 1
	local text_width = 1
	local idx_width = 1
	for idx, item in ipairs(items) do
		local text = opts.format_item(item.key)
		local key = item.key
		local command = key.command

		command_width = math.max(command_width, vim.api.nvim_strwidth(command))
		text_width = math.max(text_width, vim.api.nvim_strwidth(text))
		idx_width = math.max(idx_width, vim.api.nvim_strwidth(tostring(idx)))

		table.insert(entries, {
			idx = idx,
			display = make_display,
			key = key,
			text = text,
			ordinal = idx .. " " .. text .. " " .. command,
			command = command,
			value = item,
		})
	end
	displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = idx_width + 1 },
			{ width = text_width },
			{ width = command_width },
		},
	})

	defaults.finder = finders.new_table({
		results = entries,
		entry_maker = function(item)
			return item
		end,
	})
end

-- Public
local M = {}

local lists = nil

--- @alias action_list { [string]: string }

---Setup action lists
---@param opts { lists: { [string]: { actions: action_list } | { [string]: { actions: action_list, ft: string | nil }}}}
function M.setup(opts)
	lists = opts.lists

	if pcall(require, "dressing") and pcall(require, "telescope") then
		require("dressing.select.telescope").custom_kind.actionlist = custom_kind
	end
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
		vim.notify("No action list with name '" .. list_name .. "' found.", vim.log.levels.ERROR)
		return
	end

	local actions = list.actions

	if actions == nil then
		actions = {}

		local filetype = vim.bo.filetype

		---@diagnostic disable-next-line: unused-local
		for group, opts in pairs(list) do
			local fts = opts.ft
			local group_actions = opts.actions or {}

			if fts == nil then
				insert_all(actions, group_actions)
				goto continue
			end

			---@diagnostic disable-next-line: unused-local
			for index, ft in ipairs(fts) do
				if ft == filetype then
					insert_all(actions, group_actions)
					break
				end
			end
			::continue::
		end
	end

	select_action(actions)
end

return M
