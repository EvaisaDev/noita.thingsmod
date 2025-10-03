local entity_id = GetUpdatedEntityID()
local dmc = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent") --[[@cast dmc integer]]
if dmc then
	local count = tonumber(GlobalsGetValue("PERK_PICKED_NOITA_THINGSMOD_BOUNTIFUL_HUNTER_PICKUP_COUNT", "0") or "0")
	if count>0 then
		ComponentSetValue2(dmc, "max_hp", ComponentGetValue2(dmc, "max_hp")*0.95^(count+5.55))
	end
end



function item_pickup( entity_item, entity_who_picked, item_name )
	local pos_x, pos_y = EntityGetTransform( entity_item ))
	local effect = "NONE"
	local buff = EntityLoad("mods/noita.thingsmod/content/simple_perks/entities/misc/buff_random.xml")
	local GEC = EntityGetFirstComponentIncludingDisabled(buff, "GameEffectComponent") --[[@cast GEC integer]]
	ComponentSetValue2(GEC, "effect", effect)
	EntityKill( entity_item )
end