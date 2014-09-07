
local zoneCount = {}
for i = 0,9 do
	zoneCount[i] = true
end


itemList = { "item_blink", "item_cyclone", "item_shivas_guard", "item_sheepstick", "item_ancient_janggo", "item_smoke_of_deceit", "item_rod_of_atos"}
spellList = {"mirana_arrow_custom", "mirana_leap_custom", "venomancer_venomous_gale_custom", "dark_seer_surge_custom", "jakiro_ice_path_custom", 
"batrider_flamebreak_custom", "ancient_apparition_ice_vortex_custom", "gyrocopter_homing_missile_custom", "obsidian_destroyer_astral_imprisonment_custom"}

--problems:
--alchemist_unstable_concoction
--invoker_deafening_blast
--invoker_tornado

function GiveRandomItem(hero)
 	
	itemNew = CreateItem(itemList[math.random(#itemList)], hero, hero)
	alreadyHas = false
	for i=0,5 do 
	   	itemOld = hero:GetItemInSlot(i)
		if(itemOld ~= nil and itemOld:GetClassname() == itemNew:GetClassname()) then
			print("Hero already has: " .. itemNew:GetClassname())
			alreadyHas = true
			break
		elseif (itemNew:GetClassname() == "item_smoke_of_deceit" and hero:GetPlayerID() == GameRules.dotaRun.lead) then
			print("Cannot get smoke if you're in the lead")
			alreadyHas = true
	    end
	end

	if (alreadyHas) then 
		GiveRandomItem(hero)
	else
		print("Adding item: " .. itemNew:GetClassname())
	    hero:AddItem(itemNew)
	end

end

function GiveRandomAbility(hero)

	ability1 = hero:GetAbilityByIndex(1)
	ability2 = hero:GetAbilityByIndex(2)
	ability3 = hero:GetAbilityByIndex(3)
	ability4 = hero:GetAbilityByIndex(4)
	ability5 = hero:GetAbilityByIndex(5)
	ability6 = hero:GetAbilityByIndex(6)

	print(ability1:GetAbilityName() .. " " .. ability2:GetAbilityName() .. " " .. ability3:GetAbilityName() .. 
		" " .. ability4:GetAbilityName() .. " " .. ability5:GetAbilityName() .. " " .. ability6:GetAbilityName())
	
	hasMaxAbilities = false
	if(ability1:GetAbilityName() ~= "empty_ability1" and ability2:GetAbilityName() ~= "empty_ability1" and ability3:GetAbilityName() ~= "empty_ability1" and
		ability4:GetAbilityName() ~= "empty_ability1" and ability5:GetAbilityName() ~= "empty_ability1" and ability6:GetAbilityName() ~= "empty_ability1") then
		print("Hero already has six abilities")
		hasMaxAbilities = true
	else 
		hasMaxAbilities = false
	end

	if (not hasMaxAbilities) then
		abilityName = spellList[math.random(#spellList)]
		if(hero:FindAbilityByName(abilityName) == nil) then
			print("Adding ability: "..abilityName)
    	    hero:RemoveAbility("empty_ability1") 
			hero:AddAbility(abilityName)
			ability = hero:FindAbilityByName(abilityName)
			ability:SetLevel(1)
			-- ability:SetAbilityIndex(1)
		else 
			print("Hero already had ability: "..abilityName)
			GiveRandomAbility(hero)
   		end
	end

end

function ItemZoneOne(trigger)
	-- See http://stackoverflow.com/questions/18199844/lua-math-random-not-working pop dem randoms
	-- Vi burde nok bare bruge volvos random
	math.randomseed(GameRules:GetGameTime() )
	math.random()
	math.random()
	math.random()

	hero = trigger.activator

	print("Entered Item Zone")
	print(zoneCount[hero:GetPlayerID()])


	


	if (zoneCount[hero:GetPlayerID()] == true) then
		GiveRandomAbility(hero)
		GiveRandomItem(hero)
		zoneCount[hero:GetPlayerID()] = false
		Timers:CreateTimer(5, function()
			zoneCount[hero:GetPlayerID()] = true
            return
        end
        )
    end


	-- if(zoneCount[hero:GetPlayerID()] == nil) then
	-- 	zoneCount[hero:GetPlayerID()] = 0
	-- end

	-- if(zoneCount[hero:GetPlayerID()] < 5) then
	-- 	zoneCount[hero:GetPlayerID()] = zoneCount[hero:GetPlayerID()] + 1
	-- 	print("items picked up by player " .. hero:GetPlayerID()..": "..zoneCount[hero:GetPlayerID()])
	-- 	GiveRandomItem(hero)
	-- end
end

function WaterSlow(trigger)
	print("Slowing")
	hero = trigger.activator
	GiveUnitSlow(hero, hero, "modifier_slow", 50)
end

function WaterUnslow(trigger)
	print("Unslowing")
	hero = trigger.activator
	hero:RemoveModifierByName("modifier_slow")
	
end

function GiveUnitSlow(source, target, modifier,dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_slow", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end


-- function GiveImmunity(trigger)
-- 	hero = trigger.activator
-- 	local ability = hero:FindAbilityByName("Immunity")
-- 	ability:SetLevel(1)
-- end