

function WaypointOneTouch(trigger)
     
    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[1]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[1] = true
    end
    -- print(playerID)
    GameRules.dotaRun.waypoints[playerID][1] = true
    
    lastMan(1, trigger.activator)

    -- print(GameRules.dotaRun.waypoints[playerID][1])
    -- print(GameRules.dotaRun.waypoints[playerID][2])
    -- print(GameRules.dotaRun.waypoints[playerID][3])

            
            -- if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
            --     playerID = trigger.activator:GetPlayerID() 
            --     player = PlayerResource:GetPlayer(playerID)
            --     hero = player:GetAssignedHero() 
            --     GameRules:MakeTeamLose(3)

            --     --hero:AddExperience(5000, false)

            --     hero:AddItem(CreateItem("item_ancient_janggo" ,hero ,hero)) 
            --     print("Trying to create item")
                
            --     --hero:AddItem(item_blink) 
            --     --trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 

            -- else
            --     trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 
            --     print("Is not owned by player - Terminate")
                
            -- end  

           
end	

function WaypointTwoTouch(trigger)


    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[2]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[2] = true
    end
    -- print(playerID)
    if (GameRules.dotaRun.waypoints[playerID][1]) then
    	GameRules.dotaRun.waypoints[playerID][2] = true
    end

    lastMan(2, trigger.activator)

    
    -- print(GameRules.dotaRun.waypoints[playerID][1])
    -- print(GameRules.dotaRun.waypoints[playerID][2])
    -- print(GameRules.dotaRun.waypoints[playerID][3])
     
          
            
    --         if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
    --             playerID = trigger.activator:GetPlayerID() 
    --             player = PlayerResource:GetPlayer(playerID)
    --             hero = player:GetAssignedHero() 
    --             GameRules:MakeTeamLose(3)

    --             --hero:AddExperience(5000, false)

    --             hero:AddItem(CreateItem("item_ancient_janggo" ,hero ,hero)) 
    --             print("Trying to create item")
                
    --             --hero:AddItem(item_blink) 
    --             --trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 

    --         else
    --             trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 
    --             print("Is not owned by player - Terminate")
                
    --         end  

           
end 

function WaypointThreeTouch(trigger)

    playerID = trigger.activator:GetPlayerID() 
    -- print(playerID)      

    if (not GameRules.dotaRun.waypointleader[3]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[3] = true
    end
    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2]) then
    	GameRules.dotaRun.waypoints[playerID][3] = true
    end

    lastMan(3, trigger.activator)


    -- print(GameRules.dotaRun.waypoints[playerID][1])
    -- print(GameRules.dotaRun.waypoints[playerID][2])
    -- print(GameRules.dotaRun.waypoints[playerID][3])
     
end           
            
            -- if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
            --     playerID = trigger.activator:GetPlayerID() 
            --     player = PlayerResource:GetPlayer(playerID)
            --     hero = player:GetAssignedHero() 
            --     GameRules:MakeTeamLose(3)

            --     --hero:AddExperience(5000, false)

            --     hero:AddItem(CreateItem("item_ancient_janggo" ,hero ,hero)) 
            --     print("Trying to create item")
                
            --     --hero:AddItem(item_blink) 
            --     --trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 

            -- else
            --     trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 
            --     print("Is not owned by player - Terminate")
                
            -- end  

function lastMan(waypointID, hero)
    throughCount = 0
    for i = 0, 9 do
        if (GameRules.dotaRun.waypoints[i][waypointID]) then
            throughCount = throughCount + 1
        end
    end

    if (throughCount == GameRules.dotaRun.playerCount) then
        print("last man!")
        local abilityName = "gyrocopter_homing_missile_custom"
        if(hero:FindAbilityByName(abilityName) == nil) then
            print("Adding ability: "..abilityName)
            hero:RemoveAbility("empty_ability1") 
            hero:AddAbility(abilityName)
            ability = hero:FindAbilityByName(abilityName)
            ability:SetLevel(1)
        end
    end

    -- Fix me if you want less smoke
    if (throughCount >= GameRules.dotaRun.playerCount /2) then 
        local itemSlotsFull = GameRules.dotaRun:DoesHeroHaveMaxItems(hero)
        if (not itemSlotsFull) then
            local item = CreateItem("item_smoke_of_deceit", hero, hero) 
            hero:AddItem(item)
        end
    end
