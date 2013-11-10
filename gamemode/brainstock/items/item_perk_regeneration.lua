ITEM.PrintName	 = "Perk: Regeneration"; //name of the item
ITEM.Description = [[Use to equip this perk]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/Items/combine_rifle_ammo01.mdl";
ITEM.Icon		 = "icons/perk_regeneration";

ITEM.OnUse		 = function( pl )
	pl:AddPerk( "perk_regeneration" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end