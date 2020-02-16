-- Generated from template

require('lib.notifications')
require('timers')
require('utility_functions')
require('gamesettings')
require('pudge')
require('shakers')
require('centaurs')
require('magnus')
require('earth_spirit')
require('techies')
require('voting')
require("statcollection/init")

if CDotaRun == nil then
	CDotaRun = class({})
end

function Precache( context )
	print("Precache begin")

	local precache = LoadKeyValues("scripts/kv/precache.kv")

    for k, a in pairs(precache) do
        for _, v in pairs(a) do
            if k == "unit" then
                PrecacheUnitByNameSync(v, context)
            elseif k ~= "Async" then
                PrecacheResource(k, v, context)
            end
        end
    end

	print("Precache end")
end

-- Create the game mode when we activate
function Activate()
	print("init")
	GameRules.dotaRun = CDotaRun()
	GameRules.dotaRun:InitGameMode()
end

function CDotaRun:InitGameMode()
	-- Multiteam support

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS] = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self.m_GatheredShuffledTeams = {}
	self.m_PlayerTeamAssignments = {}
	self.m_NumAssignedPlayers = 0

	self:GatherAndRegisterValidTeams()

	GameRules:SetPreGameTime(GameSettings.voteTime)
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetHeroSelectionTime(15)
	GameRules:SetCustomVictoryMessageDuration( 0 )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetSameHeroSelectionEnabled( false )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetStrategyTime( 0 )
	GameRules:SetShowcaseTime( 0 )


	self.TaTrapFired = false
	self.itemList = { 
		"item_blink",
		"item_cyclone",
		"item_sheepstick",
		"item_ancient_janggo",
		"item_rod_of_atos",
		"item_black_king_bar",
		"item_phase_boots",
		"item_ethereal_blade",
		"item_manta"
	}

	self.spellList = {
		"mirana_arrow_custom",
		"venomancer_venomous_gale_custom",
		"dark_seer_surge_custom",
		"jakiro_ice_path_custom", 
		"batrider_flamebreak_custom",
		"pudge_meat_hook_custom", 
		"meepo_earthbind_custom",
		"tiny_toss_custom",
		"windrunner_shackleshot_custom",
		"furion_sprout_custom",
		"kunkka_torrent_custom",
		"abyssal_underlord_pit_of_malice_custom"
	}

	local checkpoint_names = {
		"waypoint1",
		"waypoint2",
		"waypoint3",
		"waypoint4",
		"waypoint5",
		"waypoint6",
		"win"
	}

	self.checkpoints = {}
	for key,name in pairs(checkpoint_names) do
		self.checkpoints[key] = Entities:FindByName(nil, name)
	end
	
	self.waypointDistances = {}
	for i=1,#self.checkpoints-1 do
		local dist = (self.checkpoints[i]:GetAbsOrigin() - self.checkpoints[i+1]:GetAbsOrigin()):Length2D()
		self.waypointDistances[i] = dist
	end

	self.points = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.points[i] = 0
	end

	self.pointsToWin = 25 -- Fallback to 25 if not set

	self.alreadyScored = {}

	self.playerDistances = {}

	self.playerCount = 0

	self.zoneOpen = {}
	
	self.waypoints = {}
	
	self.spawned = {}
	
	self.waypointleader = {}

	self.lead = -1

	self.numFinished = 0

	self.hasAlreadyReset = false

	self.leadingPlayerID = -1

	initPudges()
	-- --initShakers() Moved to start of game to prevent hearing loss
	initCents()
	initMagnus()
	initTechie()

	CDotaRun:ResetRound()

	ListenToGameEvent('dota_item_used', Dynamic_Wrap(CDotaRun, 'OnItemUsed'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CDotaRun, 'OnNPCSpawned'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CDotaRun, 'On_game_rules_state_change'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CDotaRun, 'OnAbilityUsed'), self) 
	ListenToGameEvent("player_team", Dynamic_Wrap(CDotaRun, 'On_player_team'), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(CDotaRun, 'OnPlayerSpawn'), self)

	CustomGameEventManager:RegisterListener( "vote_cast", VoteCast)


	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )

	print( "Dotarun has literally loaded." )
