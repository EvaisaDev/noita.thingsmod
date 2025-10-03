local old = death
function death(...)
	old(...)
	local count = tonumber(GlobalsGetValue("PERK_PICKED_NOITA_THINGSMOD_BOUNTIFUL_HUNTER_PICKUP_COUNT", "0"))
	SetRandomSeed(GameGetFrameNum(), (GameGetCameraPos()))
	if true then --count>0 and Random()<=(-0.985^count+1) then
		-- play audio chime
		local x, y = EntityGetTransform( GetUpdatedEntityID() )
		DEBUG_MARK(x, y)
		print"DROPPING"
		local buff = EntityLoad("mods/noita.thingsmod/content/simple_perks/entities/misc/powerup.xml", x, y)
		
		local PISC = EntityGetFirstComponentIncludingDisabled(EntityGetAllChildren(buff)[1], "SpriteComponent") --[[@cast PISC integer]]
		local effect = ({"LEVITATION", "CRITICAL_HIT_BOOST", "MOVEMENT_FASTER", "REMOVE_FOG_OF_WAR", "EXTRA_MONEY", "PROJECTILE_HOMING", "INVISIBILITY", "MANA_REGENERATION", "BERSERK", })[Random(1, 9)]
		if Random()>0.777 then effect = ({"EDIT_WANDS_EVERYWHERE", "REGENERATION", "RAINBOW_FARTS", })[Random(1, 3)] end
		ComponentSetValue2(PISC, "image_file", table.concat{"mods/noita.thingsmod/content/simple_perks/ui_gfx/status_indicators/buffs/", effect, ".png"})
		EntitySetName(buff, effect)
		print("Win! " .. tostring(-0.985^count+1))
	end
end