ITEM.PrintName	 = "7.62 Rounds"; //name of the item
ITEM.Description = [[Adds 30 rounds to your 7.62x51mm ammunition]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_VERYCOMMON;
ITEM.Model		 = "models/items/boxmrounds.mdl";
ITEM.Icon		 = "icons/largeammo";

ITEM.OnUse		 = function( pl )
	pl:GiveAmmo( 30, "7.62x51mm" );
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:GetAmmoCount( "7.62x51mm" ) >= 180 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end