end

---------------------------------------------------------------------------
-- Handle disconnects and reconnects. Playercounting does not work on dedicated server
---------------------------------------------------------------------------
function CDotaRun:On_player_team(data)
	if (data.disconnect == 1) then -- player has disconnected
		--self.playerCount = self.playerCount - 1
		print("disconnect")
	elseif (data.disconnect == 0 and data.oldteam == 0 and GameRules:State_Get() < DOTA_GAMERULES_STATE_HERO_SELECTION) then -- player has connected
		--self.playerCount = self.playerCount + 1
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(data.team, 1)
		local spawn = Entities:FindByName( nil, "waypointHomeTeleport")
		--PlayerResource:SetCameraTarget(playerID, spawn) -- sets camera to spawn and locks it
		--FireGameEvent("console_command", {pid=-2, command="dota_camera_lock 0"}) -- unlocks camera
		--Can't unlock camera, need ActionScript https://github.com/AeroHand/Speed-Racing/tree/0a293da7817d01ab860cdffc4187e96970fd1be8/resource/flash3
		print("connect")
	elseif (data.disconnect == 0 and data.oldteam == 0) then -- player has reconnected
		--self.playerCount = self.playerCount + 1

		Timers:CreateTimer(1, function()
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(data.team, 1)
			GameRules.dotaRun.spawned[playerID] = false
			local player = PlayerResource:GetPlayer(playerID)
	        PlayerResource:ReplaceHeroWith(playerID, player:GetAssignedHero():GetUnitName(), 0, 0)
	        local hero = player:GetAssignedHero()
	        local point = Entities:FindByName( nil, "waypointHomeTeleport"):GetAbsOrigin()
	        teleportHero(hero, point, playerID)
	        return
	    end
	    )
		print("reconnect")
	end
	print("playercount is: " .. self.playerCount)
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function CDotaRun:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function CDotaRun:OnThink()

	self:CalculateDistances()
	playerPositions = self:SortPositions()
	self:BlueShell(playerPositions)
	self:CountConnectedPlayers()

	return 1
end

---------------------------------------------------------------------------
-- Count connected players. State 0 - no connection, state 1 - bot, state 2 - player connected, state 3 - bot/player disconnected.
---------------------------------------------------------------------------
function CDotaRun:CountConnectedPlayers()
    local connectedPlayers = 0
    for playerID = 0,DOTA_MAX_TEAM_PLAYERS do
    	--print("connectionState: " .. PlayerResource:GetConnectionState(playerID) .. "for id: " .. playerID)
    	if (PlayerResource:GetConnectionState(playerID) == 2) then
    		connectedPlayers = connectedPlayers + 1
    	--	print("id " .. playerID .. "is connected")
    	end  
    end
   -- print("connectedPlayers: " .. connectedPlayers)
    self.playerCount = connectedPlayers
end

---------------------------------------------------------------------------
-- Calculate the distances for each player
---------------------------------------------------------------------------
function CDotaRun:CalculateDistances()
	for i = 0,(DOTA_MAX_TEAM_PLAYERS-1) do
		local player = PlayerResource:GetPlayer(i)
		if (player ~= nil and player:GetAssignedHero() ~= nil) then
			local dist = 0
			for w = #self.checkpoints-1,0,-1 do
				if (w > 0 and not self.waypoints[i][w]) then
					dist = dist + self.waypointDistances[w]
				else
					local distvec = self.checkpoints[w+1]:GetAbsOrigin() - player:GetAssignedHero():GetOrigin()
					dist = dist + distvec:Length2D()
					break
				end
			end
			self.playerDistances[i+1] = dist
		end
	end
end

---------------------------------------------------------------------------
-- Modify basespeed based on position
---------------------------------------------------------------------------
function CDotaRun:BlueShell(playerPositions)
	local speed = 360
	for key, t in pairs( playerPositions ) do
		playerID = PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1)
		if (playerID ~= nil) then	
			if(playerID ~= -1) then
				local player = PlayerResource:GetPlayer(playerID)
				if (player ~= nil) then
					local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
					if (hero ~= nil) then
						hero:SetBaseMoveSpeed(speed)
						speed = speed + 20
						if key == 1 then
							self.leadingPlayerID = playerID
						end
					end
				end
			end
		end
	end
