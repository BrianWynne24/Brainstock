ITEM.PrintName	 = "5.56 Rounds"; //name of the item
ITEM.Description = [[Adds 30 rounds to your 5.56x45mm ammunition]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_VERYCOMMON;
ITEM.Model		 = "models/Items/combine_rifle_cartridge01.mdl";
ITEM.Icon		 = "icons/ar2ammo";

ITEM.OnUse		 = function( pl )
	pl:GiveAmmo( 30, "5.56x45mm" );
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:GetAmmoCount( "5.56x45mm" ) >= 180 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end