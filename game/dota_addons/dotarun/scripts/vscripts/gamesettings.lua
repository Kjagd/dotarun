if not GameSettings then
	GameSettings = {}
	GameSettings.__index = GameSettings
	GameSettings.gameLength = nil
	GameSettings.shortLength = 15
	GameSettings.medLength = 25
	GameSettings.longLength = 35
	GameSettings.voteTime = 20
end
