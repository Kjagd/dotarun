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
	
	startPatrol()
end

function act(magnusNum) 
	magnus[magnusNum]:CastAbilityOnPosition(target, skewerAbilities[magnusNum], 0)
	Timers:CreateTimer(1, function()
		magnus[magnusNum]:MoveToPosition(positions[magnusNum])
		return 
	end
	)
end

function patrol(magnusNum)
	Timers:CreateTimer(0, function()
		act(magnusNum)
		return 8
	end
	)
end


function startPatrol()
	for i = 1, numMagnus do
		patrol(i)
	end
end