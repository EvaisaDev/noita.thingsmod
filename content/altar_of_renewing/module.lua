local delay = dofile("mods/noita.thingsmod/lib/delay.lua")

local SEARCH_RANGE = 512
local STEP = 16

local function is_world_loaded(x, y)
	return DoesWorldExistAt(x - 4, y - 4, x + 4, y + 4)
end

local function is_open_air(x, y)
	return not RaytraceSurfaces(x - 2, y - 6, x + 2, y + 2)
end

local function ground_below(x, y)
	return RaytraceSurfaces(x, y, x, y + SEARCH_RANGE)
end

local function is_liquid_cover(x, y)
	return RaytraceSurfacesAndLiquiform(x, y - 1, x, y - 5)
end

local function nearest_open_position(px, py)
	local best, best_dist = nil, math.huge
	for cx = px - (SEARCH_RANGE / 2), px + (SEARCH_RANGE / 2), STEP do
		for cy = py - (SEARCH_RANGE / 2), py + (SEARCH_RANGE / 2), STEP do
			if is_open_air(cx, cy) then
				local hit, gx, gy = ground_below(cx, cy)
				if hit and not is_liquid_cover(gx, gy) then
					local x, y = gx, gy - 8
					local d = math.abs(x - px) + math.abs(y - py)
					if d < best_dist then
						best, best_dist = { x = x, y = y }, d
					end
				end
			end
		end
	end
	return best
end

return {
	name = "Altar of Renewing",
	description = "Altar that resets the world with a new seed. Surely this will have no repercussions.",
	authors = { "Evaisa" },
	OnModPreInit = function () 
		ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/coalmine.lua")
		ModLuaFileAppend("data/scripts/biomes/excavationsite.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/excavationsite.lua")
		ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/crypt.lua")
		ModLuaFileAppend("data/scripts/biomes/pyramid.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/pyramid.lua")
		ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/rainforest.lua")
		ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/snowcastle.lua")
		ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/snowcave.lua")
		ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/vault.lua")
		if ModIsEnabled("VolcanoBiome") then
			ModLuaFileAppend("mods/VolcanoBiome/files/biome/inside.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/volcanobiome.lua")
		end
		if ModIsEnabled("biome-plus") then
			ModLuaFileAppend("data/scripts/biomes/mod/blast_pit.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/blast_pit.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/floodcave.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/floodcave.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/frozen_passages.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/frozen_passages.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/holy_temple.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/holy_temple.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/rainforest_wormy.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/rainforest_wormy.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/robofactory.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/robofactory.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/snowvillage.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/snowvillage.lua")
			ModLuaFileAppend("data/scripts/biomes/mod/swamp.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/biome-plus/swamp.lua")
		end
		if ModIsEnabled("noitavania") then
			ModLuaFileAppend("data/scripts/biomes/coalmine_alt.lua", "mods/noita.thingsmod/content/altar_of_renewing/files/biomes/coalmine_alt.lua")
		end
		print("Did this run?")
	end,
	OnPlayerSpawned = function () 
		local h = 30
		local h2 = 54
		local x = 318
		local y = -98

		--testing stuff
		--EntityLoad("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/altar.xml", x + 6, y - h + 1)
		--EntityLoad("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/globe.xml", x + 6, y - h2 + 1)
		--GamePrint("yippee")
	end,
	OnWorldPreUpdate = function () 
		delay.update()
		if not GameHasFlagRun("altar_worldcleared") then return end

		local players = EntityGetWithTag("player_unit") or {}
		local player = players[1]
		if player == nil then
			GameRemoveFlagRun("altar_worldcleared")
			return
		end

		local px, py = EntityGetTransform(player)
		delay.new(function() return is_world_loaded(px, py) end, function()
			local best = nearest_open_position(px, py)
			if not best then
				GameRemoveFlagRun("altar_worldcleared")
				return
			end

			EntityApplyTransform(player, best.x, best.y)
			delay.new(5, function()
				local nx, ny = FindFreePositionForBody(best.x, best.y, 0, 0, 6)
				EntityApplyTransform(player, nx, ny - 4)
				GameRemoveFlagRun("altar_worldcleared")
			end)
		end)
	end,
}