function WaypointOneTouch(trigger)
    if (GameRules.dotaRun.hasAlreadyReset) then
        GameRules.dotaRun.hasAlreadyReset = false
    end
     
    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[1]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[1] = true
    end
    GameRules.dotaRun.waypoints[playerID][1] = true
    
    lastMan(1, trigger.activator)

    print(GameRules.dotaRun.waypoints[playerID][1])
    print("id" .. playerID)          
end	

function WaypointTwoTouch(trigger)
    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[2]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[2] = true
    end
    if (GameRules.dotaRun.waypoints[playerID][1]) then
    	GameRules.dotaRun.waypoints[playerID][2] = true
    end

    lastMan(2, trigger.activator)
    
    print(GameRules.dotaRun.waypoints[playerID][1])
    print("id" .. playerID)
    print(GameRules.dotaRun.waypoints[playerID][2])
end 

function WaypointThreeTouch(trigger)

    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[3]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[3] = true
    end
    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2]) then
    	GameRules.dotaRun.waypoints[playerID][3] = true
    end

    lastMan(3, trigger.activator)

    print(GameRules.dotaRun.waypoints[playerID][1])
    print("id" .. playerID)
    print(GameRules.dotaRun.waypoints[playerID][2])
    print(GameRules.dotaRun.waypoints[playerID][3])
end    

function WaypointFourTouch(trigger)
     
    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[4]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[4] = true
    end
    -- print(playerID)
    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2]
        and GameRules.dotaRun.waypoints[playerID][3]) then
        GameRules.dotaRun.waypoints[playerID][4] = true
    end
    
    lastMan(4, trigger.activator)

    print(GameRules.dotaRun.waypoints[playerID][4])
    print("id" .. playerID)          
end 

function WaypointFiveTouch(trigger)
     
    playerID = trigger.activator:GetPlayerID() 

    if (not GameRules.dotaRun.waypointleader[5]) then
        GameRules.dotaRun.lead = playerID
        GameRules.dotaRun.waypointleader[5] = true
    end
    -- print(playerID)
    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2]
        and GameRules.dotaRun.waypoints[playerID][3] and GameRules.dotaRun.waypoints[playerID][4]) then
        GameRules.dotaRun.waypoints[playerID][5] = true
    end
    
    lastMan(1, trigger.activator)

    print(GameRules.dotaRun.waypoints[playerID][5])
    print("id" .. playerID)          
end        

function lastMan(waypointID, hero)
    local throughCount = 0
    for i = 0, 9 do
        if (GameRules.dotaRun.waypoints[i][waypointID]) then
            throughCount = throughCount + 1
        end
    end

    if (throughCount == GameRules.dotaRun.playerCount) then
        local hasMaxAbilities = true;
        for i = 1,6 do
            if(hero:GetAbilityByIndex(i):GetAbilityName() == "empty_ability1") then
                hasMaxAbilities = false
            end
        end        
        print("last man!")
        if (not hasMaxAbilities) then
            local abilityName = "gyrocopter_homing_missile_custom"
            if(hero:FindAbilityByName(abilityName) == nil) then
                print("Adding ability: "..abilityName)
                hero:RemoveAbility("empty_ability1") 
                hero:AddAbility(abilityName)
                ability = hero:FindAbilityByName(abilityName)
                ability:SetLevel(1)
            end
        end
    end
end

