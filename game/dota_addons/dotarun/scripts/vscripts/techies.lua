local techies = {}
local gridOrigin = Vector(-1300,-6620,300)
local gridSpace = 290
local signAbility = {}
local stasisTrap = {}
local fHeight = 3
local fLength = 4

function initTechie()
	techies = CreateUnitByName("techies_bomber", gridOrigin, true, nil, nil, 1)

	signAbility = techies:FindAbilityByName("techies_minefield_sign_custom")
	signAbility:SetLevel(1)

	stasisTrap = techies:FindAbilityByName("techies_stasis_trap_datadriven")
	stasisTrap:SetLevel(1)

	techies:FindAbilityByName("Invulnerable"):SetLevel(1)
end

function setUpMines()


	for i = 0, fLength-1 do
		stasisTrap[i] = {}
		for j = 0, fHeight-1 do
			stasisTrap[i][j] = true
		end
	end

	x = 0
	y = RandomInt(0, fHeight-1)
	stasisTrap[x][y] = false
	while (x < fLength+1) do
		if (RandomFloat(0, 1) > 0.6) then
			x = x + 1
		else
			if (y == 0 or y == fHeight-1) then 
				y = 1
			else
				if (RandomInt(0, 1) == 0) then
					y = 0
				else 
					y = 2
				end
			end
		end
		if (x <= fLength-1 and y <= fHeight-1) then
			stasisTrap[x][y] = false
		end

	end

	timeout = 0
	count = 0
	for i = 0, fLength-1 do
		for j = 0, fHeight-1 do
			if (stasisTrap[i][j] == true) then
				timeout = timeout + 2
				if (count == 1) then 
					timeout = timeout + 1 --first might take longer
				end
				Timers:CreateTimer(timeout, function()
					techies:CastAbilityOnPosition(gridOrigin+Vector(i*gridSpace, j*gridSpace), signAbility, 0)
					techies:CastAbilityOnPosition(gridOrigin+Vector(i*gridSpace, j*gridSpace), stasisTrap, 0)
					return
				end
				)
				count = count + 1
			end
		end
	end
end