-- Generated from template

require('lib.statcollection')
require('timers')
require('pudge')
require('shakers')
require('centaurs')
--require('magnus')
if CDotaRun == nil then
	CDotaRun = class({})
end

statcollection.addStats({
    modID = 'XXXXXXXXXXXXXXXXXXX' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
  })

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
	PrecacheUnitByNameSync("npc_dota_hero_earthshaker", context)
	PrecacheUnitByNameSync("npc_dota_hero_templar_assassin", context)
	PrecacheUnitByNameSync("npc_dota_hero_magnataur", context)

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
	-- Multiteam support

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 255, 0, 0 }
	self.m_TeamColors[DOTA_TEAM_BADGUYS] = { 0, 255, 0 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 0, 0, 255 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 128, 64 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 255, 255, 0 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 128, 255, 0 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 128, 0, 255 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 255, 0, 128 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 0, 255, 255 }
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 255, 255, 255 }

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

	self:GatherValidTeams()

	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 0 )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )



	self.TaTrapFired = false
	self.itemList = { "item_blink", "item_cyclone", "item_shivas_guard", "item_sheepstick", "item_ancient_janggo", "item_rod_of_atos"}
	self.spellList = {"mirana_arrow_custom", "mirana_leap_custom", "venomancer_venomous_gale_custom", "dark_seer_surge_custom", "jakiro_ice_path_custom", 
	"batrider_flamebreak_custom", "ancient_apparition_ice_vortex_custom", "obsidian_destroyer_astral_imprisonment_custom", "pudge_meat_hook_custom"}

	self.points = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.points[i] = 0

	end

	self.pointsToWin = 30

	self.distanceFromOneToTwo = 12406
	self.distanceFromTwoToThree = 12452
	self.distanceFromThreeToFour = 9000
	self.distanceFromFourToFive = 9500
	self.distanceFromFiveToGoal = 7300

	self.playerDistances = {}


	-- DebugDrawText(Vector(-5464,-6529,20), "Get items and abilities by running through these", false, -1) 

	self.playerCount = 0

	self.zoneOpen = {}
	
	self.waypoints = {}
	
	self.spawned = {}
	
	self.waypointleader = {}

	self.lead = -1

	

	initPudges()
	initShakers()
	initCents()
	--initMagnus()

	CDotaRun:ResetRound()


	ListenToGameEvent('dota_item_used', Dynamic_Wrap(CDotaRun, 'OnItemUsed'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CDotaRun, 'OnNPCSpawned'), self)
	-- ListenToGameEvent("game_start", Dynamic_Wrap(CDotaRun, 'On_game_start'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CDotaRun, 'On_game_rules_state_change'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CDotaRun, 'OnAbilityUsed'), self) 
	-- ListenToGameEvent('player_connect_full', Dynamic_Wrap(CDotaRun, 'OnPlayerConnectFull'), self)
	-- ListenToGameEvent('dota_player_used_ability', ApplyCooldownReduction, {} )


	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )

	print( "Dotarun has literally loaded." )

	
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
-- Determine a good team assignment for the next player
---------------------------------------------------------------------------
function CDotaRun:GetTeamReassignmentForPlayer( playerID )
	if #self.m_GatheredShuffledTeams == 0 then
		return nil
	end

	if nil == PlayerResource:GetPlayer( playerID ) then
		return nil -- no player yet
	end
	
	-- see if we've already assigned the player	
	local existingAssignment = self.m_PlayerTeamAssignments[ playerID ]
	if existingAssignment ~= nil then
		if existingAssignment == PlayerResource:GetTeam( playerID ) then
			return nil -- already assigned to this team and they're still on it
		else
			return existingAssignment -- something else pushed them out of the desired team - set it back
		end
	end

	-- haven't assigned this player to a team yet
	-- print( "m_NumAssignedPlayers = " .. self.m_NumAssignedPlayers )
	
	-- If the number of players per team doesn't divide evenly (ie. 10 players on 4 teams => 2.5 players per team)
	-- Then this floor will round that down to 2 players per team
	-- If you want to limit the number of players per team, you could just set this to eg. 1
	local playersPerTeam = math.floor( DOTA_MAX_TEAM_PLAYERS / #self.m_GatheredShuffledTeams )
	-- print( "playersPerTeam = " .. playersPerTeam )

	local teamIndexForPlayer = math.floor( self.m_NumAssignedPlayers / playersPerTeam )
	-- print( "teamIndexForPlayer = " .. teamIndexForPlayer )

	-- Then once we get to the 9th player from the case above, we need to wrap around and start assigning to the first team
	if teamIndexForPlayer >= #self.m_GatheredShuffledTeams then
		teamIndexForPlayer = teamIndexForPlayer - #self.m_GatheredShuffledTeams
		-- print( "teamIndexForPlayer => " .. teamIndexForPlayer )
	end
	
	teamAssignment = self.m_GatheredShuffledTeams[ 1 + teamIndexForPlayer ]
	-- print( "teamAssignment = " .. teamAssignment )

	self.m_PlayerTeamAssignments[ playerID ] = teamAssignment

	self.m_NumAssignedPlayers = self.m_NumAssignedPlayers + 1

	return teamAssignment
end

---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function CDotaRun:MakeLabelForPlayer( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	hero:SetCustomHealthLabel( PlayerResource:GetPlayerName(nPlayerID), color[1], color[2], color[3] )
end

---------------------------------------------------------------------------
-- Tell everyone the team assignments during hero selection
---------------------------------------------------------------------------
function CDotaRun:BroadcastPlayerTeamAssignments()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		local nTeamID = PlayerResource:GetTeam( nPlayerID )
		if nTeamID ~= DOTA_TEAM_NOTEAM then
			GameRules:SendCustomMessage( "#TeamAssignmentMessage", nPlayerID, -1 )
		end
	end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function CDotaRun:OnThink()

	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:MakeLabelForPlayer( nPlayerID )
	end

	
	playerPositions = self:SortPositions()
	self:CalculatePositions()
	self:UpdateScoreboard(playerPositions)
	self:BlueShell(playerPositions)
		
	return 1
end

function CDotaRun:CalculatePositions()

	-- Waypoints are indexed from zero because it matches playerID but playerDistance is indexed from 1 because we use lua list functions on it
	for i = 0,(DOTA_MAX_TEAM_PLAYERS-1) do
		local player = PlayerResource:GetPlayer(i)
		if (player ~= nil and player:GetAssignedHero() ~= nil) then

			if (GameRules.dotaRun.waypoints[i][5]) then
				GameRules.dotaRun.playerDistances[i+1] = (Entities:FindByName( nil, "win" ):GetOrigin() - player:GetAssignedHero():GetOrigin()):Length2D() 
			elseif (GameRules.dotaRun.waypoints[i][4]) then
				GameRules.dotaRun.playerDistances[i+1] = (Entities:FindByName( nil, "waypoint5" ):GetOrigin() - player:GetAssignedHero():GetOrigin()):Length2D() 
					+ self.distanceFromFiveToGoal
			elseif (GameRules.dotaRun.waypoints[i][3]) then
				GameRules.dotaRun.playerDistances[i+1] = (Entities:FindByName( nil, "waypoint3" ):GetOrigin() - player:GetAssignedHero():GetOrigin()):Length2D() 
					+ self.distanceFromFiveToGoal + self.distanceFromFourToFive
			elseif (GameRules.dotaRun.waypoints[i][2]) then
				GameRules.dotaRun.playerDistances[i+1] = (Entities:FindByName( nil, "waypoint3" ):GetOrigin() - player:GetAssignedHero():GetOrigin()):Length2D() 
					+ self.distanceFromFiveToGoal + self.distanceFromFourToFive + self.distanceFromThreeToFour
			elseif (GameRules.dotaRun.waypoints[i][1]) then
				GameRules.dotaRun.playerDistances[i+1] = (Entities:FindByName( nil, "waypoint2" ):GetOrigin() - player:GetAssignedHero():GetOrigin()):Length2D() 
					+ self.distanceFromFiveToGoal + self.distanceFromFourToFive + self.distanceFromThreeToFour + self.distanceFromTwoToThree
			else 
				local distance = (Entities:FindByName( nil, "waypoint1" ):GetOrigin() 
					- player:GetAssignedHero():GetOrigin()):Length2D()
				GameRules.dotaRun.playerDistances[i+1] = distance
					+ self.distanceFromFiveToGoal + self.distanceFromFourToFive + self.distanceFromThreeToFour + self.distanceFromTwoToThree + self.distanceFromOneToTwo
				-- print("Vector length: ", distance)
				-- print("3-goal: " .. self.distanceFromThreeToGoal)
				-- print("2-3: " .. self.distanceFromTwoToThree)
				-- print("1-2: " .. self.distanceFromOneToTwo)
			end 

			-- distance = (Entities:FindByName( nil, "waypointHomeTeleport" ):GetOrigin() - player:GetAssignedHero():GetOrigin()):Length2D() 
			-- print("Player: " .. i .. " distance ", distance)
		end
	end

	-- for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
	-- 	GameRules.dotaRun.playerPositions = GameRules.dotaRun.playerDistances[i]
	-- end


	-- Player positions not needed atm as Distance is also 1 indexed now

	-- DeepPrintTable(GameRules.dotaRun.playerDistances)
	-- for key, value in pairs( GameRules.dotaRun.playerDistances ) do
	-- 	table.insert( GameRules.dotaRun.playerPositions, GameRules.dotaRun.playerDistances[key] )
	-- end



	-- for i = 1,DOTA_MAX_TEAM_PLAYERS do
	-- 	GameRules.dotaRun.playerPositions[i] = GameRules.dotaRun.playerDistances[i]
	-- end



end

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
						speed = speed + 10
					end
				end
				--Note that this actually works, but the movement display is not altered :D
			end
		end
	end
end

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
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function CDotaRun:UpdateScoreboard(playerPositions)
	
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = self.points[team] } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	UTIL_ResetMessageTextAll()
	UTIL_MessageTextAll( "#ScoreboardTitle", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )
		if(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1) ~= -1) then
			name = PlayerResource:GetPlayerName(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1))
			UTIL_MessageTextAll(t.teamScore.."\t"..name, clr[1], clr[2], clr[3], 255)
		end
	end


	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardPositionHeader", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	for key, t in pairs( playerPositions ) do
		local clr = self:ColorForTeam( t.teamID )
		if t.teamID == 5 then
			
		elseif key == 1 then
			UTIL_MessageTextAll(key.."st\t"..t.pName, clr[1], clr[2], clr[3], 255)
		elseif key == 2 then
			UTIL_MessageTextAll(key.."nd\t"..t.pName, clr[1], clr[2], clr[3], 255)
		elseif key == 3 then
			UTIL_MessageTextAll(key.."rd\t"..t.pName, clr[1], clr[2], clr[3], 255)
		else 
			UTIL_MessageTextAll(key.."th\t"..t.pName, clr[1], clr[2], clr[3], 255)
		end
	end
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
function CDotaRun:GatherValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

