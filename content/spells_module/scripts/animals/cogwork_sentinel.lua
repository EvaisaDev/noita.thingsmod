
local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform(entity_id)
EntitySetTransform(entity_id,pos_x,pos_y,rot + 0.01)
local projectile_damage_mult = 1.5 --Damage multiplier

local vsc_comp = EntityGetFirstComponentIncludingDisabled(entity_id,"VariableStorageComponent")
local setup_done = ComponentGetValue2(vsc_comp,"value_bool")

if setup_done == false then
    local projcomp = EntityGetFirstComponentIncludingDisabled(entity_id,"ProjectileComponent")
    EntityAddComponent2(
        entity_id,
        "LifetimeComponent",
        {
            lifetime=ComponentGetValue2(projcomp,"lifetime"),
        }
    )

    EntityRemoveTag(entity_id,"homing_target")
    EntityRemoveTag(entity_id,"enemy")

    ComponentSetValue2(vsc_comp,"value_bool",true)
end

--Split a string separated by a specific character into a table
function SplitStringOnCharIntoTable(string, char)
  local list = {}
  for w in (string .. char):gmatch("([^" .. char .. "]*)" .. char) do
      table.insert(list, w)
  end
  return list
end

--Transfer modifiers from the entity's projectile data onto their actual projectile
function shot( pid )
    --Gun Info
    local entity_id = GetUpdatedEntityID()
    local extract = dofile_once("mods/noita.thingsmod/content/spells_module/scripts/gun/proj_data.lua")
    local projcomp = EntityGetFirstComponentIncludingDisabled(entity_id,"ProjectileComponent")
    local gun_data = extract(projcomp, {2})
    local gun_info = SplitStringOnCharIntoTable(gun_data,string.char(255))

    local pvcomp = EntityGetFirstComponentIncludingDisabled(pid,"VelocityComponent")
    local vel_x, vel_y = ComponentGetValue2(pvcomp,"mVelocity")
    local speed_mult = gun_info[23] or 1 -- Projectile speed
    ComponentSetValue2(pvcomp,"mVelocity", vel_x * speed_mult, vel_y * speed_mult)
    ComponentSetValue2(pvcomp,"gravity_y",ComponentGetValue2(pvcomp,"gravity_y") + (gun_info[53]or 0))
    local pcomp = EntityGetFirstComponentIncludingDisabled(pid,"ProjectileComponent")
    local owner_id = ComponentGetValue2(EntityGetFirstComponentIncludingDisabled(entity_id,"ProjectileComponent"),"mWhoShot") or 0
    ComponentSetValue2(pcomp,"mWhoShot",owner_id)
    ComponentSetValue2(pcomp,"mShooterHerdId",StringToHerdId("player")) --This is supposed to change the summons genome to match the caster, but the game kept seeing "if component ~= 0" and going ahead, followed by complaining that the component is 0. Not sure how to stop noita from crashing out

    --If an enemy is shooting the spell, set the homing target to be 'prey'
    if EntityHasTag(owner_id,"player_unit") == false then
        ComponentSetValue2(EntityGetFirstComponentIncludingDisabled(pid,"HomingComponent"),"target_tag","prey")
    end

    ---Gun data time
    --Damage
        ComponentSetValue2(pcomp,"damage",ComponentGetValue2(pcomp,"damage") + (gun_info[32] * projectile_damage_mult))
        local damagetypes = {
            "melee",
            "projectile",
            "electricity",
            "fire",
            "explosion",
            "ice",
            "slice",
            "healing",
            "curse",
            "drill",
        }
        for u=1,#damagetypes do
            if u ~= 2 or u~= 5 then --2 is projectile, 5 is explosive, both are handled differently
                ComponentObjectSetValue2( pcomp, "damage_by_type", damagetypes[u], ComponentObjectGetValue2( pcomp, "damage_by_type", damagetypes[u]) + (gun_info[30+u] * projectile_damage_mult))
            end
        end
    --Extra Entities
        local extra_children = SplitStringOnCharIntoTable(gun_info[62], ",")
        for u=1,#extra_children do
            if #extra_children[u] > 1 then
                EntityLoadToEntity(extra_children[u],pid)
            end
        end
    --Critical Damage
        ComponentObjectSetValue2( pcomp, "damage_critical", "chance", ComponentObjectGetValue2( pcomp, "damage_critical", "chance") + gun_info[42])
        ComponentObjectSetValue2( pcomp, "damage_critical", "damage_multiplier", ComponentObjectGetValue2( pcomp, "damage_critical", "damage_multiplier") + gun_info[43])
    --Explosions
        ComponentObjectSetValue2( pcomp, "config_explosion", "damage", ComponentObjectGetValue2( pcomp, "config_explosion", "damage") + (gun_info[35] * projectile_damage_mult))
        ComponentObjectSetValue2( pcomp, "config_explosion", "explosion_radius", ComponentObjectGetValue2( pcomp, "config_explosion", "explosion_radius") + gun_info[26])
    --Bounces
        ComponentSetValue2(pcomp,"bounces_left",tonumber(gun_info[52]))
        if tonumber(gun_info[52]) > 0 then
            ComponentSetValue2(pcomp,"bounce_always",true)
            ComponentSetValue2(pcomp,"bounce_energy",0.9)
        end
    --Friendly Fire
        if tostring(gun_info[58]) == "true" then --Why do you only work like this? -Conga
            EntityAddTag(pid,"friendly_fire_enabled")
            ComponentSetValue2(pcomp,"friendly_fire", false)
            ComponentSetValue2(pcomp, "collide_with_shooter_frames", 6 )
        end
    ---Misc Data (Specify)
    --Lifetime
    ComponentSetValue2(pcomp,"lifetime",ComponentGetValue2(pcomp,"lifetime") + gun_info[60])

end