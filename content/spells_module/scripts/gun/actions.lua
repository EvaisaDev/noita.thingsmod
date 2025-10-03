-- some mod seems to cause issues if require is defined, CE?
local _require = require
dofile("mods/noita.thingsmod/require.lua")
local table_utils = require "lib.table_utils.table_utils"

local custom_spellappends = {
	{
		id          = "MONO_CAST",
		id_prepend  = "BURST_2",
		type 		= ACTION_TYPE_DRAW_MANY,
		spawn_level                       = "0,1",
		spawn_probability                 = "0.1,0.1",
		author = "Conga Lyne",
		price = 100,
		mana = 0,
		action 		= function()
			do return end
            if ( #deck > 0 ) then
                
                local function isSpellPresent(table_to_search,id)
                    for i=1,#table_to_search do
                        if table_to_search[i] == id then return true end
                    end
                    return false
                end

                local function banishDuplicatespells(table_to_search)
                    local duplicates = {}
                    local table_of_first_appearances = {}
                    local data = {}
                    for k=1,#table_to_search do
                        local pos = k
                        
                        if isSpellPresent(table_of_first_appearances,table_to_search[pos].id) then
                            --discard from deck
                            --Add to discard
                            data = table_to_search[pos]
                            table.insert( duplicates, pos )
                            --table.insert( discarded, data )
                        elseif table_to_search[pos].uses_remaining == nil or table_to_search[pos].uses_remaining ~= 0 then
                            --Add to first appearances
                            table.insert( table_of_first_appearances, table_to_search[pos].id)
                        end
                    end

                    if #duplicates > 0 then
                        for k=1,#duplicates do
                            local pos = #duplicates+1 - k
                            table.insert( discarded, table_to_search[duplicates[pos]] )
                            table.remove( table_to_search, duplicates[pos] )
                        end
                    end
                    return table_to_search
                end

                deck = banishDuplicatespells(deck)
                hand = banishDuplicatespells(hand)
            end

            draw_actions( 1, true ) 
		end,
	},
    {
        id          = "COGWORK_SENTINEL",
        type 		= ACTION_TYPE_PROJECTILE,
        spawn_level                       = "4,5,10", -- WYRM
        spawn_probability                 = "0.05,0.05,0.1", -- WYRM
        author = "Conga Lyne",
        price = 220,
        mana = 120,
        related_projectiles	= {"mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel_projectile.xml", 1},
        pandorium_ignore = true,
        action 		= function()
            if reflecting then
                add_projectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel_projectile.xml" ) --Sentinel's Projectile Filepath
                current_reload_time = current_reload_time + 60
                return
            end

            local c_old = c

            BeginProjectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/trigger_projectile.xml" ) --Dummy
                BeginTriggerDeath()
                    WriteCToDatat(c_old)

                    BeginProjectile( "mods/noita.thingsmod/content/spells_module/entities/projectiles/deck/cogwork_sentinel.xml" ) --Sentinel
                    EndProjectile()
                    register_action({
                        --Hacky but functional, I'm probably wildly misusing this -Conga
                        action_description = DontTouch_Data[2],
                        lifetime_add = c_old["lifetime_add"],
                    })
                    SetProjectileConfigs()
                EndTrigger()
            EndProjectile()
            current_reload_time = current_reload_time + 60
        end,
    },
}

for _, v in ipairs(custom_spellappends) do
	local id_lower = v.id:lower()
	v.name = "$noita_thingsmod_spells_module_actionname_" .. id_lower
	v.description = "$noita_thingsmod_spells_module_actiondesc_" .. id_lower
	v.sprite = ("mods/noita.thingsmod/content/spells_module/ui_gfx/gun_actions/%s.png"):format(id_lower)
	v.id = "NOITA_THINGSMOD_" .. v.id
	v.author = v.author or "Every Things Dev Team"
	v.mod = v.mod or "Every Things"
end

table_utils.positional_insert(actions, custom_spellappends)
require = _require