--	print( "GatherValidTeams - Found spawns for a total of " .. TableCount(foundTeams) .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	-- print( "Final shuffled team list:" )
	-- for _, team in pairs( self.m_GatheredShuffledTeams ) do
	-- 	print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	-- end
end

---------------------------------------------------------------------------
-- Assign all real players to a team
---------------------------------------------------------------------------
function CDotaRun:EnsurePlayersOnCorrectTeam()
--	print( "Assigning players to teams..." )
	for playerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		local teamReassignment = self:GetTeamReassignmentForPlayer( playerID )
		if nil ~= teamReassignment then
			print( " - Player " .. playerID .. " reassigned to team " .. teamReassignment )
			PlayerResource:SetCustomTeamAssignment( playerID, teamReassignment )
		end
	end
	
	return 1 -- Check again later in case more players spawn
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

	GameRules.dotaRun.TaTrapFired = false

	GameRules.dotaRun.playerCount = 0


	for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do 
    	GameRules.dotaRun.waypoints[i] = {}
    	GameRules.dotaRun.spawned[i] = false
		GameRules.dotaRun.zoneOpen[i] = true


    	for j = 1, 5 do
    		GameRules.dotaRun.waypoints[i][j] = false -- Fill the values here
    	end

	end

	for i = 1, DOTA_MAX_TEAM_PLAYERS do
		GameRules.dotaRun.playerDistances[i] = 0
	end

	for i = 1, 5 do
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
-- function CDotaRun:OnThink()
-- 	-- print("Thinking")

-- 	-- if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			
-- 	-- end

-- 	-- if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
-- 	-- 	for i = 0,9 do
-- 	-- 		player = PlayerResource:GetPlayer(i)
-- 	-- 		hero = player:GetAssignedHero()
-- 	-- 		hero:RemoveModifierByName(modifier_stunned) 
-- 	-- 	end
-- 	-- end
-- 	return 1
-- end

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

	-- For multiteam
	local nNewState = GameRules:State_Get()
	-- print( "OnGameRulesStateChange: " .. nNewState )


	--Perhaps use this popup instead to instruct on rules
	-- if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	-- 	ShowGenericPopup( "#multiteam_instructions_title", "#multiteam_instructions_body", tostring(self.TEAM_KILLS_TO_WIN), "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
	-- end

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameRules:GetGameModeEntity():SetThink( "EnsurePlayersOnCorrectTeam", self, 0 )
		GameRules:GetGameModeEntity():SetThink( "BroadcastPlayerTeamAssignments", self, 1 )
	end

	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and  GameRules:State_Get() < DOTA_GAMERULES_STATE_POST_GAME then
		GameRules.dotaRun:FindTrees()
		for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
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
			GameRules.dotaRun:ShowCenterMessage("Welcome to Dota Run!\n First to 30 points", 5)
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