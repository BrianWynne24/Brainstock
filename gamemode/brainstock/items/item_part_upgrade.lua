ITEM.PrintName	 = "Weapon Upgrade"; //name of the item
ITEM.Description = [[Use at the workbench]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_MAXRARE;
ITEM.Model		 = "models/props_lab/box01a.mdl";
ITEM.Icon		 = "icons/weapon_upgrade";

ITEM.OnUse		 = function( pl )
end

ITEM.CanUseItem	  = function( pl )
	return false;
end

ITEM.DontRemoveOnUse	= function()
	return true;
end