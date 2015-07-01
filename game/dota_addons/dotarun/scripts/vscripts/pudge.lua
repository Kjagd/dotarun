local pudges = {}
local hookAbilities = {}
local positions = {Vector(-5234,-5396,20), Vector(4161,-7033,20)}
local hookPositions = {Vector(-5271,-6243,20), Vector(4144,-6220,20)}
local numPudges = 2

function initPudges() 
	for i = 1, numPudges do
		pudges[i] = CreateUnitByName("pudge_hooker", positions[i], true, nil, nil, 1)
		hookAbilities[i] = pudges[i]:FindAbilityByName("pudge_meat_hook_ai")
		hookAbilities[i]:SetLevel(1)
		print("pudge " .. i .. " created")
		ability = pudges[i]:FindAbilityByName("Invulnerable") 
		ability:SetLevel(1)
	end
	-- pudge:AddAbility("pudge_meat_hook_custom")
	-- DeepPrintTable(hookAbility)
	--pudge:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
	startHooks()
	--Nothing below is called
	
    -- print("Timer test")
end

function hook() 
	for i = 1, numPudges do
		-- print("HOOKING " .. i)
		if (pudges[i]:GetAbsOrigin() ~= positions[i]) then
			FindClearSpaceForUnit(pudges[i], positions[i], false)
		end
		pudges[i]:CastAbilityOnPosition(hookPositions[i] + Vector(RandomInt(0, 500),RandomInt(0, 500),20), hookAbilities[i], 0)
	end
	-- pudge:CastAbilityOnTarget(unit, hookAbility, 0)
end

function startHooks()
	Timers:CreateTimer(5, function()
    	hook()
      	return RandomInt(1.5, 3.5) -- Should be randomfloat?
    end
    )
end