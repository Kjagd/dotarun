-- Generated from template

require('lib.statcollection')
require('timers')
require('pudge')
require('shakers')
require('centaurs')
require( "utility_functions" )
--require('magnus')
if CDotaRun == nil then
	CDotaRun = class({})
end

-- statcollection.addStats({
--     modID = '19b0e2fdf5da5817c03127bb598102bd' --GET THIS FROM http://getdotastats.com/#d2mods__my_mods
--   })

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

	PrecacheResource( "particle", "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_ring_inner_start.vpcf", context )
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
	self.TEAM_KILLS_TO_WIN = 30

	self.distanceFromOneToTwo = 12406
	self.distanceFromTwoToThree = 12452
	self.distanceFromThreeToFour = 9000
	self.distanceFromFourToFive = 9500
	self.distanceFromFiveToGoal = 7300

	self.playerDistances = {}

	self.playerCount = 0

	self.zoneOpen = {}
	
	self.waypoints = {}
	
	self.spawned = {}
	
	self.waypointleader = {}

	self.lead = -1

	self.numFinished = 0

	self.hasAlreadyReset = false

	initPudges()
	--initShakers() Moved to start of game to prevent hearing loss
	initCents()
	--initMagnus()

	CDotaRun:ResetRound()

	ListenToGameEvent('dota_item_used', Dynamic_Wrap(CDotaRun, 'OnItemUsed'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(CDotaRun, 'OnNPCSpawned'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CDotaRun, 'On_game_rules_state_change'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CDotaRun, 'OnAbilityUsed'), self) 
	ListenToGameEvent("player_team", Dynamic_Wrap(CDotaRun, 'On_player_team'), self)



	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )

	print( "Dotarun has literally loaded." )
end

