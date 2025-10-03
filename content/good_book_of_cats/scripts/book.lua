function enabled_changed(entity_id, enabled)
        (enabled and GameAddFlagRun or GameRemoveFlagRun)("NOITA_THINGSMOD_CAT_BOOK_HELD")
end

function too_damaged(entity)
    local phys = EntityGetFirstComponentIncludingDisabled(entity, "PhysicsBodyComponent")
    if not phys then
        return true
    end

    return ComponentGetValue2(phys, "mPixelCount") < 100
end

function physics_body_modified(is_destroyed)
    local entity = GetUpdatedEntityID()
    if is_destroyed or too_damaged(entity) then
        local x, y = EntityGetTransform(entity)

        if tonumber(GlobalsGetValue("STEVARI_DEATHS", "0")) < 3 then
            GlobalsGetValue("STEVARI_DEATHS", "3")
        end

        GlobalsSetValue("TEMPLE_PEACE_WITH_GODS", "0")
        GamePrintImportant("$logdesc_gods_are_very_angry", "")
        EntityLoad("data/entities/animals/necromancer_super.xml", x, y)

        EntityKill(entity)
    end
end
