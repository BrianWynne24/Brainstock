ITEM.PrintName	 = "Medical Vial"; //name of the item
ITEM.Description = [[Heals for 15HP]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/healthvial.mdl";
ITEM.Icon		 = "icons/healthvial";

ITEM.OnUse		 = function( pl )
	pl:SetHealth( pl:Health() + 15 );
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