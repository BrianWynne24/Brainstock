ITEM.PrintName	 = "MP412 Rex Revolver"; //name of the item
ITEM.Description = [[A sidearm, uses .357 Magnum ammo]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_SECONDARY;
ITEM.Rarity		 = ITEM_VERYRARE;
ITEM.Model		 = "models/weapons/w_rex_revolve.mdl";
ITEM.Icon		 = "icons/rexrevolver";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( ".357 Magnum" ) > 0 ) then return; end
	pl:GiveAmmo( 6, ".357 Magnum" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_rexrevolver" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end