function CDotaRun:On_player_team(data)
	if (data.disconnect == 1) then -- player has disconnected
		self.playerCount = self.playerCount - 1
		print("disconnect")
	elseif (data.disconnect == 0 and data.oldteam == 0 and GameRules:State_Get() < DOTA_GAMERULES_STATE_HERO_SELECTION) then -- player has connected
		self.playerCount = self.playerCount + 1
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(data.team, 1)
		local spawn = Entities:FindByName( nil, "waypointHomeTeleport")
		--PlayerResource:SetCameraTarget(playerID, spawn) -- sets camera to spawn and locks it
		--FireGameEvent("console_command", {pid=-2, command="dota_camera_lock 0"}) -- unlocks camera
		--Can't unlock camera, need ActionScript https://github.com/AeroHand/Speed-Racing/tree/0a293da7817d01ab860cdffc4187e96970fd1be8/resource/flash3
		print("connect")
	elseif (data.disconnect == 0 and data.oldteam == 0) then -- player has reconnected
		self.playerCount = self.playerCount + 1

		Timers:CreateTimer(1, function()
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(data.team, 1)
			GameRules.dotaRun.spawned[playerID] = false
			local player = PlayerResource:GetPlayer(playerID)
	        PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_mirana", 0, 0)
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
-- Determine a good team assignment for the next player
---------------------------------------------------------------------------
-- function CDotaRun:GetTeamReassignmentForPlayer( playerID )
-- 	if #self.m_GatheredShuffledTeams == 0 then
-- 		return nil
-- 	end

-- 	if nil == PlayerResource:GetPlayer( playerID ) then
-- 		return nil -- no player yet
-- 	end
	
-- 	-- see if we've already assigned the player	
-- 	local existingAssignment = self.m_PlayerTeamAssignments[ playerID ]
-- 	if existingAssignment ~= nil then
-- 		if existingAssignment == PlayerResource:GetTeam( playerID ) then
-- 			return nil -- already assigned to this team and they're still on it
-- 		else
-- 			return existingAssignment -- something else pushed them out of the desired team - set it back
-- 		end
-- 	end

-- 	-- haven't assigned this player to a team yet
-- 	-- print( "m_NumAssignedPlayers = " .. self.m_NumAssignedPlayers )
	
-- 	-- If the number of players per team doesn't divide evenly (ie. 10 players on 4 teams => 2.5 players per team)
-- 	-- Then this floor will round that down to 2 players per team
-- 	-- If you want to limit the number of players per team, you could just set this to eg. 1
-- 	local playersPerTeam = math.floor( DOTA_MAX_TEAM_PLAYERS / #self.m_GatheredShuffledTeams )
-- 	-- print( "playersPerTeam = " .. playersPerTeam )

-- 	local teamIndexForPlayer = math.floor( self.m_NumAssignedPlayers / playersPerTeam )
-- 	-- print( "teamIndexForPlayer = " .. teamIndexForPlayer )

-- 	-- Then once we get to the 9th player from the case above, we need to wrap around and start assigning to the first team
-- 	if teamIndexForPlayer >= #self.m_GatheredShuffledTeams then
-- 		teamIndexForPlayer = teamIndexForPlayer - #self.m_GatheredShuffledTeams
-- 		-- print( "teamIndexForPlayer => " .. teamIndexForPlayer )
-- 	end
	
-- 	teamAssignment = self.m_GatheredShuffledTeams[ 1 + teamIndexForPlayer ]
-- 	-- print( "teamAssignment = " .. teamAssignment )

-- 	self.m_PlayerTeamAssignments[ playerID ] = teamAssignment

-- 	self.m_NumAssignedPlayers = self.m_NumAssignedPlayers + 1

-- 	return teamAssignment
-- end

---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
-- function CDotaRun:MakeLabelForPlayer( nPlayerID )
-- 	if not PlayerResource:HasSelectedHero( nPlayerID ) then
-- 		return
-- 	end

-- 	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
-- 	if hero == nil then
-- 		return
-- 	end

-- 	local teamID = PlayerResource:GetTeam( nPlayerID )
-- 	local color = self:ColorForTeam( teamID )
-- 	hero:SetCustomHealthLabel( PlayerResource:GetPlayerName(nPlayerID), color[1], color[2], color[3] )
-- end

-- ---------------------------------------------------------------------------
-- -- Tell everyone the team assignments during hero selection
-- ---------------------------------------------------------------------------
-- function CDotaRun:BroadcastPlayerTeamAssignments()
-- 	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
-- 		local nTeamID = PlayerResource:GetTeam( nPlayerID )
-- 		if nTeamID ~= DOTA_TEAM_NOTEAM then
-- 			GameRules:SendCustomMessage( "#TeamAssignmentMessage", nPlayerID, -1 )
-- 		end
-- 	end
-- end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function CDotaRun:OnThink()

	-- for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
	-- 	self:MakeLabelForPlayer( nPlayerID )
	-- end
	
	playerPositions = self:SortPositions()
	self:CalculatePositions()
	self:UpdateScoreboard()
	self:BlueShell(playerPositions)
		
	return 1
end

---------------------------------------------------------------------------
-- Calculate the distances from the waypoints
---------------------------------------------------------------------------
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
			end 
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
						speed = speed + 10
					end
				end
				--Note that this actually works, but the movement display is not altered :D
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
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
-- function CDotaRun:UpdateScoreboard(playerPositions)
	
-- 	local sortedTeams = {}
-- 	for _, team in pairs( self.m_GatheredShuffledTeams ) do
-- 		table.insert( sortedTeams, { teamID = team, teamScore = self.points[team] } )
-- 	end

-- 	-- reverse-sort by score
-- 	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

-- 	UTIL_ResetMessageTextAll()
-- 	UTIL_MessageTextAll( "#ScoreboardTitle", 255, 255, 255, 255 )
-- 	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
-- 	for _, t in pairs( sortedTeams ) do
-- 		local clr = self:ColorForTeam( t.teamID )
-- 		if(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1) ~= -1) then
-- 			name = PlayerResource:GetPlayerName(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1))
-- 			UTIL_MessageTextAll(t.teamScore.."\t"..name, clr[1], clr[2], clr[3], 255)
-- 		end
-- 	end

-- 	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
-- 	UTIL_MessageTextAll( "#ScoreboardPositionHeader", 255, 255, 255, 255 )
-- 	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
-- 	for key, t in pairs( playerPositions ) do
-- 		local clr = self:ColorForTeam( t.teamID )
-- 		if t.teamID == 5 then
			