end

function WinHere(trigger)


    local playerID = trigger.activator:GetPlayerID()
    local player = PlayerResource:GetPlayer(playerID)
    local hero = player:GetAssignedHero()  

    -- print("WinHere")
    -- print(playerID)
    -- print(GameRules.dotaRun.waypoints[playerID][1])
    -- print(GameRules.dotaRun.waypoints[playerID][2])
    -- print(GameRules.dotaRun.waypoints[playerID][3])
    -- print(GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2] and GameRules.dotaRun.waypoints[playerID][3])
    

    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2] and GameRules.dotaRun.waypoints[playerID][3]) then
        if (hero:GetTeamNumber() == DOTA_TEAM_BADGUYS) then
            if (GameRules.dotaRun.badLaps == 1) then
                GameRules:SetSafeToLeave( true )
                GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
                setCameraToWin(hero)
            else 
                GameRules.dotaRun.badLaps = GameRules.dotaRun.badLaps + 1
                NewLap(DOTA_TEAM_BADGUYS)
            end

        elseif (hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS) then
            if (GameRules.dotaRun.goodLaps == 1) then
                GameRules:SetSafeToLeave( true )
                GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
                setCameraToWin(hero)
            else
                GameRules.dotaRun.goodLaps = GameRules.dotaRun.goodLaps + 1
                NewLap(DOTA_TEAM_GOODGUYS)
            end
        end       
    end
end

function setCameraToWin(hero)
    for i = 0, 9 do
        local player = PlayerResource:GetPlayer(i)
        if(player ~= nil) then
            PlayerResource:SetCameraTarget(i, hero)
        end
    end     
end 

-- Teleports a player to nearest waypoint or to spawn
function KillEntity(trigger)

    local unitName = trigger.activator:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"
    local playerID = trigger.activator:GetPlayerID()

    print("Unit '" .. unitName .. "' has entered the killbox")

    if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
        
        local point
        if (GameRules.dotaRun.waypoints[playerID][3] == true) then
            point = Entities:FindByName( nil, "waypointThreeTeleport" ):GetAbsOrigin()
        elseif (GameRules.dotaRun.waypoints[playerID][2] == true) then
            point = Entities:FindByName( nil, "waypointTwoTeleport" ):GetAbsOrigin()
        elseif (GameRules.dotaRun.waypoints[playerID][1] == true) then
            point = Entities:FindByName( nil, "waypointOneTeleport" ):GetAbsOrigin()
        else
            point = Entities:FindByName( nil, "waypointHomeTeleport" ):GetAbsOrigin()
        end

        teleportHero(trigger.activator, point, playerID)

        -- player = PlayerResource:GetPlayer(playerID)
        -- hero = player:GetAssignedHero() 
        local itemSlotsFull = GameRules.dotaRun:DoesHeroHaveMaxItems(hero)

        if (not itemSlotsFull) then
            local item = CreateItem("item_smoke_of_deceit", hero, hero) 
            trigger.activator:AddItem(item)
        end


    else
        print("Is not owned by player - ignore")
        
    end

end

function teleportHero(hero, point, playerID)
    -- Find a spot for the hero around 'point' and teleports to it
    FindClearSpaceForUnit(trigger.activator, point, false)
    -- Stop the hero, so he doesn't move
    trigger.activator:Stop()
    -- Refocus the camera of said player to the position of the teleported hero.
    PlayerResource:SetCameraTarget(playerID, trigger.activator)

end

