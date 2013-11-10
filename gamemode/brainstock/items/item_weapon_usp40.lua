ITEM.PrintName	 = "USP .40"; //name of the item
ITEM.Description = [[A silenced sidearm, uses 9x19mm ammo]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_SECONDARY;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/weapons/w_pist_usp4.mdl";
ITEM.Icon		 = "icons/usp";

ITEM.OnPickup    = function( pl )
	if ( pl:GetAmmoCount( "9x19mm" ) > 0 ) then return; end
	pl:GiveAmmo( 12, "9x19mm" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_usp40" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end