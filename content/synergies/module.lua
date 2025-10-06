-- Shit code from a 4 year old abandoned mod, probably terrible but I do not care.

---@type Module
local M = {
	name = "Synergies",
	description = "Synergy effects between perks, and spells.",
	authors = { "Evaisa" },
}

local placeholders = dofile("mods/noita.thingsmod/content/synergies/scripts/placeholders.lua")
dofile("mods/noita.thingsmod/content/synergies/scripts/synergies.lua")
dofile("data/scripts/perks/perk_list.lua")

local active_skins, active_overlays, active_capes = {}, {}, {}
local original_sprite, original_arm, original_cape_color, original_cape_color_edge

M.OnMagicNumbersAndWorldSeedInitialized = function()
	for _, s in pairs(synergies) do
		local base = "mods/synergies/files/" .. s.id
		s._replacement_xml = base .. "_replacement.xml"
		s._overlay_xml = base .. "_overlay.xml"
		s._arm_xml = base .. "_arm.xml"
		if s.skin_replacement ~= nil then
			ModTextFileSetContent(s._replacement_xml, placeholders.gfx_replacement:gsub("replace_this", s.skin_replacement))
		end
		if s.skin_overlay ~= nil then
			ModTextFileSetContent(s._overlay_xml, placeholders.gfx_overlay:gsub("replace_this", s.skin_overlay))
		end
		if s.skin_arm ~= nil then
			ModTextFileSetContent(s._arm_xml, placeholders.gfx_arm:gsub("replace_this", s.skin_arm))
		end
	end
end

M.OnPlayerSpawned = function(player)
	if not GameHasFlagRun("synergy_lib_has_run") then
		local sprite_components = EntityGetComponent(player, "SpriteComponent", "character")
		local sprite_component
		for _, c in pairs(sprite_components) do
			if math.floor(ComponentGetValue2(c, "z_index") * 10) / 10 == 0.6 then
				sprite_component = c
			end
		end

		local children = EntityGetAllChildren(player) or {}
		for _, child in pairs(children) do
			local n = EntityGetName(child)
			if n == "arm_r" then
				local sc = EntityGetFirstComponent(child, "SpriteComponent")
				original_arm = ComponentGetValue2(sc, "image_file")
				local stor = EntityGetComponent(player, "VariableStorageComponent")
				local set = false
				if stor ~= nil then
					for _, v in pairs(stor) do
						if ComponentGetValue2(v, "name") == "original_arm" then
							ComponentSetValue2(v, "value_string", original_arm)
							set = true
						end
					end
				end
				if not set then
					EntityAddComponent2(player, "VariableStorageComponent", { name = "original_arm", value_string = original_arm })
				end
			elseif n == "cape" then
				local vc = EntityGetFirstComponent(child, "VerletPhysicsComponent")
				original_cape_color = ComponentGetValue2(vc, "cloth_color")
				original_cape_color_edge = ComponentGetValue2(vc, "cloth_color_edge")
				local stor = EntityGetComponent(player, "VariableStorageComponent")
				local set_color, set_edge = false, false
				if stor ~= nil then
					for _, v in pairs(stor) do
						local nm = ComponentGetValue2(v, "name")
						if nm == "original_cape_color" then
							ComponentSetValue2(v, "value_int", original_cape_color)
							set_color = true
						elseif nm == "original_cape_color_edge" then
							ComponentSetValue2(v, "value_int", original_cape_color_edge)
							set_edge = true
						end
					end
				end
				if not set_color then
					EntityAddComponent2(player, "VariableStorageComponent", { name = "original_cape_color", value_int = original_cape_color })
				end
				if not set_edge then
					EntityAddComponent2(player, "VariableStorageComponent", { name = "original_cape_color_edge", value_int = original_cape_color_edge })
				end
			end
		end

		original_sprite = ComponentGetValue2(sprite_component, "image_file")
		local stor = EntityGetComponent(player, "VariableStorageComponent")
		local set = false
		if stor ~= nil then
			for _, v in pairs(stor) do
				if ComponentGetValue2(v, "name") == "original_sprite" then
					ComponentSetValue2(v, "value_string", original_sprite)
					set = true
				end
			end
		end
		if not set then
			EntityAddComponent2(player, "VariableStorageComponent", { name = "original_sprite", value_string = original_sprite })
		end
		GameAddFlagRun("synergy_lib_has_run")
	else
		local stor = EntityGetComponent(player, "VariableStorageComponent") or {}
		for _, v in pairs(stor) do
			local nm = ComponentGetValue2(v, "name")
			if nm == "original_sprite" then
				original_sprite = ComponentGetValue2(v, "value_string")
			elseif nm == "original_arm" then
				original_arm = ComponentGetValue2(v, "value_string")
			elseif nm == "original_cape_color" then
				original_cape_color = ComponentGetValue2(v, "value_int")
			elseif nm == "original_cape_color_edge" then
				original_cape_color_edge = ComponentGetValue2(v, "value_int")
			end
		end
	end
