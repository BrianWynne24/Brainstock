ITEM.PrintName	 = "G3SG-1"; //name of the item
ITEM.Description = [[For all of your rifle needs]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_PRIMARY;
ITEM.Rarity		 = ITEM_VERYRARE;
ITEM.Model		 = "models/weapons/w_rif_galil.mdl";
ITEM.Icon		 = "icons/no_icon";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( "7.62x51mm" ) > 0 ) then return; end
	pl:GiveAmmo( 20, "7.62x51mm" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_g3sg1" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end