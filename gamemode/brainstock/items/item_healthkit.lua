ITEM.PrintName	 = "Medical Kit"; //name of the item
ITEM.Description = [[A Medic-kit that for 50HP]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/Items/HealthKit.mdl";
ITEM.Icon		 = "icons/medickit";

ITEM.OnUse		 = function( pl )
	pl:SetHealth( pl:Health() + 50 );
	if ( pl:Health() > 100 ) then
		pl:SetHealth( 100 );
	end
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:Health() >= 100 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end