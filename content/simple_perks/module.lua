local nxml = dofile_once("mods/Apotheosis/lib/nxml.lua")
local module_filepath = "mods/noita.thingsmod/content/simple_perks/"

return {
	name = "Perks",
	description = "Adds perks.",
	authors = {"Conga Lyne", "Copi"},
	OnModPreInit = function ()
		for k=1,30 do
			print("aaaaaaaaaaaaaaaaaaaaaaa")
		end
	end,
	OnModInit = function () 
		-- Custom Perk support injection
		ModLuaFileAppend("data/scripts/perks/perk_list.lua", module_filepath .. "scripts/perks/custom_perks.lua")

		--Appending extra modifiers
		ModLuaFileAppend("data/scripts/gun/gun_extra_modifiers.lua", module_filepath .. "scripts/gun/gun_extra_populator.lua")

		local translations = ModTextFileGetContent("data/translations/common.csv")
		local new_translations = ModTextFileGetContent(module_filepath .. "translations.csv")
		translations = translations .. "\n" .. new_translations .. "\n"
		translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
		ModTextFileSetContent("data/translations/common.csv", translations)

		--Player Editor
		do
			local path = "data/entities/player_base.xml"
			local xml = nxml.parse(ModTextFileGetContent(path))
			xml:add_child(nxml.parse([[
			<LuaComponent
			script_damage_about_to_be_received="mods/noita.thingsmod/content/simple_perks/scripts/perks/take_damage.lua"
			execute_every_n_frame="-1"
			execute_times="-1"
			remove_after_executed="0"
			>
			</LuaComponent>
			]]))
			ModTextFileSetContent(path, tostring(xml))
		end

		-- Inject bountiful hunter power-ups
		print'[THINGSMOD/PERKS] Injecting bountiful hunter content!'
		local base_path = "data/entities/base_humanoid.xml"
		ModLuaFileAppend("data/scripts/items/drop_money.lua", "mods/noita.thingsmod/content/simple_perks/scripts/drop_booster.lua")
		ModTextFileSetContent(base_path, ModTextFileGetContent(base_path):gsub("</Entity>$", [[<LuaComponent execute_every_n_frame="-1" execute_on_added="1" script_source_file="mods/noita.thingsmod/content/simple_perks/scripts/hp_gutter.lua" /></Entity>]]))
	end,
}
