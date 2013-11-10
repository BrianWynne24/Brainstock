ITEM.PrintName	 = "FAL-SA58 Carbine"; //name of the item
ITEM.Description = [[D20 round magazine with a fast R.O.F.]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_PRIMARY;
ITEM.Rarity		 = ITEM_VERYRARE;
ITEM.Model		 = "models/weapons/w_dsa_fall.mdl";
ITEM.Icon		 = "icons/fal";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( "7.62x51mm" ) > 0 ) then return; end
	pl:GiveAmmo( 20, "7.62x51mm" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_fal" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end