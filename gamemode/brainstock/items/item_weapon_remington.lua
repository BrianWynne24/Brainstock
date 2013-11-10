ITEM.PrintName	 = "Remington 870"; //name of the item
ITEM.Description = [[A shotgun that uses buckshot shells]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_PRIMARY;
ITEM.Rarity		 = ITEM_VERYRARE;
ITEM.Model		 = "models/weapons/w_shot_remington.mdl";
ITEM.Icon		 = "icons/shotgun";

ITEM.OnPickup	 = function( pl )
	if ( pl:GetAmmoCount( "Buckshot" ) > 0 ) then return; end
	pl:GiveAmmo( 7, "Buckshot" );
end

ITEM.OnUse		 = function( pl )
	pl:Give( "bs_weapon_remington" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end