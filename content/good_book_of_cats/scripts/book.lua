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

        EntityLoad("mods/noita.thingsmod/content/good_book_of_cats/entities/punishment.xml", x, y)

        EntityKill(entity)
    end
end
