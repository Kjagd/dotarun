-- Generated from template


require('timers')
if CDotaRun == nil then
	CDotaRun = class({})
end

function Precache( context )
	PrecacheUnitByNameSync("npc_dota_hero_venomancer", context)
	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
	PrecacheUnitByNameSync("npc_dota_hero_dark_seer", context)
	PrecacheUnitByNameSync("npc_dota_hero_batrider", context)
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_gyrocopter", context)
	PrecacheUnitByNameSync("npc_dota_hero_necrolyte", context)
	PrecacheUnitByNameSync("npc_dota_hero_obsidian_destroyer", context)

	-- PrecacheItemByNameSync("mirana_arrow", context)
	-- PrecacheItemByNameSync("venomancer_venomous_gale", context)
	-- PrecacheItemByNameSync("mirana_leap", context)
	-- PrecacheItemByNameSync("dark_seer_surge", context)
	-- PrecacheItemByNameSync("jakiro_ice_path", context)
	-- PrecacheItemByNameSync("batrider_flamebreak", context)
	-- PrecacheItemByNameSync("ancient_apparition_ice_vortex", context)
	-- PrecacheItemByNameSync("gyrocopter_homing_missile", context)
	-- PrecacheItemByNameSync("obsidian_destroyer_astral_imprisonment", context)
	-- PrecacheItemByNameSync("necrolyte_death_pulse", context)

	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	print("init")
	GameRules.dotaRun = CDotaRun()
	GameRules.dotaRun:InitGameMode()
end

function CDotaRun:InitGameMode()
	self.waypoints = {}
	for i = 0, 9 do
    self.waypoints[i] = {}

    	for j = 1, 3 do
        	self.waypoints[i][j] = false -- Fill the values here
    	end
	end
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent('dota_item_used', Dynamic_Wrap(CDotaRun, 'OnItemUsed'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CDotaRun, 'OnNPCSpawned'), self)
	-- ListenToGameEvent("game_start", Dynamic_Wrap(CDotaRun, 'On_game_start'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CDotaRun, 'On_game_rules_state_change'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CDotaRun, 'OnAbilityUsed'), self) 
end

function CDotaRun:OnPlayerConnectFull(keys)
    
    print("player connected")

end

function CDotaRun:OnItemUsed(keys)
    
    print("item used")

end


-- Evaluate the state of the game
function CDotaRun:OnThink()
	-- print("Thinking")

	-- if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			
	-- end

	-- if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	-- 	for i = 0,9 do
	-- 		player = PlayerResource:GetPlayer(i)
	-- 		hero = player:GetAssignedHero()
	-- 		hero:RemoveModifierByName(modifier_stunned) 
	-- 	end
	-- end
	return 1
end

function CDotaRun:OnNPCSpawned( keys )
    local spawnedUnit = EntIndexToHScript( keys.entindex )
    if string.find(spawnedUnit:GetUnitName(), "hero") then
    	
        Timers:CreateTimer(0.6, function()
        	local ability = spawnedUnit:FindAbilityByName("Immunity")
			ability:SetLevel(1)
			playerID = spawnedUnit:GetPlayerID() 
			player = PlayerResource:GetPlayer(playerID)
			hero = player:GetAssignedHero() 
			hero:SetAbilityPoints(0)
			if (GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS) then
				hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
			end
			AddFillerAbility(hero)
			-- for i = 0,9 do
			-- 	player = PlayerResource:GetPlayer(playerID)
			-- 	if (player ~=nil) then
			-- 		-- player = PlayerResource:GetPlayer(i)
			-- 		hero = player:GetAssignedHero()
			-- 		hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
			-- 		AddFillerAbility(hero)
			-- 	end
			-- end
            return
        end
        )
    end
end

-- function CDotaRun:On_game_start(data)
-- 	print("game starting")
-- 	for i = 0,9 do
-- 		player = PlayerResource:GetPlayer(i)
-- 		hero = player:GetAssignedHero()
-- 		hero:RemoveModifierByNameAndCaster("modifier_stunned", caster)
-- 		hero:RemoveModifierByName("modifier_stunned") 
-- 	end
-- end

function CDotaRun:On_game_rules_state_change( data )
	print("game starting!")
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for i = 0,9 do
			player = PlayerResource:GetPlayer(i)
			if (player ~=nil) then
				hero = player:GetAssignedHero()
				if (hero ~=nil) then
					hero:RemoveModifierByName("modifier_stunned") 
				end
			end
		end
	end
	
end

function CDotaRun:OnAbilityUsed(data)
		

	print("Removing ability "..data.abilityname)
	player = PlayerResource:GetPlayer(data.PlayerID-1)
	hero = player:GetAssignedHero()
	
	ability = hero:FindAbilityByName(data.abilityname)
	if(ability ~= nil) then
		Timers:CreateTimer(4, function()
			ability:SetLevel(0)
			print(ability:GetLevel())
        	hero:RemoveAbility(data.abilityname)
        	if(hero:FindAbilityByName(data.abilityname) ~= nil) then
        		hero:RemoveAbility("mirana_fart")
        	end
        	AddFillerAbility(hero)
            return
         end
         )
	else
		Timers:CreateTimer(1, function() 
			print("Deleting item")
			for i=0,5,1 do 
	   			item = hero:GetItemInSlot(i)
	    		if  item ~= nil then
		    		if(item:GetClassname() == data.abilityname) then
		    			hero:RemoveItem(item)
	    			end
	    		end
	   		end
	   		return
	   	end
	    )
	end
end

function AddFillerAbility(hero)
	hero:AddAbility("mirana_fart")
	ability = hero:FindAbilityByName("mirana_fart")
	ability:SetAbilityIndex(1) 
	ability:SetLevel(1)
end