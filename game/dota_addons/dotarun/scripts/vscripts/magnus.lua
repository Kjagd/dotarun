local magnus = {}
local skewerAbilities = {}
local positions = {Vector(4564,2308, 300), Vector(4141,2308, 300), Vector(5040,2308, 300)} 
local target = {Vector(4564,200, 300), Vector(4141,200, 300), Vector(5040,200, 300)} 
local numMagnus = 3

function initMagnus() 
	for i = 1, numMagnus do
		magnus[i] = CreateUnitByName("skewer_magnus", positions[i], true, nil, nil, 1)
		skewerAbilities[i] = magnus[i]:FindAbilityByName("magnus_skewer_lua")
		skewerAbilities[i]:SetLevel(1)
		print("magnus " .. i .. " created")
		ability = magnus[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
	end
	
	startPatrol_mag()
end

function act_mag(magnusNum) 
	magnus[magnusNum]:CastAbilityOnPosition(target[magnusNum], skewerAbilities[magnusNum], 0)
	--magnus[magnusNum]:MoveToPosition(target[magnusNum])
	--magnus[magnusNum]:MoveToPosition(magnus[magnusNum]:GetAbsOrigin() + Vector(0,1000,0))
	Timers:CreateTimer(4, function()
		magnus[magnusNum]:MoveToPosition(positions[magnusNum])
		return 
	end
	)
end

function patrol_mag(magnusNum)
	Timers:CreateTimer(0, function()
		act_mag(magnusNum)
		return 10
	end
	)
end


function startPatrol_mag()
	for i = 1, numMagnus do
		patrol_mag(i)
	end
end