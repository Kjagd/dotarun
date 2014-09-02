-- Generated from template


require('timers')
if CDotaRun == nil then
	CDotaRun = class({})
end

function Precache( context )
	PrecacheUnitByNameSync("npc_dota_hero_venomancer", context)
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
			for i = 0,9 do
				player = PlayerResource:GetPlayer(i)
				if (player ~=nil) then
					-- player = PlayerResource:GetPlayer(i)
					hero = player:GetAssignedHero()
					hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
				end
			end
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
				-- player = PlayerResource:GetPlayer(i)
				hero = player:GetAssignedHero()
				hero:RemoveModifierByName("modifier_stunned") 
			end
		end
	end
	
end