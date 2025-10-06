-- This is ported from a 4 year old abandoned mod project, i have no idea how robust it is.
synergies = {
	-- Example:
	--[[{
		id = "lightning_synergy", -- The ID of the synergy, has to be unique.
		use_synergy_points = false, -- Use synergy point system, combines perks and spells into a single value.
		points_required = 0, -- Part of the synergy point system, if the total points are higher than this the synergy will be active.
		perk_value = 5, -- How much a perk is worth in terms of synergy points.
		spell_value = 1, -- How much a spell is worth in terms of synergy points.
        required_perks = {
			min_count = 1, -- How many perks are required to activate the synergy, only used if the synergy points system is disabled.
			count_duplicates = false, -- Count duplicate perks?
            list = { -- A table of perk IDs that work for this synergy.
                "PROTECTION_ELECTRICITY",
                "ELECTRICITY",
            }
        },
        required_spells = {
			min_count = 2, -- How many spells are required to activate the synergy, only used if the synergy points system is disabled.
			count_duplicates = false, -- Count duplicate spells?
            list = { -- A table of spell IDs that work for this synergy.
                "ELECTRIC_CHARGE",
                "LIGHTNING_RAY",
                "LIGHTNING_RAY_ENEMY",
                "CURSE_WITHER_ELECTRICITY",
                "ARC_ELECTRIC",
                "TORCH_ELECTRIC",
                "LIGHTNING",
                "BALL_LIGHTNING",
            }
		},
		cape_color = 0xffbdb079, -- The color that the cape will be changed to when this synergy is active.
		cape_color_edge = 0xffbdb079,-- The color that the cape edge will be changed to when this synergy is active.
        skin_replacement = "mods/noita.thingsmod/content/synergies/gfx/ukkomina.png", -- A spritesheet that will replace the player sprite when this synergy is enabled.
        skin_arm = "mods/noita.thingsmod/content/synergies/gfx/ukkoarm.png", -- The arm spritesheet that the player's arm will be changed to when this synergy is active.
        skin_overlay = nil, -- A overlay sprite, can be used instead of a complete skin replacement.
		func_added = function(entity_id, x, y, synergy) -- The function that will be ran when the synergy is enabled.
            GamePrint("You got a lightning synergy!")
		end,
		func_removed = function(entity_id, x, y, synergy) -- The function that will be ran when the synergy is disabled.
            GamePrint("You lost a lightning synergy!")
		end
    },]]
}