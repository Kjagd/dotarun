local techies = {}
local gridOrigin = Vector(-1500,-6620,300)
local gridSpace = 290
local signAbility = {}
local stasisTrap = {}
local fHeight = 3
local fLength = 4

function initTechie()
	techies = CreateUnitByName("techies_bomber", gridOrigin, true, nil, nil, 1)

	signAbility = techies:FindAbilityByName("techies_minefield_sign_custom")
	signAbility:SetLevel(1)

	stasisTrap = techies:FindAbilityByName("techies_stasis_trap_custom")
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

	x = RandomInt(0, fHeight-1)
	y = 0
	stasisTrap[x][y] = false
	print(x.."")
	while (x < fLength+1) do
		if (RandomFloat(0, 1) > 0.3) then
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
		print("X: "..x.."Y:"..y)
		if (x <= fLength-1 and y <= fHeight-1) then
			stasisTrap[x][y] = false
		end

	end

	timeout = 2
	count = 0
	for i = 0, fLength-1 do
		for j = 0, fHeight-1 do
			if (stasisTrap[i][j] == true) then
				timeout = timeout + 3
				if (count == 1) then 
					timeout = timeout + 3 --first might take longer
				end
				print("prep i = "..i.." j = " .. j .. " with " .. timeout)
				Timers:CreateTimer(timeout, function()
					techies:CastAbilityOnPosition(gridOrigin+Vector(i*gridSpace, j*gridSpace), stasisTrap, 0)
					print("planting i = "..i.." j = " .. j)
					return
				end
				)
				count = count + 1
			end
		end
	end
end