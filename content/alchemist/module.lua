local M = {
	name = "Alchemist",
	description = "he fuckin. spawns idk",
	authors = "infernum",
	OnPlayerSpawned = function(player_entity) 
         EntityLoad("mods/noita.thingsmod/content/alchemist/ascendant_alchemist.xml", 175, -221)
    end,
}

return M