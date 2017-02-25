local lastPosition = Vector(0,0,0)
local charger = {}

function Charge(keys)
	local caster = keys.caster

	charger = CreateUnitByName("charger", caster:GetAbsOrigin(), true, nil, nil, 1)
	local chargeAbility = charger:FindAbilityByName("spirit_breaker_charge_of_darkness_custom")
	chargeAbility:SetLevel(1)
	charger:FindAbilityByName("spirit_breaker_greater_bash_custom"):SetLevel(1)

	local playerID = GameRules.dotaRun.leadingPlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local target = 0
	if (player ~= nil) then
		local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
		if (hero ~= nil) then
			target = hero
		end
	end


	-- Give the casting player some time to move away
	Timers:CreateTimer(0.50, function()
		charger:CastAbilityOnTarget(target, chargeAbility, target:GetPlayerOwnerID())
		return 
	end
	)

	GameRules:GetGameModeEntity():SetThink( "ChargerThink", self, 2 )
	

	--local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	--charger:CastAbilityOnTarget(targets[1], chargeAbility, targets[1]:GetPlayerOwnerID())
	-- for i = 1, #targets do
	-- 	if targets[i] ~= target then --avoid dealing twice the damage
	-- 		local damageTable = {
	-- 			victim = targets[i],
	-- 			attacker = caster,
	-- 			damage = keydamage,
	-- 			damage_type = DAMAGE_TYPE_PHYSICAL,
	-- 		}
	-- 		ApplyDamage(damageTable)
	-- 	end
	-- end
end

function ChargerThink()
	print(lastPosition)
	print(charger:GetAbsOrigin())

	print(lastPosition - charger:GetAbsOrigin())
	if (lastPosition - charger:GetAbsOrigin() == Vector(0,0,0)) then -- has not moved for 5 secs
		charger:Destroy()
		return
	end

	print("thinking")
	lastPosition = charger:GetAbsOrigin()

	return 2
end