ITEM.PrintName	 = "Walkie to communicate with your squad"; //name of the item
ITEM.Description = [[]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/props_junk/cardboard_box004a.mdl";
ITEM.Icon		 = "icons/no_icon";

ITEM.OnUse		 = function( pl )
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return true;
end

ITEM.OnDropped		= function( pl )
end