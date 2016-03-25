
if not PLAYERS_NOT_VOTED then
	PLAYERS_NOT_VOTED  = {}
	VOTE_RESULTS = {}
end

function VoteCast(source, table)
	local playerID = tonumber(table.PlayerID)
	local vote = table.data['length']
	print( "PlayerID " .. playerID .. " voted " .. vote)

	if not PLAYERS_NOT_VOTED[playerID] then
		print(playerID .. " attempted to vote again!") -- this should never happen
	else
		PLAYERS_NOT_VOTED[playerID] = nil

		AddVote(VOTE_RESULTS, vote)

		CustomGameEventManager:Send_ServerToAllClients( "vote_cast", { voted = vote, vote_count = VOTE_RESULTS[vote], unit_name = PlayerResource:GetPlayer(playerID):GetAssignedHero():GetUnitName() } )
		local count = 0
		for k, v in pairs(PLAYERS_NOT_VOTED) do
			count = count + 1
		end
		if count == 0 then
			--FinalizeVotes() -- all players have finished voting (disabled for now)
		end
	end
end

function AddVote(option, choice)
	if not option[choice] then
		option[choice] = 1
	else
		option[choice] = option[choice] + 1
	end
end

function GetWinningChoice(option)
	local highestVotes = 0

	winner = "Med"
	for k, v in pairs(option) do
		if v > highestVotes then
			highestVotes = v
			winner = k
		end
	end

	return winner
 end


function FinalizeVotes()
	if VOTING_FINISHED then return end --Never allow voting twice

	print("All players have finished voting")
	Timers:RemoveTimer("VoteThinker")
	VOTING_FINISHED = true

	winner = GetWinningChoice(VOTE_RESULTS)
	if (winner == "Short") then
		GameSettings.gameLength = GameSettings.shortLength
	elseif (winner == "Long") then
		GameSettings.gameLength = GameSettings.longLength
	else 
		GameSettings.gameLength = GameSettings.medLength
	end

	print("Vote winner:" .. GameSettings.gameLength)
	CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameSettings.gameLength } )
	GameRules.dotaRun.pointsToWin = GameSettings.gameLength
	CustomNetTables:SetTableValue( "game_state", "color_to_win", { win_color = winner } )

	CustomGameEventManager:Send_ServerToAllClients( "voting_done", { winner = winner } )
end

function StartVoteTimer()
	for i = 0,(DOTA_MAX_TEAM_PLAYERS-1) do
		local player = PlayerResource:GetPlayer(i)
		if (player ~= nil) then
			PLAYERS_NOT_VOTED[i] = 1
		end
	end

	local loops = GameSettings.voteTime-5
	Timers:CreateTimer("VoteThinker", {
		callback = function()
			loops = loops - 1
			CustomGameEventManager:Send_ServerToAllClients("update_vote_timer", { time = loops } )
			if loops == 0 then
				print("Vote timer ran out")
				FinalizeVotes() --time has run out, finalize votes
				return nil
			end
			return 1
		end
	})
end

