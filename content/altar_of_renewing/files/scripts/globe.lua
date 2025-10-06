local altar = GetUpdatedEntityID()

function get_origin()
	if GetValueInteger("globe_origin_x", 0) ~= 0 and GetValueInteger("globe_origin_y", 0) ~= 0 then
		return GetValueInteger("globe_origin_x", 0), GetValueInteger("globe_origin_y", 0)
	end
	local origin_x, origin_y = EntityGetTransform( EntityGetRootEntity( altar ) )
	SetValueInteger("globe_origin_x", origin_x)
	SetValueInteger("globe_origin_y", origin_y)
	return origin_x, origin_y
end

function lock(offset_x, offset_y)
	local origin_x, origin_y = get_origin()
	origin_x = origin_x + (offset_x or 0)
	origin_y = origin_y + (offset_y or 0)
	local x, y = EntityGetTransform( altar )
	local dx = origin_x - x
	local dy = origin_y - y
	local dist2 = dx*dx + dy*dy
	if dist2 < 4 then
		return
	end
	local physics_body = EntityGetFirstComponent( altar, "PhysicsBody2Component" )
	if not physics_body then return end
	local vx, vy = PhysicsGetComponentVelocity( altar, physics_body )
	local k = 80
	local c = 20
	local fx = k * dx - c * vx
	local fy = k * dy - c * vy
	local fmag = math.sqrt(fx * fx + fy * fy)
	local max_f = 6000
	if fmag > max_f then
		fx = fx / fmag * max_f
		fy = fy / fmag * max_f
	end
	PhysicsApplyForce( altar, fx, fy )
end



function reset_world()
	local seed = GetValueInteger("world_seed", 0)
	SetWorldSeed(seed)
	BiomeMapLoad_KeepPlayer(MagicNumbersGetValue("BIOME_MAP"), "data/biome/_pixel_scenes.xml")
	GameAddFlagRun("altar_worldcleared")
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	if(GetValueBool("world_reset", false))then return end
	local x, y = EntityGetTransform(entity_interacted)
	SetRandomSeed(x, y + GameGetFrameNum())
	local seed = Random(1, 2147483646) + Random(1, 2147483646)
	SetValueInteger("world_seed", seed)
	SetValueBool("world_reset", true)
	if GetValueInteger("reset_start_frame", 0) == 0 then
		SetValueInteger("reset_start_frame", GameGetFrameNum())
	end
	SetValueBool("globe_arrived", false)
end

if(GetValueBool("world_reset", false))then
	local x, y = EntityGetTransform( altar )
	local reset_start_frame = GetValueInteger("reset_start_frame", 0)
	if reset_start_frame == 0 then
		reset_start_frame = GameGetFrameNum()
		SetValueInteger("reset_start_frame", reset_start_frame)
	end
	local duration_seconds = 9
	if duration_seconds <= 0 then duration_seconds = 6 end
	local frames_elapsed = GameGetFrameNum() - reset_start_frame
	local t = frames_elapsed / (duration_seconds * 60)
	if t >= 1 then
		GameSetPostFxParameter("globe_warp_screen", x, y, 0, 0)
		SetValueInteger("reset_start_frame", 0)
		SetValueBool("world_reset", false)
		reset_world()
	else
		if(t > 0.9 and not GetValueBool("death_sphere", false))then
			EntityLoad("mods/noita.thingsmod/content/altar_of_renewing/files/entities/altar/fucked_up_death_sphere.xml", x, y)
			SetValueBool("death_sphere", true)
		end
		lock(0, -20)

		-- time should be a curve that speeds up exponentially but starts out slow
		local time = t * t

		-- removed the shader because it wasn't worth the effort
		--GameSetPostFxParameter("globe_warp_screen", x, y, time * 64 --[[radius]] , time * 3 --[[intensity]] )
		PhysicsApplyTorque( altar, 80 + 170 * t )
	end
else
	SetValueInteger("reset_start_frame", 0)
	lock()
end
