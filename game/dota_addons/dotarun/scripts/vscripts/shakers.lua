local shakers = {}
local fissureAbilities = {}
local positions = {Vector(-3185,-3467,200), Vector(-2400,-3467,200),Vector(-1700,-3467,200),Vector(-1000,-3467,200),Vector(-300,-3467,200),Vector(400,-3467,200)}
local numShakers = 6

function initShakers() 
	for i = 1, numShakers do
		shakers[i] = CreateUnitByName("es_shaker", positions[i], true, nil, nil, 1)
		fissureAbilities[i] = shakers[i]:FindAbilityByName("es_fissure")
		fissureAbilities[i]:SetLevel(1)
		print("shaker " .. i .. " created")
		ability = shakers[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
	end
	startFissures()
end

function FISSURE() 
	for i = 1, numShakers do
		-- print("HOOKING " .. i)
		local randomAngle = RandomFloat(0, 2*math.pi)
		shakers[i]:MoveToPosition(shakers[i]:GetAbsOrigin() + Vector(math.cos(randomAngle)*5,math.sin(randomAngle)*5)) 
		Timers:CreateTimer(1, function()
			shakers[i]:CastAbilityOnPosition(shakers[i]:GetAbsOrigin() + Vector(math.cos(randomAngle),math.sin(randomAngle),200), fissureAbilities[i], 0)
			return
		end
		)
	end
end

function startFissures()
	Timers:CreateTimer(5, function()
    	FISSURE()
      	return RandomInt(2.5, 3.5)
    end
    )
end