function WinHere(trigger)
    local playerID = trigger.activator:GetPlayerID()
    local player = PlayerResource:GetPlayer(playerID)
    local hero = player:GetAssignedHero()
    local teamNumber = PlayerResource:GetTeam(playerID)

    print("WinHere")
    print(playerID)
    print(GameRules.dotaRun.waypoints[playerID][1])
    print(GameRules.dotaRun.waypoints[playerID][2])
    print(GameRules.dotaRun.waypoints[playerID][3])
    print(GameRules.dotaRun.waypoints[playerID][4])
    print(GameRules.dotaRun.waypoints[playerID][5])
    print(GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2] 
        and GameRules.dotaRun.waypoints[playerID][3] and GameRules.dotaRun.waypoints[playerID][4] and GameRules.dotaRun.waypoints[playerID][5])

    if (GameRules.dotaRun.waypoints[playerID][1] and GameRules.dotaRun.waypoints[playerID][2] and GameRules.dotaRun.waypoints[playerID][3]
         and GameRules.dotaRun.waypoints[playerID][4] and GameRules.dotaRun.waypoints[playerID][5]) then
        DistributePoints(teamNumber)
        GameRules.dotaRun.numFinished = GameRules.dotaRun.numFinished + 1
        if (GameRules.dotaRun.numFinished == GameRules.dotaRun.playerCount) then
            StartReset()
            GameRules.dotaRun.hasAlreadyReset = true
        else
            local point = Entities:FindByName( nil, "waypointHomeTeleport"):GetAbsOrigin()
            teleportHero(hero, point, playerID)
            hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table)
        end 

        if (GameRules.dotaRun.numFinished == 1) then
            ShowCustomHeaderMessage( "#Finished", playerID, -1, 5 )
            Timers:CreateTimer(27, function()
                if (not GameRules.dotaRun.hasAlreadyReset) then
                    GameRules.dotaRun:ShowCenterMessage("3", 1)
                end
                
                return 
            end
            )
            Timers:CreateTimer(28, function()
                if (not GameRules.dotaRun.hasAlreadyReset) then
                    GameRules.dotaRun:ShowCenterMessage("2", 1)
                end
                
                return 
            end
            )
            Timers:CreateTimer(29, function()
                if (not GameRules.dotaRun.hasAlreadyReset) then
                    GameRules.dotaRun:ShowCenterMessage("1", 1)
                end
                -- Make if check as well to prevent countdown
                
                return 
            end
            )
            Timers:CreateTimer(30, function()
                if (not GameRules.dotaRun.hasAlreadyReset) then
                    StartReset()
                end
                return 
            end
            )
        end
    end
end

function StartReset()
    local messageSend = false
    local maxPoints = {}
    maxPoints[1] = {teamID = -1, points = 0}
    for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
        if (i ~= 5) then
            if (GameRules.dotaRun.points[i] >= maxPoints[1].points) then
                --print("i: " .. i)
                --print("points: " .. GameRules.dotaRun.points[i])
                maxPoints[1] = { teamID = i, points = GameRules.dotaRun.points[i] }
            end
        end
    end

    --print("max: " .. maxPoints[1].points)
    --print("pointstowin: " .. GameRules.dotaRun.pointsToWin)

    if (maxPoints[1].points >= GameRules.dotaRun.pointsToWin) then
        GameRules:SetSafeToLeave( true )
        GameRules:SetGameWinner(maxPoints[1].teamID)
        --setCameraToWin(PlayerResource:GetNthPlayerIDOnTeam(maxPoints[1].teamID, 1):GetAssignedHero()) --this line is fucked
        GameRules:SetCustomVictoryMessage( GameRules.dotaRun.m_VictoryMessages[maxPoints[1].teamID] ) 
    else
        --print("else")
        if (not messageSend and maxPoints[1].points >= GameRules.dotaRun.pointsToWin-10) then
            ShowCustomHeaderMessage( "#CloseToWin", PlayerResource:GetNthPlayerIDOnTeam(maxPoints[1].teamID, 1), -1, 5 )
            messageSend = true
        end

        EmitGlobalSound( "ui.npe_objective_complete" )
        NewLap()
    end
end

function DistributePoints(teamID)
    if GameRules.dotaRun.numFinished == 0 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 10
    elseif GameRules.dotaRun.numFinished == 1 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 7
    elseif GameRules.dotaRun.numFinished == 2 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 5
    elseif GameRules.dotaRun.numFinished == 3 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 4
    elseif GameRules.dotaRun.numFinished == 4 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 3
    elseif GameRules.dotaRun.numFinished == 5 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 2
    elseif GameRules.dotaRun.numFinished == 6 then
        GameRules.dotaRun.points[teamID] = GameRules.dotaRun.points[teamID] + 1
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

function teleportHero(hero, point, playerID)
    -- Find a spot for the hero around 'point' and teleports to it
    FindClearSpaceForUnit(hero, point, false)
    -- Stop the hero, so he doesn't move
    hero:Stop()
    -- Refocus the camera of said player to the position of the teleported hero.
    -- PlayerResource:SetCameraTarget(playerID, hero)
    SendToConsole("dota_camera_center")
end

function NewLap()
    GameRules.dotaRun:ResetRound() 

    for i = 0,9 do
        local player = PlayerResource:GetPlayer(i)
        if (player ~=nil) then
            PlayerResource:ReplaceHeroWith(i, "npc_dota_hero_mirana", 0, 0)
            local hero = player:GetAssignedHero()
            local point = Entities:FindByName( nil, "waypointHomeTeleport"):GetAbsOrigin()
            teleportHero(hero, point, i)
            --FindClearSpaceForUnit(hero, point, false)
            hero:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
            for i=0,5,1 do 
                local item = hero:GetItemInSlot(i)
                if  item ~= nil and item:GetClassname()  ~= "item_force_staff" then
                    hero:RemoveItem(item)
                end
            end
        end
    end





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
