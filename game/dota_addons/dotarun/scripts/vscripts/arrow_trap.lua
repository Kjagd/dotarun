function Fire(data)
	print("Arrow firing")
	local target = data.caller
	if target ~= nil then
    	local arrow = thisEntity:FindAbilityByName("mirana_arrow_custom")
    	thisEntity:CastAbilityOnPosition(target:GetOrigin(), arrow, -1 )
  	end
end