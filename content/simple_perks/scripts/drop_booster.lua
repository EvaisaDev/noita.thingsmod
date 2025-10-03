local old = death
function death(...)
	old(...)
	local count = tonumber(GlobalsGetValue("PERK_PICKED_NOITA_THINGSMOD_BOUNTIFUL_HUNTER_PICKUP_COUNT", "0"))
	SetRandomSeed(GameGetFrameNum(), (GameGetCameraPos()))
	if count>0 and Random()<=(-0.985^count+1) then
		-- Enemy drops a power-up pickup
		-- Disappears after a few seconds
		-- Gives 30s of a random buff (seen on the pickup)
		print("Win! " .. tostring(-0.985^count+1))
	end
end