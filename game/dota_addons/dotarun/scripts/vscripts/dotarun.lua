require('pudge')



itemList = { "item_blink", "item_cyclone", "item_shivas_guard", "item_sheepstick", "item_ancient_janggo", "item_smoke_of_deceit", "item_rod_of_atos"}
spellList = {"mirana_arrow_custom", "mirana_leap_custom", "venomancer_venomous_gale_custom", "dark_seer_surge_custom", "jakiro_ice_path_custom", 
	"batrider_flamebreak_custom", "ancient_apparition_ice_vortex_custom", "gyrocopter_homing_missile_custom", "obsidian_destroyer_astral_imprisonment_custom", "pudge_meat_hook_custom"}

--problems:
--alchemist_unstable_concoction
--invoker_deafening_blast
--invoker_tornado

function GiveRandomItem(hero)
 	
 	-- See https://stackoverflow.com/questions/9613322/lua-table-getn-returns-0
	itemNew = CreateItem(itemList[RandomInt(1, 7)], hero, hero)
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
			break
	    end
	end

	itemSlotsFull = true
	for i=0,5 do 
		if(hero:GetItemInSlot(i) == nil) then
	    	itemSlotsFull = false
	    	break
	    end
	end

	if(itemSlotsFull) then
		print("No item slots!")
		return
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
		abilityName = spellList[RandomInt(1, 10)]
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