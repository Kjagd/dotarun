local magnus = {}
local skewerAbilities = {}
local positions = {Vector(4593,20, 300)} 
local target = {Vector(4593, 2586, 300)}
local numMagnus = 1

function initMagnus() 
	for i = 1, numMagnus do
		magnus[i] = CreateUnitByName("skewer_magnus", positions[i], true, nil, nil, 1)
		skewerAbilities[i] = magnus[i]:FindAbilityByName("skew")
		skewerAbilities[i]:SetLevel(1)
		print("magnus " .. i .. " created")
		ability = magnus[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
	end
	
	startPatrol_mag()
end

function act_mag(magnusNum) 
	magnus[magnusNum]:CastAbilityOnPosition(target[1], skewerAbilities[magnusNum], 0)
	Timers:CreateTimer(10, function()
		magnus[magnusNum]:MoveToPosition(positions[magnusNum])
		return 
	end
	)
end

function patrol_mag(magnusNum)
	Timers:CreateTimer(10, function()
		act_mag(magnusNum)
		return 8
	end
	)
end


function startPatrol_mag()
	for i = 1, numMagnus do
		patrol_mag(i)
	end
end