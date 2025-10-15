local _require = require
dofile("mods/noita.thingsmod/require.lua")
local table_utils = require "lib.table_utils.table_utils"

local custom_perks = {
	{
		id = "WET_ARMOR",
		id_append = "STAINLESS_ARMOUR",
		not_in_default_perk_pool = false,
		stackable = STACKABLE_YES,
		usable_by_enemies = false,
		author = "Conga Lyne",
		func = function( entity_perk_item, entity_who_picked, item_name )
			--yeah
			--This perk is handled by scripts/perks/take_damage.lua
		end,
	},
	{
		id = "NOHIT_CRITS",
		id_prepend = "RISKY_CRITICAL",
		not_in_default_perk_pool = false,
		stackable = STACKABLE_YES,
		usable_by_enemies = false,
		author = "Conga Lyne",
		func = function( entity_perk_item, entity_who_picked, item_name )
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "mods/noita.thingsmod/content/simple_perks/entities/misc/perks/nohit_crits.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_remove = function( entity_id )
			local dunkorslammod_targets = EntityGetAllChildren(entity_id) or {}
			for i,v in ipairs( dunkorslammod_targets ) do
				if ( v ~= entity_id ) and ( EntityGetName( v ) == "thingsmod_perk_nohit_crits" ) then
					EntityKill ( v )
				end
			end
		end,
	},
	{
		id = "BOUNTIFUL_HUNTER",
		id_prepend = "GENOME_MORE_LOVE",
		ui_name = "$perk_thingsmod_bountiful_hunter_name",
		ui_description = "$perk_thingsmod_bountiful_hunter_desc",
		ui_icon = "mods/noita.thingsmod/content/simple_perks/ui_gfx/perk_icons/bountiful_hunter_ui.png",
		perk_icon = "mods/noita.thingsmod/content/simple_perks/items_gfx/perks/bountiful_hunter.png",
		not_in_default_perk_pool = false,
		stackable = STACKABLE_YES,
		usable_by_enemies = false,
		author = "Copi",
		func = function( entity_perk_item, entity_who_picked, item_name )
			local e = EntityCreateNew()
			EntityAddComponent2(e, "ShotEffectComponent", {extra_modifier="thingsmod_crit_dmg"})
			EntityAddComponent2(e, "InheritTransformComponent")
			EntityAddTag( e, "perk_entity" )
			EntityAddChild( entity_who_picked, e )
		end,
		-- OG: increases spawns, multiplies maxhp by 0.95^(x+5.55), drops temp boosters
		-- idea: on-kill you gain diminishing damage boost against the same enemy type? nah clunky
		-- eh fuck it, just boosters
		-- lets go we can go back to the original concept
	},
}

for _, v in ipairs(custom_perks) do
	local id_lower = v.id:lower()
	local prefix = "noita_thingsmod_simple_perks_"
	v.ui_name = "$" .. prefix .. "perkname_" ..id_lower
	v.ui_description = "$" .. prefix .. "perkdesc_" ..id_lower
	v.ui_icon = ("mods/noita.thingsmod/content/simple_perks/ui_gfx/perk_icons/%s_ui.png"):format(id_lower)
	v.perk_icon = ("mods/noita.thingsmod/content/simple_perks/items_gfx/perks/%s.png"):format(id_lower)
	v.id = "NOITA_THINGSMOD_" .. v.id
	v.author = v.author or "Every Things Dev Team"
	v.mod = v.mod or "Every Things"
end


table_utils.positional_insert(perk_list, custom_perks)
require = _require
