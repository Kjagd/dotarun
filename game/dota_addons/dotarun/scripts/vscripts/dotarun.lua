local zoneCount = {}

function GiveRandomItem(hero)


	itemList = { "item_blink", "item_force_staff", "item_cyclone", "item_gale"}
 
	item = CreateItem(itemList[math.random(#itemList)], hero, hero)
	hero:AddItem(item)

end

function ItemZoneOne(trigger)
	print("Entered Item Zone")

	hero = trigger.activator

	if(zoneCount[hero:GetPlayerID()] == nil) then
		zoneCount[hero:GetPlayerID()] = 0
	end

	if(zoneCount[hero:GetPlayerID()] < 5) then
		zoneCount[hero:GetPlayerID()] = zoneCount[hero:GetPlayerID()] + 1
		print("items picked up by player " .. hero:GetPlayerID()..": "..zoneCount[hero:GetPlayerID()])
		GiveRandomItem(hero)
	end
end

-- function GiveImmunity(trigger)
-- 	hero = trigger.activator
-- 	local ability = hero:FindAbilityByName("Immunity")
-- 	ability:SetLevel(1)
-- end