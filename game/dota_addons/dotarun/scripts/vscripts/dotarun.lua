--problems:
--alchemist_unstable_concoction
--invoker_deafening_blast
--invoker_tornado

function GiveRandomItem(hero)
 	
 	local itemSlotsFull = GameRules.dotaRun:DoesHeroHaveMaxItems(hero)
 	if (itemSlotsFull) then
 		print("No item slots!")
 		return
 	end

	local alreadyHas = false
	local itemNew = CreateItem(GameRules.dotaRun.itemList[RandomInt(1, 6)], hero, hero)
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

	hasMaxAbilities = true;
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

	-- DeepPrintTable(trigger)


	playerID = trigger.activator:GetPlayerID()
	print("PlayerID: " .. playerID) 
	hero = trigger.activator

	-- hook(hero)

	print("Entered Item Zone, can get new item: ", GameRules.dotaRun.zoneOpen[hero:GetPlayerID()])
	print("PlayerID: " .. hero:GetPlayerID())
	
	if (GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] == true) then
		GiveRandomAbility(hero)
		GiveRandomItem(hero)
		GameRules.dotaRun.zoneOpen[hero:GetPlayerID()] = false
		GameRules.dotaRun:StartZoneTimer(hero)
    end


	-- if(zoneOpen[hero:GetPlayerID()] == nil) then
	-- 	zoneOpen[hero:GetPlayerID()] = 0
	-- end

	-- if(zoneOpen[hero:GetPlayerID()] < 5) then
	-- 	zoneOpen[hero:GetPlayerID()] = zoneOpen[hero:GetPlayerID()] + 1
	-- 	print("items picked up by player " .. hero:GetPlayerID()..": "..zoneOpen[hero:GetPlayerID()])
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