-- 		elseif key == 1 then
-- 			UTIL_MessageTextAll(key.."st\t"..t.pName, clr[1], clr[2], clr[3], 255)
-- 		elseif key == 2 then
-- 			UTIL_MessageTextAll(key.."nd\t"..t.pName, clr[1], clr[2], clr[3], 255)
-- 		elseif key == 3 then
-- 			UTIL_MessageTextAll(key.."rd\t"..t.pName, clr[1], clr[2], clr[3], 255)
-- 		else 
-- 			UTIL_MessageTextAll(key.."th\t"..t.pName, clr[1], clr[2], clr[3], 255)
-- 		end
-- 	end
-- end

function CDotaRun:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = self.points[team] } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		-- Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	-- local leader = sortedTeams[1].teamID
	-- --print("Leader = " .. leader)
	-- self.leadingTeam = leader
	-- self.runnerupTeam = sortedTeams[2].teamID
	-- self.leadingTeamScore = sortedTeams[1].teamScore
	-- self.runnerupTeamScore = sortedTeams[2].teamScore
	-- if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
	-- 	self.isGameTied = true
	-- else
	-- 	self.isGameTied = false
	-- end
	-- local allHeroes = HeroList:GetAllHeroes()
	-- for _,entity in pairs( allHeroes) do
	-- 	if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
	-- 		if entity:IsAlive() == true then
	-- 			-- Attaching a particle to the leading team heroes
	-- 			local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
 --       			if existingParticle == -1 then
 --       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
	-- 				ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
	-- 				entity:Attribute_SetIntValue( "particleID", particleLeader )
	-- 			end
	-- 		else
	-- 			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
	-- 			if particleLeader ~= -1 then
	-- 				ParticleManager:DestroyParticle( particleLeader, true )
	-- 				entity:DeleteAttribute( "particleID" )
	-- 			end
	-- 		end
	-- 	else
	-- 		local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
	-- 		if particleLeader ~= -1 then
	-- 			ParticleManager:DestroyParticle( particleLeader, true )
	-- 			entity:DeleteAttribute( "particleID" )
	-- 		end
	-- 	end
	-- end
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

-- ---------------------------------------------------------------------------
-- -- Scan the map to see which teams have spawn points
-- ---------------------------------------------------------------------------
-- function CDotaRun:GatherValidTeams()
-- --	print( "GatherValidTeams:" )

-- 	local foundTeams = {}
-- 	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
-- 		foundTeams[  playerStart:GetTeam() ] = true
-- 	end

-- 	local foundTeamsList = {}
-- 	for t, _ in pairs( foundTeams ) do
-- 		table.insert( foundTeamsList, t )
-- 	end

-- 	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )
-- end

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
-- Assign all real players to a team
---------------------------------------------------------------------------
-- function CDotaRun:EnsurePlayersOnCorrectTeam()
-- 	for playerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
-- 		local teamReassignment = self:GetTeamReassignmentForPlayer( playerID )
-- 		if nil ~= teamReassignment then
-- 			print( " - Player " .. playerID .. " reassigned to team " .. teamReassignment )
-- 			PlayerResource:SetCustomTeamAssignment( playerID, teamReassignment )
-- 		end
-- 	end
-- 	return 1 -- Check again later in case more players spawn
-- end

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
					hero:AddAbility("empty_ability1")
				end
				GameRules.dotaRun:GiveForceStaff(hero)
				
				GameRules.dotaRun.spawned[playerID] = true
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

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );
		initShakers()
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

---------------------------------------------------------------------------
-- Deletes item or ability after use
---------------------------------------------------------------------------
function CDotaRun:OnAbilityUsed(data)
	DeepPrintTable(data)
	print("Removing ability "..data.abilityname)
	--local player = EntIndexToHScript(data.PlayerID)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	DeepPrintTable(player)
	local hero = player:GetAssignedHero()


	local ability = hero:FindAbilityByName(data.abilityname)
	if(ability ~= nil) then
		-- Delete ability
		Timers:CreateTimer(4, function()
			ability:SetLevel(0)
        	hero:RemoveAbility(data.abilityname)
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
		    			hero:RemoveItem(item)
	    			end
	    		end
	   		end
	   		return
	   	end
	    )
	end
end

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