-- Generated from template


require('timers')
require('pudge')
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
	PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	PrecacheUnitByNameSync("npc_dota_hero_templar_assassin", context)

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
	self.TaTrapFired = false
	self.itemList = { "item_blink", "item_cyclone", "item_shivas_guard", "item_sheepstick", "item_ancient_janggo", "item_rod_of_atos"}
	self.spellList = {"mirana_arrow_custom", "mirana_leap_custom", "venomancer_venomous_gale_custom", "dark_seer_surge_custom", "jakiro_ice_path_custom", 
	"batrider_flamebreak_custom", "ancient_apparition_ice_vortex_custom", "gyrocopter_homing_missile_custom", "obsidian_destroyer_astral_imprisonment_custom", "pudge_meat_hook_custom"}

	self.goodLaps = 0
	self.badLaps = 0

	-- GameRules:SetSameHeroSelectionEnabled( true )
	-- DebugDrawText(Vector(-5464,-6529,20), "Get items and abilities by running through these", false, -1) 

	self.playerCount = 0
	self.killHeroForWin = false

	self.zoneOpen = {}
	
	self.waypoints = {}
	
	self.spawned = {}
	
	self.waypointleader = {}

	self.lead = -1

	

	initPudges()

	CDotaRun:ResetRound()


	ListenToGameEvent('dota_item_used', Dynamic_Wrap(CDotaRun, 'OnItemUsed'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CDotaRun, 'OnNPCSpawned'), self)
	-- ListenToGameEvent("game_start", Dynamic_Wrap(CDotaRun, 'On_game_start'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CDotaRun, 'On_game_rules_state_change'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CDotaRun, 'OnAbilityUsed'), self) 
	-- ListenToGameEvent('player_connect_full', Dynamic_Wrap(CDotaRun, 'OnPlayerConnectFull'), self)
	-- ListenToGameEvent('dota_player_used_ability', ApplyCooldownReduction, {} )


	print( "Dotarun has literally loaded." )

	
end

function CDotaRun:FindTrees()

	--This works
	
	-- mightbetrees = {}

	-- mightbetrees[1] = Entities:FindAllByClassname("ent_dota_tree")
	-- DeepPrintTable(mightbetrees[1])
	-- for key,value in pairs(mightbetrees[1]) do 
	-- 	-- mightbetrees[1][key]:CutDown(DOTA_TEAM_GOODGUYS)
	-- 	mightbetrees[1][key]:CutDownRegrowAfter(RandomFloat(0, 15), DOTA_TEAM_GOODGUYS)  
 --    	-- print("Classname: " .. mightbetrees[1][key]:GetClassname())
	-- end





	-- mightbetrees[2] = Entities:FindAllByClassname("MapTree")
	-- mightbetrees[3] = Entities:FindAllByModel("CDOTA_MapTree")
	-- mightbetrees[4] = Entities:FindAllByModel("MapTree")
	-- mightbetrees[5] = Entities:FindAllByName("CDOTA_MapTree")
	-- mightbetrees[6] = Entities:FindAllByName("MapTree")
	-- mightbetrees[7] = Entities:FindAllByTarget("CDOTA_MapTree")
	-- mightbetrees[8] = Entities:FindAllByTarget("MapTree")
	-- mightbetrees[9] = Entities:FindAllInSphere(Vector(-6082,1157,20), 1500)

	-- for i = 1,9 do
	-- print("mightbetrees: 9")
	-- DeepPrintTable(mightbetrees[9])
	-- for key,value in pairs(mightbetrees[9]) do 
	-- 	print("Name: " .. mightbetrees[9][key]:GetName())
 --    	print("Classname: " .. mightbetrees[9][key]:GetClassname())
	-- end
	--Use these to figure out which ones are trees
	--GetClassname
	--GetName  

	-- end

	
	

end

function CDotaRun:ResetRound()

	GameRules.dotaRun.lead = -1

	for i = 0,9 do
		GameRules.dotaRun.spawned[i] = false
	end

	GameRules.dotaRun.TaTrapFired = false

	for i = 0,9 do
		GameRules.dotaRun.zoneOpen[i] = true
	end

	for i = 0, 9 do
    	GameRules.dotaRun.waypoints[i] = {}

    	for j = 1, 3 do
    		GameRules.dotaRun.waypoints[i][j] = false -- Fill the values here
    	end
	end

	for i = 1, 3 do
		GameRules.dotaRun.waypointleader[i] = false
	end
end

-- function ApplyCooldownReduction( _, event )
-- 	print("Maybe this works")
-- 	DeepPrintTable(event)

--     local hero = PlayerResource:GetSelectedHeroEntity( event.PlayerID - 1 )
--     local ability = hero:FindAbilityByName( event.abilityname )

--     if ability:GetCooldownTimeRemaining() > 0 then
--         -- Change this to desired value
--         -- 0.4 means 40% cooldown reduction (15 -> 9 sec)
--         local reduction = 0.5

--         local cdDefault = ability:GetCooldown( ability:GetLevel() - 1 )
--         local cdReduced = cdDefault * ( 1.0 - reduction )   -- Modified cooldown time
--         local cdRemaining = ability:GetCooldownTimeRemaining()

