
local custom_perk_perkappends = {
	{
		id = "WET_ARMOR",
		id_append = "STAINLESS_ARMOUR",
		ui_name = "$perk_thingsmod_wet_armor_name",
		ui_description = "$perk_thingsmod_wet_armor_desc",
		ui_icon = "mods/noita.thingsmod/content/simple_perks/ui_gfx/perk_icons/sweatarmor_ui.png",
		perk_icon = "mods/noita.thingsmod/content/simple_perks/items_gfx/perks/sweatarmor.png",
		not_in_default_perk_pool = false,
		stackable = STACKABLE_YES,
		usable_by_enemies = false,
		author = "Conga Lyne",
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue("NOITA_THINGSMOD_WET_ARMOR_COUNT",tostring(tonumber(GlobalsGetValue("NOITA_THINGSMOD_WET_ARMOR_COUNT","0")) + 1))
		end,
		func_remove = function( entity_id )
			GlobalsSetValue("NOITA_THINGSMOD_WET_ARMOR_COUNT","0")
		end,
	},
	{
		id = "NOHIT_CRITS",
		id_prepend = "RISKY_CRITICAL",
		ui_name = "$perk_thingsmod_nohit_crits_name",
		ui_description = "$perk_thingsmod_nohit_crits_desc",
		ui_icon = "mods/noita.thingsmod/content/simple_perks/ui_gfx/perk_icons/nohit_crits_ui.png",
		perk_icon = "mods/noita.thingsmod/content/simple_perks/items_gfx/perks/nohit_crits.png",
		not_in_default_perk_pool = false,
		stackable = STACKABLE_YES,
		usable_by_enemies = false,
		author = "Conga Lyne",
		func = function( entity_perk_item, entity_who_picked, item_name )
			GlobalsSetValue("NOITA_THINGSMOD_NOHIT_CRITS_COUNT",tostring(tonumber(GlobalsGetValue("NOITA_THINGSMOD_NOHIT_CRITS_COUNT","0")) + 1))

			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "mods/noita.thingsmod/content/simple_perks/entities/misc/perks/nohit_crits.xml", x, y )
			EntityAddTag( child_id, "perk_entity" )
			EntityAddChild( entity_who_picked, child_id )
		end,
		func_remove = function( entity_id )
			local dunkorslammod_targets = EntityGetAllChildren(entity_id)
			for i,v in ipairs( dunkorslammod_targets ) do
				if ( v ~= entity_id ) and ( EntityGetName( v ) == "thingsmod_perk_nohit_crits" ) then
					EntityKill ( v )
				end
			end
			GlobalsSetValue("NOITA_THINGSMOD_NOHIT_CRITS_COUNT","0")
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


do
	for k=1,#custom_perk_perkappends
	do local v = custom_perk_perkappends[k]

		v.id = "NOITA_THINGSMOD_" .. v.id

		-- Disables the perk from spawning if it's not unlocked
		if v.unlock_flag then
			if HasFlagPersistent( v.unlock_flag ) == false then
				v.not_in_default_perk_pool = true
			end
		end

		--Adds Perk into the list at the position we want
		if v.id_prepend == nil and v.id_append == nil then
			v.author    = v.author  or "Mod Name Dev Team"
			v.mod       = v.mod     or "Mod Name Mod"
			table.insert(perk_list,v)
		else
			for z=1,#perk_list
			do c = perk_list[z]
				if c.id == v.id_prepend then
					v.author    = v.author  or "Mod Name Dev Team"
					v.mod       = v.mod     or "Mod Name Mod"
					table.insert(perk_list,z,v)
					break
				elseif c.id == v.id_append or z == #perk_list then
					v.author    = v.author  or "Mod Name Dev Team"
					v.mod       = v.mod     or "Mod Name Mod"
					table.insert(perk_list,z + 1,v)
					break
				end
			end
		end
	end
end
