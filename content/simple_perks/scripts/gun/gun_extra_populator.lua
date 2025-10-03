extra_modifiers["thingsmod_nohit_crits"] = function()
    shot_effects.recoil_knockback = 0
    c.damage_critical_chance = c.damage_critical_chance + 100
end

extra_modifiers["thingsmod_crit_dmg"] = function()
	if not c.bountiful_hunter then
		c.bountiful_hunter=true
		c.damage_critical_multiplier=c.damage_critical_multiplier+1
	end
end
