function CDotaRun:Think()
	print("thinking")

	for i = 0,9 do
		local player = PlayerResource:GetPlayer(i)
		if (player ~= nil) then
			print(i.." distance "..#(Entities:FindByName( nil, "waypointHomeTeleport" ):GetAbsOrigin()) - #(player:GetAssignedHero():GetAbsOrigin()))
		end
	end


--[[
	for i = 3,1, -1 do
		for j = 0,9 do
			GameRules.dotaRun.waypoints[j][i]
		end
	end
]]
	return 1
end

Entities:FindAllByClassname('dota_base_game_mode')[1]:SetThink('Think', 'CDotaRun', 2, self)