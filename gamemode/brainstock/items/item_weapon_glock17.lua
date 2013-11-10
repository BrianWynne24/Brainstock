ITEM.PrintName	 = "Glock 17"; //name of the item
ITEM.Description = [[A sidearm, uses 9x19mm ammo]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_SECONDARY;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/weapons/w_glock18_weap.mdl";
ITEM.Icon		 = "icons/glock";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( "9x19mm" ) > 0 ) then return; end
	pl:GiveAmmo( 10, "9x19mm" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_glock17" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end