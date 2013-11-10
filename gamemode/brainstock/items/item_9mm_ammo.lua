ITEM.PrintName	 = "9mm Rounds"; //name of the item
ITEM.Description = [[Adds 12 rounds to your ammunition]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_VERYCOMMON;
ITEM.Model		 = "models/items/boxsrounds.mdl";
ITEM.Icon		 = "icons/smallammo";

ITEM.OnUse		 = function( pl )
	pl:GiveAmmo( 12, "9x19mm" );
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:GetAmmoCount( "9x19mm" ) >= 120 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end