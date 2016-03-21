
if not PLAYERS_NOT_VOTED then
	PLAYERS_NOT_VOTED  = {}
	VOTE_RESULTS = {}
end

function VoteCast(source, table)
	DeepPrintTable(table)
	local playerID = tonumber(table.PlayerID)
	local vote = table.data['length']
	print( "PlayerID" .. playerID .. " voted " .. vote)

	if not PLAYERS_NOT_VOTED[playerID] then
		print(playerID .. " attempted to vote again!") -- this should never happen
	else
		PLAYERS_NOT_VOTED[playerID] = nil

		AddVote(VOTE_RESULTS, vote)

		local count = 0
		for k, v in pairs(PLAYERS_NOT_VOTED) do
			count = count + 1
		end
		if count == 0 then
			FinalizeVotes() -- all players have finished voting
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
	--if (winner == "Short") then
	--	self.pointsToWin = self.pointsToWinShort
	--elseif (winner == "Long") then
	--	self.pointsToWin = self.pointsToWinLong
	--else 
	--	self.pointsToWin = self.pointsToWinMed
	--end

	--print("Vote winner:" .. self.pointsToWin)
end

function StartVoteTimer()
	for i = 0,(DOTA_MAX_TEAM_PLAYERS-1) do
		local player = PlayerResource:GetPlayer(i)
		if (player ~= nil) then
			PLAYERS_NOT_VOTED[i] = 1
		end
	end

	local loops = 60
	Timers:CreateTimer("VoteThinker", {
		callback = function()
			loops = loops - 1
			CustomGameEventManager:Send_ServerToAllClients("update_vote_timer", { time = loops } )
			if loops == 30 then
				EmitAnnouncerSound("announcer_ann_custom_timer_sec_30")
			elseif loops == 5 then
				EmitAnnouncerSound("announcer_ann_custom_timer_sec_05")
			elseif loops == 0 then
				print("Vote timer ran out")
				--FinalizeVotes() --time has run out, finalize votes
				return nil
			end
			return 1
		end
	})
end

