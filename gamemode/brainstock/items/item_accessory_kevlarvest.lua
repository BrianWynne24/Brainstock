ITEM.PrintName	 = "Kevlar Vesr"; //name of the item
ITEM.Description = [[Will protect most of your vital organs]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/kevlarvest/kevlarvest.mdl";
ITEM.Icon		 = "icons/vest";

ITEM.OnPickup	 = function( pl )
end

ITEM.OnUse		 = function( pl )
	pl:AddAccessory( "object_kevlarvest" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end