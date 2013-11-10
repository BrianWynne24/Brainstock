ITEM.PrintName	 = "Crowbar"; //name of the item
ITEM.Description = [[A rusty crowbar]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_MELEE;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/weapons/w_crowbar.mdl";
ITEM.Icon		 = "icons/crowbar";

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_melee_crowbar" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end