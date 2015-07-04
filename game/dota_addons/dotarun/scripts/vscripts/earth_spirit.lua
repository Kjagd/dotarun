local earth_spirit = {}
local kickAbilities = {}
local placeAbilities = {}
local positionsBot = {Vector(1535, 3839, 300), Vector(124, 3840, 300), Vector(-1666, 3136, 300)}
local positionsTop = {Vector(1535, 5119, 300), Vector(124, 5119, 300), Vector(-1666, 4288, 300)}  
local numEarth = 3

function initEarthSpirit() 
	for i = 1, numEarth do
		earth_spirit[i] = CreateUnitByName("kicker_earth_spirit", positionsBot[i], true, nil, nil, 1)
		kickAbilities[i] = earth_spirit[i]:FindAbilityByName("earth_spirit_boulder_smash_custom")
		kickAbilities[i]:SetLevel(1)
		placeAbilities[i] = earth_spirit[i]:FindAbilityByName("earth_spirit_stone_caller_custom")
		placeAbilities[i]:SetLevel(1)
		print("earth spirit top" .. i .. " created")
		ability = earth_spirit[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
		Timers:CreateTimer(0.06, function()
			earth_spirit[i]:CastAbilityOnPosition(positionsBot[i], placeAbilities[i], 0)
			return
		end
		)

	end

	for i = 4, numEarth*2 do
		earth_spirit[i] = CreateUnitByName("kicker_earth_spirit", positionsTop[i-numEarth], true, nil, nil, 1)
		kickAbilities[i] = earth_spirit[i]:FindAbilityByName("earth_spirit_boulder_smash_custom")
		kickAbilities[i]:SetLevel(1)
		placeAbilities[i] = earth_spirit[i]:FindAbilityByName("earth_spirit_stone_caller_custom")
		placeAbilities[i]:SetLevel(1)
		print("earth spirit bot " .. i .. " created")
		ability = earth_spirit[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
	end
	
	startPatrol_earthSpirit()
end

function act_earthSpirit(earthSpiritNum)
	if earthSpiritNum < 4 then
		if (earth_spirit[earthSpiritNum]:GetAbsOrigin() ~= positionsBot[earthSpiritNum]) then
			FindClearSpaceForUnit(earth_spirit[earthSpiritNum], positionsBot[earthSpiritNum], false)
		end
		earth_spirit[earthSpiritNum]:CastAbilityOnPosition(positionsTop[earthSpiritNum], kickAbilities[earthSpiritNum], 0)
	else
		if (earth_spirit[earthSpiritNum]:GetAbsOrigin() ~= positionsTop[earthSpiritNum-numEarth]) then
			FindClearSpaceForUnit(earth_spirit[earthSpiritNum], positionsTop[earthSpiritNum-numEarth], false)
		end
		earth_spirit[earthSpiritNum]:CastAbilityOnPosition(positionsBot[earthSpiritNum-numEarth], kickAbilities[earthSpiritNum], 0)
	end
	
end

function patrol_earthSpirit(earthSpiritNum)
	Timers:CreateTimer(0, function()
		act_earthSpirit(earthSpiritNum)
		return 6
	end
	)
end


function startPatrol_earthSpirit()
	for i = 1, numEarth*2 do
		if i < 4 then	
			patrol_earthSpirit(i)
		else 
			Timers:CreateTimer(2, function()
				patrol_earthSpirit(i)
				return
			end
			)
		end
	end
end