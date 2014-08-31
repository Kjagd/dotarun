

function WaypointOneTouch(trigger)
     
    playerID = trigger.activator:GetPlayerID() 
    print(playerID)
    GameRules.dotaRun.waypoints[playerID][1] = true
    print(GameRules.dotaRun.waypoints[playerID][1])
    print(GameRules.dotaRun.waypoints[playerID][2])
    print(GameRules.dotaRun.waypoints[playerID][3])

            
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
    print(playerID)      
    GameRules.dotaRun.waypoints[playerID][2] = true
    print(GameRules.dotaRun.waypoints[playerID][1])
    print(GameRules.dotaRun.waypoints[playerID][2])
    print(GameRules.dotaRun.waypoints[playerID][3])
     
          
            
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
    print(playerID)      
    GameRules.dotaRun.waypoints[playerID][3] = true
    print(GameRules.dotaRun.waypoints[playerID][1])
    print(GameRules.dotaRun.waypoints[playerID][2])
    print(GameRules.dotaRun.waypoints[playerID][3])
     
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

           


function WinHere(trigger)


    playerID = trigger.activator:GetPlayerID()
    player = PlayerResource:GetPlayer(playerID)
    hero = player:GetAssignedHero()  

    print("WinHere")
    print(playerID)
    print(GameRules.dotaRun.waypoints[playerID][1])
    print(GameRules.dotaRun.waypoints[playerID][2])
    print(GameRules.dotaRun.waypoints[playerID][3])
    print(GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2] and GameRules.dotaRun.waypoints[playerID][3])
    

    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2] and GameRules.dotaRun.waypoints[playerID][3]) then
        if (hero:GetTeamNumber() == 3) then
            GameRules:MakeTeamLose(2)
        elseif (hero:GetTeamNumber() == 2) then
            GameRules:MakeTeamLose(3)
        end
    end
end 

function KillEntity(trigger)

    unitName = trigger.activator:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    print("Unit '" .. unitName .. "' has entered the killbox")

    if (trigger.activator:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
    	trigger.activator:ForceKill(true) -- Kills the unit
        print("Is player owned - kill")

    else
        print("Is not owned by player - ignore")
        
    end

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