end

---------------------------------------------------------------------------
-- Create and sort relevant player data
---------------------------------------------------------------------------
function CDotaRun:SortPositions() 
	-- Note that playerPositions is recalculated everytime and is local
	local playerPositions = {}
	for key,value in pairs( GameRules.dotaRun.playerDistances ) do
		-- Key is 1 indexed, so we subtract one to key playerID
		local teamID = PlayerResource:GetTeam( key-1 )
		local tempValue
		if value == 0 then
			tempValue = 99999
		else 
			tempValue = value
		end
		-- Position is not shown atm but this is how it can be gotten
		table.insert( playerPositions, { teamID = teamID, position = tempValue, pName = PlayerResource:GetPlayerName(PlayerResource:GetNthPlayerIDOnTeam(teamID, 1)) } )
	end

	-- reverse-sort by distance
	table.sort(  playerPositions, function(a,b) return ( a.position < b.position ) end )
	return playerPositions
end

---------------------------------------------------------------------------
-- Helper functions
---------------------------------------------------------------------------
function ShuffledList( list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

function TableCount( t )
	local n = 0
	for _ in pairs( t ) do
		n = n + 1
	end
	return n
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function CDotaRun:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 1
		-- if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
		-- 	maxPlayers = maxPlayersPerValidTeam
		-- end
		if team == 4 then
			GameRules:SetCustomGameTeamMaxPlayers( team, 0 )
			print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(0) )
		elseif team == 5 then
			GameRules:SetCustomGameTeamMaxPlayers( team, 0 )
			print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(0) )
		else 
			GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
			print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		end
	end
end

---------------------------------------------------------------------------
-- Resets relevant variables for a new round
---------------------------------------------------------------------------
function CDotaRun:ResetRound()
	GameRules.dotaRun.lead = -1
	GameRules.dotaRun.TaTrapFired = false
	GameRules.dotaRun.numFinished = 0

	for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do 
    	GameRules.dotaRun.waypoints[i] = {}
    	GameRules.dotaRun.spawned[i] = false
		GameRules.dotaRun.zoneOpen[i] = true
		GameRules.dotaRun.alreadyScored[i] = false

    	for j = 1, 6 do
    		GameRules.dotaRun.waypoints[i][j] = false -- Fill the values here
    	end
	end

	-- Needs to be 1 indexed for some lua functions
	for i = 1, DOTA_MAX_TEAM_PLAYERS do
		GameRules.dotaRun.playerDistances[i] = 0
	end

	for i = 1, 6 do
		GameRules.dotaRun.waypointleader[i] = false
	end
	repositionShakers()
	setUpMines()
end

function CDotaRun:ShowCenterMessage( msg, nDur )
	local msg = {
		message = msg,
		duration = nDur
	}
	FireGameEvent("show_center_message", msg)
end

function CDotaRun:StartZoneTimer(hero)
	Timers:CreateTimer(5, function()
		GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] = true
        return
    end
    )
end

---------------------------------------------------------------------------
-- Give Miranas spells and empty abilities
---------------------------------------------------------------------------
function CDotaRun:OnNPCSpawned( keys )
    local spawnedUnit = EntIndexToHScript( keys.entindex )
    if(string.find(spawnedUnit:GetUnitName(), "hero")) then
		local playerID = spawnedUnit:GetPlayerID() 
	    if (not GameRules.dotaRun.spawned[playerID]) then
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
					--hero:AddAbility("empty_ability1")
				end
				GameRules.dotaRun:GiveForceStaff(hero)
				
				GameRules.dotaRun.spawned[playerID] = true
	            return
	        end
	        )
	    end
   	end

   	-- check if banana and make model bigger
   	if(string.find(spawnedUnit:GetUnitName(), "banana")) then
   		print("found banana")
   		spawnedUnit:SetModelScale(2.0)
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

