function spawn_altar_of_renewing(x, y, no_spawner_pixels)
	--[[local w = 184
	local h = 96
	local s = ""
	if no_spawner_pixels == true then
		s = "_no_spawner_pixels"
	end
	LoadPixelScene("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar" .. s .. ".png", "mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar_visual.png", x - (w / 2), y - h + 1, "", true )
	print("did this shit even run?")
	]]
	local h = 30
	local h2 = 50

	EntityLoad("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar.xml", x + 6, y - h + 1)
	EntityLoad("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/globe.xml", x + 6, y - h2 + 1)
	print("did this shit even run? 2")
end

function spawn_altar(x, y)

end