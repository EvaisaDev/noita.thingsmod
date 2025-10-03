dofile_once("mods/noita.thingsmod/require.lua")
local module_utils = require("lib.module_utils.module_utils")

local modules = require "content"

local extra_translations = ""

for _, module in ipairs(modules) do
	local translations_path = ("mods/noita.thingsmod/content/%s/translations.csv"):format(module)
	if not ModDoesFileExist(translations_path) then goto continue end
	local new_translations = ModTextFileGetContent(translations_path)
	local prefix = ("noita_thingsmod_%s_"):format(module)
	extra_translations = extra_translations
		.. "\n"
		.. new_translations
			:gsub("^,en[^\n]*", "")
			:gsub("^\n*", "\n")
			:gsub("\n", "\n" .. prefix)
			:gsub(prefix .. "$", "\n")
		.. "\n"
	::continue::
end

local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. extra_translations
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)

local errored = false
local disabled_modules = {}
local function do_callback(callback_name, ...)
	for _, module in ipairs(modules) do
		module_utils.current_module = module
		local mod = dofile_once("mods/noita.thingsmod/content/" .. module .. "/module.lua")
		if mod and mod[callback_name] and not disabled_modules[module] then
			local success, error_msg = pcall(mod[callback_name], ...) --if runs normally and returns true, all the future module callbacks will be skipped
			if not success then
				print(mod.name .. " Error: " .. error_msg)
				errored = true
			elseif error_msg then
				disabled_modules[module] = true
			end
		end
	end
end

local callback_names = {
	"OnThingsCalled",
	"OnBiomeConfigLoaded",
	"OnCountSecrets",
	"OnMagicNumbersAndWorldSeedInitialized",
	"OnModInit",
	"OnModPostInit",
	"OnModPreInit",
	"OnModSettingsChanged",
	"OnPausePreUpdate",
	"OnPausedChanged",
	"OnPlayerDied",
	"OnPlayerSpawned",
	"OnWorldInitialized",
	"OnWorldPostUpdate",
	"OnWorldPreUpdate",
}

for _, callback_name in ipairs(callback_names) do
	_G[callback_name] = function(...)
		do_callback(callback_name, ...)
	end
end

---@diagnostic disable-next-line: undefined-global
OnThingsCalled(modules)

function OnPlayerSpawned(...)
	do_callback("OnPlayerSpawned", ...)
	local flag = "NOITA_THINGSMOD_PLAYER_SPAWN_DONE"
	if GameHasFlagRun(flag) then return end
	GameAddFlagRun(flag)
	do_callback("OnPlayerFirstSpawned", ...)


end

if errored then error("Some modules failed to load, see log") end
