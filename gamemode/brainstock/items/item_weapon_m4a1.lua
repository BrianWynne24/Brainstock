ITEM.PrintName	 = "M4 Carbine"; //name of the item
ITEM.Description = [[For all of your rifle needs]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_PRIMARY;
ITEM.Rarity		 = ITEM_VERYRARE;
ITEM.Model		 = "models/weapons/w_rif_m4a1.mdl";
ITEM.Icon		 = "icons/m4a1";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( "5.56x45mm" ) > 0 ) then return; end
	pl:GiveAmmo( 30, "5.56x45mm" )
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_m4a1" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end