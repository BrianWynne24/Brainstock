ITEM.PrintName	 = "Ice Axe"; //name of the item
ITEM.Description = [[A very effective melee weapon]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_MELEE;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/weapons/w_iceaxe.mdl";
ITEM.Icon		 = "icons/icepick";

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_melee_iceaxe" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end