local zoneCount = {}

function GiveRandomItem(hero)
	print("Entered Item Zone")

	itemList = { 'item_blink', 'item_force_staff', 'item_cyclone', 'item_rod_of_atos'}
 
	item = CreateItem(itemList[math.random(#itemList)], hero, hero)
	hero:AddItem(item)

end

function ItemZoneOne(trigger)
	
	
	hero = trigger.activator
	if(zoneCount[hero:GetPlayerID()] == nil) then
		zoneCount[hero:GetPlayerID()] = 0
	end
	zoneCount[hero:GetPlayerID()] = zoneCount[hero:GetPlayerID()] + 1
	print("items picked up by player " .. hero:GetPlayerID()..": "..zoneCount[hero:GetPlayerID()])
	GiveRandomItem(hero)
end