end

M.OnWorldPreUpdate = function()
	local players = EntityGetWithTag("player_unit") or {}
	for _, player in pairs(players) do
		local px, py = EntityGetTransform(player)

		if GameHasFlagRun("outfit_changed") then
			local sprite_components = EntityGetComponent(player, "SpriteComponent", "character")
			local sc
			for _, c in pairs(sprite_components or {}) do
				if math.floor(ComponentGetValue2(c, "z_index") * 10) / 10 == 0.6 then sc = c end
			end

			local final_sprite = original_sprite
			for _, v in pairs(active_skins) do
				if v.active then final_sprite = v.skin break end
			end
			if sc then
				ComponentSetValue2(sc, "image_file", final_sprite)
				EntityRefreshSprite(player, sc)
			end

			local arm_sc, cape_vc, arm, cape
			local children = EntityGetAllChildren(player) or {}
			for _, child in pairs(children) do
				local n = EntityGetName(child)
				if n == "arm_r" then
					arm_sc = EntityGetFirstComponent(child, "SpriteComponent")
					arm = child
				elseif n == "cape" then
					cape_vc = EntityGetFirstComponent(child, "VerletPhysicsComponent")
					cape = child
				end
			end

			if arm_sc then
				local arm_file = original_arm
				for _, v in pairs(active_skins) do
					if v.active and v.has_arm then arm_file = v.s._arm_xml break end
				end
				ComponentSetValue2(arm_sc, "image_file", arm_file)
				EntityRefreshSprite(arm or player, arm_sc)
			end

			if cape_vc then
				local color, edge = original_cape_color, original_cape_color_edge
				for _, v in pairs(active_capes) do
					if v.active then
						local s = v.s
						if s.cape_color ~= nil then color = s.cape_color end
						if s.cape_color_edge ~= nil then edge = s.cape_color_edge end
					end
				end
				ComponentSetValue2(cape_vc, "cloth_color", color)
				ComponentSetValue2(cape_vc, "cloth_color_edge", edge)
			end

			local overlays = EntityGetComponent(player, "SpriteComponent", "synergy_outfit")
			if overlays ~= nil then for i = 1, #overlays do EntityRemoveComponent(player, overlays[i]) end end
			for _, v in pairs(active_overlays) do
				if v.active then
					EntityAddComponent2(player, "SpriteComponent", {
						_tags = "character,synergy_outfit",
						alpha = 1,
						image_file = v.skin,
						next_rect_animation = "",
						offset_x = 6,
						offset_y = 14,
						rect_animation = "walk",
						z_index = 0.59,
					})
				end
			end

			GameRemoveFlagRun("outfit_changed")
		end

		local inv = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
		local wand = inv and ComponentGetValue2(inv, "mActiveItem") or nil
		if not wand then goto continue end

		local children = EntityGetAllChildren(wand) or {}
		local spell_count_by_id, spell_seen = {}, {}
		for _, spell in ipairs(children) do
			local comps = EntityGetComponentIncludingDisabled(spell, "ItemActionComponent") or {}
			for _, c in ipairs(comps) do
				local id = ComponentGetValue2(c, "action_id")
				local n = (spell_count_by_id[id] or 0) + 1
				spell_count_by_id[id] = n
				if n == 1 then spell_seen[id] = true end
			end
		end

		local perk_once, perk_count = {}, {}
		for _, perk in ipairs(perk_list) do
			local id = perk.id
			if GameHasFlagRun("PERK_PICKED_" .. id) then
				perk_once[id] = 1
				local k = tostring(GlobalsGetValue("PERK_PICKED_" .. id) .. "_PICKUP_COUNT")
				perk_count[id] = tonumber(k, 10) or 1
			end
		end

		for _, s in pairs(synergies) do
			local pc, sc = 0, 0
			local rp, rs = s.required_perks, s.required_spells
			if rp and rp.count_duplicates then
				for _, id in pairs(rp.list or {}) do pc = pc + (perk_count[id] or 0) end
			else
				for _, id in pairs((rp and rp.list) or {}) do pc = pc + (perk_once[id] or 0) end
			end
			if rs and rs.count_duplicates then
				for _, id in pairs(rs.list or {}) do sc = sc + (spell_count_by_id[id] or 0) end
			else
				for _, id in pairs((rs and rs.list) or {}) do sc = sc + (spell_seen[id] and 1 or 0) end
			end

			local active = GameHasFlagRun("synergy_" .. s.id)
			if active then
				if s.use_synergy_points then
					if (pc * s.perk_value) + (sc * s.spelll_value) < s.points_required then
						s.func_removed(player, px, py, s)
						GameRemoveFlagRun("synergy_" .. s.id)
						for i = #active_skins, 1, -1 do if active_skins[i].s == s then table.remove(active_skins, i) end end
						for i = #active_capes, 1, -1 do if active_capes[i].s == s then table.remove(active_capes, i) end end
						for i = #active_overlays, 1, -1 do if active_overlays[i].s == s then table.remove(active_overlays, i) end end
						GameAddFlagRun("outfit_changed")
					end
				else
					if pc < (rp and rp.min_count or 0) or sc < (rs and rs.min_count or 0) then
						s.func_removed(player, px, py, s)
						GameRemoveFlagRun("synergy_" .. s.id)
						for i = #active_skins, 1, -1 do if active_skins[i].s == s then table.remove(active_skins, i) end end
						for i = #active_capes, 1, -1 do if active_capes[i].s == s then table.remove(active_capes, i) end end
						for i = #active_overlays, 1, -1 do if active_overlays[i].s == s then table.remove(active_overlays, i) end end
						GameAddFlagRun("outfit_changed")
					end
				end
			else
				if s.use_synergy_points then
					if (pc * s.perk_value) + (sc * s.spelll_value) < s.points_required then
						s.func_added(player, px, py, s)
						GameAddFlagRun("synergy_" .. s.id)
						if s.skin_replacement ~= nil then
							for _, v in pairs(active_skins) do v.active = false end
							local has_arm = s.skin_arm ~= nil
							table.insert(active_skins, { active = true, s = s, skin = s._replacement_xml, has_arm = has_arm })
						end
						if s.cape_color ~= nil or s.cape_color_edge ~= nil then
							table.insert(active_capes, { active = true, s = s })
						end
						if s.skin_overlay ~= nil then
							table.insert(active_overlays, { active = true, s = s, skin = s._overlay_xml, has_arm = false })
						end
						GameAddFlagRun("outfit_changed")
					end
				else
					if pc >= (rp and rp.min_count or 0) and sc >= (rs and rs.min_count or 0) then
						s.func_added(player, px, py, s)
						GameAddFlagRun("synergy_" .. s.id)
						if s.skin_replacement ~= nil then
							for _, v in pairs(active_skins) do v.active = false end
							local has_arm = s.skin_arm ~= nil
							table.insert(active_skins, { active = true, s = s, skin = s._replacement_xml, has_arm = has_arm })
						end
						if s.cape_color ~= nil or s.cape_color_edge ~= nil then
							table.insert(active_capes, { active = true, s = s })
						end
						if s.skin_overlay ~= nil then
							table.insert(active_overlays, { active = true, s = s, skin = s._overlay_xml, has_arm = false })
						end
						GameAddFlagRun("outfit_changed")
					end
				end
			end
		end

		::continue::
	end
end

return M
