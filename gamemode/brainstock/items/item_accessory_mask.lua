ITEM.PrintName	 = "Mask"; //name of the item
ITEM.Description = [[Will protect you from oncoming disease]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/dean/gtaiv/mask.mdl";
ITEM.Icon		 = "icons/mask";

ITEM.OnPickup	 = function( pl )
end

ITEM.OnUse		 = function( pl )
	pl:AddAccessory( "object_mask" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end