function NewLap(winner)
    GameRules.dotaRun:ResetRound() 

    for i = 0,9 do
        local player = PlayerResource:GetPlayer(i)
        if (player ~=nil) then
            PlayerResource:ReplaceHeroWith(i, "npc_dota_hero_mirana", 0, 0)
            local hero = player:GetAssignedHero()
            if (winner == DOTA_TEAM_BADGUYS and hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and not GameRules.dotaRun.killHeroForWin) then
                hero:ForceKill(true)
                GameRules.dotaRun.killHeroForWin = true
            elseif (winner == DOTA_TEAM_GOODGUYS and hero:GetTeamNumber()  == DOTA_TEAM_BADGUYS and not GameRules.dotaRun.killHeroForWin) then
                hero:ForceKill(true)
                GameRules.dotaRun.killHeroForWin = true
            else     
                local point = Entities:FindByName( nil, "waypointHomeTeleport"):GetAbsOrigin()
                FindClearSpaceForUnit(hero, point, false)
                -- hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 

            -- local hero = player:GetAssignedHero()
            -- if (hero ~=nil) then
            --     for j = 1,9 do
            --         abilityName = GameRules.dotaRun.spellList[j]
            --         local ability = hero:FindAbilityByName(abilityName)
            --         if(ability ~= nil) then
            --             ability:SetLevel(0)
            --             print("Level of ability: " .. ability:GetLevel())
            --             hero:RemoveAbility(abilityName)
            --             -- if(hero:FindAbilityByName(data.abilityname) ~= nil) then
            --             --  hero:RemoveAbility("mirana_fart")
            --             -- end
            --             hero:AddAbility("empty_ability1") 
            --         end
            --     end

            --     for j=0,5 do 
            --         local item = hero:GetItemInSlot(j)
            --         if  (item ~= nil and item:GetClassname()  ~= "item_force_staff") then
            --             print("Deleting item: " .. item:GetClassname())
            --             hero:RemoveItem(item)
            --         end
            --     end
            --     -- if (winner == DOTA_TEAM_BADGUYS) then
            --     point = Entities:FindByName( nil, "waypointHomeTeleport" ):GetAbsOrigin()
            --     FindClearSpaceForUnit(hero, point, false)
            --     -- Stop the hero, so he doesn't move
            --     hero:Stop()
            --     -- Refocus the camera of said player to the position of the teleported hero.
            --     SendToConsole("dota_camera_center")
            --     hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
            -- end
            end
        end
    end

    GameRules.dotaRun.killHeroForWin = false

       

    GameRules.dotaRun:ShowCenterMessage("New lap starting in\n 5 seconds", 5)
    Timers:CreateTimer(5, function()
        GameRules.dotaRun:ShowCenterMessage("Go!", 5)
        for i = 0,9 do 
            local player = PlayerResource:GetPlayer(i)
            if (player ~=nil) then
                local hero = player:GetAssignedHero()
                if (hero ~=nil) then
                    hero:RemoveModifierByName("modifier_stunned")
                end
            end
        end
        return
    end
    )
end
           
        -- if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
        --        playerID = trigger.activator:GetPlayerID() 
        --        player = PlayerResource:GetPlayer(playerID)
        --        hero = player:GetAssignedHero() 
        --        GameRules:MakeTeamLose(3)

        --         --hero:AddExperience(5000, false)

        --        hero:AddItem(CreateItem("item_ancient_janggo" ,hero ,hero)) 
        --        print("Trying to create item")
                
        --         --hero:AddItem(item_blink) 
        --         --trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 

        -- else
        --     trigger.activator:SetGold(trigger.activator:GetGold() + 5000, true) 
        --     print("Is not owned by player - Terminate")
                
        -- end  

           








    -- function OnStartTouch(trigger)
 
 --        print(trigger.activator)
 --        print(trigger.caller)

 --        --unitName = trigger:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"


 --        --print("Unit '" .. unitName .. "' has entered the killbox")

 --        hero = trigger.activator:GetAssignedHero()
 --        hero:AddItem(item_blink) --[[Returns:void
 --        Add an item to this unit's inventory.
 --        ]]

 --        if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
 --            trigger.activator:ForceKill(true) -- Kills the unit
 --            print("Is player owned - Ignore")

 --        else
 --            print("Is not owned by player - Terminate")
 --            trigger.activator:ForceKill(true) -- Kills the unit
 --        end   
       
 --    end



    -- function Waypoint1(trigger)
     
    --         print(trigger.activator)
    --         print(trigger.caller)

           
    -- end
     
    -- function Waypoint2(trigger)
     
    -- --     print(trigger.activator)
    -- --     print(trigger.caller)

   	-- 	unitName = trigger:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    -- 	print("Unit '" .. unitName .. "' has entered the killbox")

    -- 	if (key:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
    -- 		key:ForceKill(true) -- Kills the unit
    --    		print("Is player owned - Ignore")

    -- 	else
    --     	print("Is not owned by player - Terminate")
    --     	key:ForceKill(true) -- Kills the unit
    -- 	end        
           
    -- end

