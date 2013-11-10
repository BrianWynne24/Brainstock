ITEM.PrintName	 = "Delisle Sniper Rifle"; //name of the item
ITEM.Description = [[I don't use descriptions anyway]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_PRIMARY;
ITEM.Rarity		 = ITEM_MAXRARE;
ITEM.Model		 = "models/weapons/w_snip_delsi.mdl";
ITEM.Icon		 = "icons/vss";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( ".45 ACP" ) > 0 ) then return; end
	pl:GiveAmmo( 10, ".45 ACP" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_delisle" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end