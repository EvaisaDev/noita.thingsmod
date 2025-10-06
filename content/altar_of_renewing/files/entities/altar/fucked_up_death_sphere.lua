local entity = GetUpdatedEntityID()

local x, y = EntityGetTransform( entity )

current_sphere_size = current_sphere_size or 0

local sprite_comp = EntityGetFirstComponent( entity, "SpriteComponent" )
ComponentSetValue2( sprite_comp, "special_scale_x", current_sphere_size)
ComponentSetValue2( sprite_comp, "special_scale_y", current_sphere_size)

EntityRefreshSprite( entity, sprite_comp )

-- grow exponentially
current_sphere_size = current_sphere_size + (0.02 + current_sphere_size * 0.1)