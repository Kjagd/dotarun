require('dotarun')

function Fire(data)
	if not isHero(data) then
		return
	end
	print("Arrow firing")
	local target = data.caller
	if target ~= nil then
    	local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    	thisEntity:CastAbilityOnPosition(Vector(7040,512,20), arrow, -1 )
  	end
end

local Points = {Vector(4058,6076,20),Vector(3286,6964,20),Vector(2286,6072,20),Vector(1470,6940,20), Vector(-1120,6724,20), Vector(-1097,6528,20), Vector(-1114,6361,20)}
function FireAtPoint(data)
	if not isHero(data) then
		return
	end	
	print("Arrow firing")
	local target = data.caller
	if target ~= nil then
		if(string.find(thisEntity:GetName(), "two")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[1], arrow, -1 )
    	elseif (string.find(thisEntity:GetName(), "three")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[2], arrow, -1 )
    	elseif (string.find(thisEntity:GetName(), "four")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[3], arrow, -1 )
    	elseif (string.find(thisEntity:GetName(), "five")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[4], arrow, -1 )
    	elseif (string.find(thisEntity:GetName(), "six")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[5], arrow, -1 )
    	elseif (string.find(thisEntity:GetName(), "seven")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[6], arrow, -1 )
    	elseif (string.find(thisEntity:GetName(), "eight")) then
    		local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    		thisEntity:CastAbilityOnPosition(Points[7], arrow, -1 )
    	end
  	end
end

function TaTrap(data)
	if not isHero(data) then
		return
	end
	print("TA trap!")
	if (not GameRules.dotaRun.TaTrapFired) then
		local TaTrap = Entities:FindByName(nil, "ta_trap_one")
		trap = TaTrap:FindAbilityByName("templar_assassin_psionic_trap_custom")
		trap:SetLevel(1)
		TaTrap:CastAbilityOnPosition(Vector(-4160, 6528, 320), trap, -1 )

		trap = TaTrap:FindAbilityByName("templar_assassin_trap_custom")
		trap:SetLevel(1)
		TaTrap:CastAbilityOnPosition(Vector(-4160, 6528, 320), trap, -1 )

		GameRules.dotaRun.TaTrapFired = true
	end
end