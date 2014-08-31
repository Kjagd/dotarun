-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	PrecacheUnitByNameSync("npc_dota_hero_venomancer", context) --[[Returns:void
	Precaches a DOTA unit by its dota_npc_units.txt name
	]]
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	--ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(CAddonTemplateGameMode, 'On_dota_player_used_ability'), self)
	ListenToGameEvent("dota_action_item", Dynamic_Wrap(CAddonTemplateGameMode, 'On_dota_action_item'), self)
	ListenToGameEvent("dota_item_used", Dynamic_Wrap(CAddonTemplateGameMode, 'On_dota_item_used'), self)
	ListenToGameEvent("dota_inventory_item_changed", Dynamic_Wrap(CAddonTemplateGameMode, 'On_dota_inventory_item_changed'), self)
		ListenToGameEvent("dota_inventory_item_added", Dynamic_Wrap(CAddonTemplateGameMode, 'On_dota_inventory_item_added'), self)




end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--[[function CAddonTemplateGameMode:On_dota_player_used_ability(data)
	table.foreach(data, print) 
	print(data["PlayerID"])
	player = PlayerResource:GetPlayer(data["PlayerID"]-1)
	print(player)
	print(data["abilityname"])
	player:GetAssignedHero():RemoveAbility(data["abilityname"])
end
]]
function CAddonTemplateGameMode:On_dota_action_item(data)
	print("Item action")
	table.foreach(data, print) 
 end

 function CAddonTemplateGameMode:On_dota_item_used(data)
  print("[BAREBONES] dota_item_used")
  table.foreach(data, print) 
end

 function CAddonTemplateGameMode:On_dota_inventory_item_changed(data)
  print("[BAREBONES] item changed")
  table.foreach(data, print) 
end

 function CAddonTemplateGameMode:On_dota_inventory_item_added(data)
  print("[BAREBONES] item added")
  table.foreach(data, print) 
end
