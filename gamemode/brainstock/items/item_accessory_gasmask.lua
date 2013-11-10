ITEM.PrintName	 = "Gasmask"; //name of the item
ITEM.Description = [[Helps you breath]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/bloocobalt/l4d/riot_gasmask.mdl";
ITEM.Icon		 = "icons/gasmask";

ITEM.OnPickup	 = function( pl )
end

ITEM.OnUse		 = function( pl )
	pl:AddAccessory( "object_gasmask" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end