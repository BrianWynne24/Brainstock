ITEM.PrintName	 = ".357 Magnum Rounds"; //name of the item
ITEM.Description = [[]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_VERYCOMMON;
ITEM.Model		 = "models/Items/357ammo.mdl";
ITEM.Icon		 = "icons/revolverammo";

ITEM.OnUse		 = function( pl )
	pl:GiveAmmo( 10, ".357 Magnum" );
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:GetAmmoCount( ".357 Magnum" ) >= 60 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end