local entity_id = GetUpdatedEntityID()
local dmc = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent") --[[@cast dmc integer]]
if dmc then
	local count = tonumber(GlobalsGetValue("PERK_PICKED_NOITA_THINGSMOD_BOUNTIFUL_HUNTER_PICKUP_COUNT", "0") or "0")
	if count>0 then
		ComponentSetValue2(dmc, "max_hp", ComponentGetValue2(dmc, "max_hp")*0.95^(count+5.55))
	end
end