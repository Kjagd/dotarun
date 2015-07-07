--When / if Shiva's returns the random shall be 1, 6 again
function GiveRandomItem(hero)  
 	
 	local itemSlotsFull = GameRules.dotaRun:DoesHeroHaveMaxItems(hero)
 	if (itemSlotsFull) then
 		print("No item slots!")
 		return
 	end

	local alreadyHas = false
	local itemNew = CreateItem(GameRules.dotaRun.itemList[RandomInt(1, 9)], hero, hero)
	for i=0,5 do 
		itemOld = hero:GetItemInSlot(i)
		if(itemOld ~= nil and itemOld:GetClassname() == itemNew:GetClassname()) then
			print("Hero already has: " .. itemNew:GetClassname())
			alreadyHas = true
			break
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

	local hasMaxAbilities = true;
	for i = 1,6 do
		if(hero:GetAbilityByIndex(i):GetAbilityName() == "empty_ability1") then
			hasMaxAbilities = false
		end
	end
	
	if (not hasMaxAbilities) then
		-- See https://stackoverflow.com/questions/9613322/lua-table-getn-returns-0
		abilityName = GameRules.dotaRun.spellList[RandomInt(1, 9)]
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
	else
		print("Hero already has six abilities")
	end

end

function ItemZoneOne(trigger)
	playerID = trigger.activator:GetPlayerID()
	print("PlayerID: " .. playerID) 
	hero = trigger.activator

	if (GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] == true) then
		GiveRandomAbility(hero)
		GiveRandomItem(hero)
		GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] = false
		GameRules.dotaRun:StartZoneTimer(hero)

		local particle = ParticleManager:CreateParticleForPlayer("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_ring_inner_start.vpcf",
		 PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer(playerID))
		ParticleManager:SetParticleControl(particle, 0, trigger.activator:GetAbsOrigin())
    end
end

function WaterSlow(trigger)
	print("Slowing")
	hero = trigger.activator
	GiveUnitSlow(hero, hero, "modifier_slow")
end

function WaterUnslow(trigger)
	print("Unslowing")
	hero = trigger.activator
	hero:RemoveModifierByName("modifier_slow")
	
end

function GiveUnitSlow(source, target, modifier)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_slow", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {} )
end