function CDotaRun:On_game_rules_state_change( data )
	print("game starting!")

	-- For multiteam
	local nNewState = GameRules:State_Get()

	--Perhaps use this popup instead to instruct on rules
	-- if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	-- 	ShowGenericPopup( "#multiteam_instructions_title", "#multiteam_instructions_body", tostring(self.TEAM_KILLS_TO_WIN), "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
	-- end

	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	end

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		initShakers()
		initEarthSpirit()	

		-- GameRules:GetGameModeEntity():SetThink( "EnsurePlayersOnCorrectTeam", self, 0 )
		-- GameRules:GetGameModeEntity():SetThink( "BroadcastPlayerTeamAssignments", self, 1 )
	end

	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and  GameRules:State_Get() < DOTA_GAMERULES_STATE_POST_GAME then
		for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
			player = PlayerResource:GetPlayer(i)
			if (player ~=nil) then
				hero = player:GetAssignedHero()
				if (hero ~=nil) then
					hero:RemoveModifierByName("modifier_stunned")
				end
			end
		end
		CustomGameEventManager:Send_ServerToAllClients( "remove_voting", nil )

		Timers:CreateTimer(20, function() --Late comers backup unit
			print("Latecomers ui remove")
			CustomGameEventManager:Send_ServerToAllClients( "remove_voting", nil )
        	return
    	end
    	)
	end
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then

		StartVoteTimer()

		Timers:CreateTimer(GameSettings.voteTime-4, function()
			CustomGameEventManager:Send_ServerToAllClients( "start_countdown", nil )
        	return
    	end
    	)
	end
end

---------------------------------------------------------------------------
-- Deletes item or ability after use
---------------------------------------------------------------------------
function CDotaRun:OnAbilityUsed(data)
	DeepPrintTable(data)
	--local player = EntIndexToHScript(data.PlayerID)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	PrintTable(player)
	local hero = player:GetAssignedHero()
	local ability = hero:FindAbilityByName(data.abilityname)
	if(ability ~= nil) then
		-- Delete ability
		Timers:CreateTimer(4, function()
			ability:SetLevel(0)
        	hero:RemoveAbility(data.abilityname)
        	print("Removing: " .. data.abilityname)
        	hero:AddAbility("empty_ability1") 
        	print("Adding empty ability")
            return
         end
         )
	else
		-- Else delete item
		Timers:CreateTimer(1, function() 
			for i=0,5,1 do 
	   			local item = hero:GetItemInSlot(i)
	    		if  item ~= nil and item:GetClassname()  ~= "item_force_staff" and item:GetClassname() ~= "item_banana" then
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

function CDotaRun:OnPlayerSpawn(data)
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and data.player ~= nil) then 
		print("spawn vote ui remove")
		CustomGameEventManager:Send_ServerToAllClients( "remove_voting", nil )
	end
end

-- Hvis vi vil have at der kommer et lille 1 tal når folk går i mål
-- function CDotaRun:OnGoalEnteredEvent(id, teamid, teampoints)
-- --  print( "OnKillCredit" )
-- --  DeepPrint( event )

--     local playerID = id
--     local nTeamID = teamid
--     local nTeamKills = teampoints
--     local nKillsRemaining = self.pointsToWin - nTeamKills
    
--     local broadcast_kill_event =
--     {
--         killer_id = playerID,
--         team_id = nTeamID,
--         team_kills = nTeamKills,
--         kills_remaining = nKillsRemaining,
--         victory = 0,
--         close_to_victory = 0,
--         very_close_to_victory = 0,
--     }

--     CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
-- end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end
	done = done or {}
	done[t] = true
	indent = indent or 0
	local l = {}
	for k, v in pairs(t) do
	table.insert(l, k)
	end
	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
			local value = t[v]
			if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..":")
				PrintTable (value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
				else
					print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				end
			end
		end
	end
end

--Use this in waypoint too
function teleportHero(hero, point, playerID)
    -- Find a spot for the hero around 'point' and teleports to it
    FindClearSpaceForUnit(hero, point, false)
    -- Stop the hero, so he doesn't move
    hero:Stop()
    -- Refocus the camera of said player to the position of the teleported hero.
    -- PlayerResource:SetCameraTarget(playerID, hero)
    SendToConsole("dota_camera_center")
end
