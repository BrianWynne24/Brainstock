ITEM.PrintName	 = "Buckshot Rounds"; //name of the item
ITEM.Description = [[Adds 12 rounds to your Buckshot ammo]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_VERYCOMMON;
ITEM.Model		 = "models/Items/BoxBuckshot.mdl";
ITEM.Icon		 = "icons/buckshot";

ITEM.OnUse		 = function( pl )
	pl:GiveAmmo( 12, "Buckshot" );
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:GetAmmoCount( "Buckshot" ) >= 100 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end