--         if cdRemaining > cdReduced then
--             -- Apply the modified cooldown time
--             cdRemaining = cdRemaining - cdDefault * reduction
--             ability:EndCooldown()
--             ability:StartCooldown( cdRemaining )
--         end
--     end
-- end

-- function CDotaRun:RemoveCastedAbility(keys)
-- 	print("does this even work")
-- 	DeepPrintTable(keys)
-- 	local hero = keys.caster
-- 	print("hero: "  .. hero) 
-- end

function CDotaRun:ShowCenterMessage( msg, nDur )
	local msg = {
		message = msg,
		duration = nDur
	}
	print( "Sending message to all clients." )
	FireGameEvent("show_center_message", msg)
end

function CDotaRun:OnPlayerConnectFull(keys)
    -- if (HaveAllPlayersJoined()) then
    	
    -- end
    	
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

function CDotaRun:StartZoneTimer(hero)
	Timers:CreateTimer(5, function()
		GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] = true
        return
    end
    )
end

-- Need a better way to call this
-- function CDotaRun:XpThink()
-- 	hook()
-- 	return 1
-- end



function CDotaRun:OnNPCSpawned( keys )
    local spawnedUnit = EntIndexToHScript( keys.entindex )
    if(string.find(spawnedUnit:GetUnitName(), "hero")) then
		local playerID = spawnedUnit:GetPlayerID() 
	    if (not GameRules.dotaRun.spawned[playerID]) then
	    	GameRules.dotaRun.playerCount = GameRules.dotaRun.playerCount + 1
	        Timers:CreateTimer(0.6, function()
	        	local ability = spawnedUnit:FindAbilityByName("Immunity")
				ability:SetLevel(1)
				local player = PlayerResource:GetPlayer(playerID)
				local hero = player:GetAssignedHero() 
				hero:SetAbilityPoints(0)
				if (GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS) then
					hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
				end
				for i = 1, 6 do
					hero:AddAbility("empty_ability1")
				end
				GameRules.dotaRun:GiveForceStaff(hero)
				
				GameRules.dotaRun.spawned[playerID] = true
				-- AddFillerAbility(hero)
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
end

function CDotaRun:GiveForceStaff(hero)
	local hasForceStaff = false;

	for i=0,5 do 
	   	local item = hero:GetItemInSlot(i)
	   	if (item ~= nil) then
	    	if  item:GetClassname()  == "item_force_staff" then
		    	hasForceStaff = true
		    end
	    end
	end

	if (not hasForceStaff) then
		-- print("Player does not have forcestaff " ..  hero:GetPlayerID())
		local item = CreateItem("item_force_staff", hero, hero) 
		hero:AddItem(item)
	end
end



function CDotaRun:DoesHeroHaveMaxItems(hero)
	local itemSlotsFull = true
	for i=0,5 do 
		if(hero:GetItemInSlot(i) == nil) then
	    	itemSlotsFull = false
	    	break
	    end
	end
	return itemSlotsFull
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
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and  GameRules:State_Get() < DOTA_GAMERULES_STATE_POST_GAME then
		GameRules.dotaRun:FindTrees()
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
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function()
			GameRules.dotaRun:ShowCenterMessage("Welcome to Dota Run!\n Best of three laps", 5)
        	return
    	end
    	)

		Timers:CreateTimer(7, function()
			GameRules.dotaRun:ShowCenterMessage("Run over the squares to \n get items and spells", 5)
        	return
    	end
    	)
    	for i = 0,2 do
    		Timers:CreateTimer(12+i, function()
				GameRules.dotaRun:ShowCenterMessage((3-i).."", 1)
        		return
	    	end
	    	)
		end
		Timers:CreateTimer(15, function()
			GameRules.dotaRun:ShowCenterMessage("Go!", 1)
        	return
	    end
	    )
	end
end

-- Deletes item or ability after use
function CDotaRun:OnAbilityUsed(data)

	-- Testing grounds
	-- DeepPrintTable(data)



	print("Removing ability "..data.abilityname)
	-- playerID = data.PlayerID
	-- player = PlayerResource:GetPlayer(data.PlayerID-1) 
	local player = EntIndexToHScript(data.PlayerID)
	local hero = player:GetAssignedHero()
	
	local ability = hero:FindAbilityByName(data.abilityname)
	if(ability ~= nil) then
		-- Delete ability
		Timers:CreateTimer(4, function()
			ability:SetLevel(0)
        	hero:RemoveAbility(data.abilityname)
        	print("Removing ability: " .. data.abilityname)
        	hero:AddAbility("empty_ability1") 
            return
         end
         )
	else
		-- Else delete item
		Timers:CreateTimer(1, function() 
			for i=0,5,1 do 
	   			local item = hero:GetItemInSlot(i)
	    		if  item ~= nil and item:GetClassname()  ~= "item_force_staff" then
		    		if(item:GetClassname() == data.abilityname) then
		    			print("Deleting item: " .. item:GetClassname())
		    			hero:RemoveItem(item)
	    			end
	    		end
	   		end
	   		return
	   	end
	    )
	end
end

-- function AddFillerAbility(hero)
-- 	hero:AddAbility("empty_ability1")
-- 	hero:AddAbility("mirana_fart")
-- 	ability = hero:FindAbilityByName("mirana_fart")
-- 	ability:SetAbilityIndex(1) 
-- 	ability:SetLevel(1)
-- end