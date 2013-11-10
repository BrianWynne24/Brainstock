ITEM.PrintName	 = "AK-47 Klashnikov"; //name of the item
ITEM.Description = [[Takes primary weapon slot, uses 5.56x45mm ammo]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_PRIMARY;
ITEM.Rarity		 = ITEM_VERYRARE;
ITEM.Model		 = "models/weapons/w_rif_ak47.mdl";
ITEM.Icon		 = "icons/ak47";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( "7.62x51mm" ) > 0 ) then return; end
	pl:GiveAmmo( 30, "7.62x51mm" )
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_ak47" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end