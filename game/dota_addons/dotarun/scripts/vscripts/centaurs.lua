local cents = {}
local boss = {}
local stompAbilities = {}
local positions = {Vector(3400,-3700,200), Vector(3120, -3266, 200), 
Vector(2600, -2480, 200), Vector(4180, -3100, 200),
Vector(4740, -4100, 200), Vector(2090, -3888, 200),
Vector(4564, -3600, 200), Vector(4560, -3075,200),
Vector(4560, -2544, 200),  Vector(4578, -1039, 200)} --Last pos is boss
local numCents = 10

function initCents() 
	for i = 1, numCents-1 do
		cents[i] = CreateUnitByName("stomp_cent", positions[i], true, nil, nil, 1)
		stompAbilities[i] = cents[i]:FindAbilityByName("cent_stomp")
		stompAbilities[i]:SetLevel(1)
		print("cent " .. i .. " created")
		ability = cents[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
	end

	cents[numCents] = CreateUnitByName("stomp_cent_boss", positions[numCents], true, nil, nil, 1)
	stompAbilities[numCents] = cents[numCents]:FindAbilityByName("cent_stomp_2")
	stompAbilities[numCents]:SetLevel(1)

	ability = cents[numCents]:FindAbilityByName("Invulnerable") 
	ability:SetLevel(1)

	startPatrol()
end

function act(centNum) 
	cents[centNum]:CastAbilityOnPosition(cents[centNum]:GetAbsOrigin(), stompAbilities[centNum], 0)
	Timers:CreateTimer(1, function()
		local randomAngle = RandomFloat(0, 2*math.pi)
		cents[centNum]:MoveToPosition(positions[centNum] + Vector(math.cos(randomAngle)*300,math.sin(randomAngle)*300, 200))
		return 
	end
	)
end

function patrol(centNum)
	Timers:CreateTimer(0, function()
		act(centNum)
		return RandomInt(1.5, 3.5)
	end
	)
end


function startPatrol()
	for i = 1, numCents do
		patrol(i)
	end
end