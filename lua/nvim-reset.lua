--- @class NvimResetIgnoreMap
--- @field mode string | string[]
--- @field lhs string

--- @alias NvimResetIgnoreOptions NvimResetIgnoreMap[ ]

--- @class NvimResetOptions
--- @field ignore_maps? NvimResetIgnoreOptions
--- @field create_plugin_keymap? boolean

local M = {}

local modes = {
	"n",
	"no",
	"nov",
	"noV",
	"noCTRL-V",
	"CTRL-V",
	"niI",
	"niR",
	"niV",
	"v",
	"V",
	"s",
	"S",
	"i",
	"ic",
	"ix",
	"R",
	"Rc",
	"Rv",
	"Rx",
	"c",
	"cv",
	"ce",
	"r",
	"rm",
	"r?",
	"!",
	"t",
}

--- flatten ignroe list
--- @param ignore_map NvimResetIgnoreOptions
local function flattenIgnoreList(ignore_map)
	return vim.iter(ignore_map)
		:map(function(ignore_keymap)
			if type(ignore_keymap.mode) == "table" then
				return vim.iter(ignore_keymap.mode)
					:map(function(mode)
						return { mode = mode, lhs = ignore_keymap.lhs }
					end)
					:totable()
			end
			return { ignore_keymap }
		end)
		:flatten()
		:totable()
end

---@param ignore_map NvimResetIgnoreOptions
---@param create_plugin_keymap boolean
local function reset(ignore_map, create_plugin_keymap)
	vim.iter(modes):each(function(mode)
		local keymaps = vim.api.nvim_get_keymap(mode)
		vim.iter(keymaps)
			:filter(function(keymap)
				return not vim.iter(ignore_map):any(function(ignore_keymap)
					return ignore_keymap.mode == keymap.mode and ignore_keymap.lhs == keymap.lhs
				end)
			end)
			:each(function(keymap)
				pcall(vim.keymap.del, keymap.mode, keymap.lhs)
				if create_plugin_keymap then
					vim.keymap.set("n", ("<Plug>-NvimReset-%s-%s"):format(keymap.mode, keymap.lhs), keymap.rhs)
				end
			end)
	end)
end

--- @param opts NvimResetOptions
function M.setup(opts)
	local ignore_maps = opts.ignore_maps or {}
	local create_plugin_keymap = opts.create_plugin_keymap or false
	local flatten_ignore_list = flattenIgnoreList(ignore_maps)
	reset(flatten_ignore_list, create_plugin_keymap)
end

return M
