local pudge = {}
local hookAbility = {}

function initPudge() 
	pudge = CreateUnitByName("pudge_hooker", Vector(-7350,-6350,20), true, nil, nil, 1)
	pudge:AddAbility("pudge_meat_hook_custom")
	hookAbility = pudge:FindAbilityByName("pudge_meat_hook_custom")
	hookAbility:SetLevel(1)
	print("pudge created")
	DeepPrintTable(hookAbility)
	--pudge:AddNewModifier(caster, ability, "modifier_stunned", modifier_table) 
end

function hook(unit) 
	print("HOOKING")
	
	pudge:CastAbilityOnTarget(unit, hookAbility, 1)
end