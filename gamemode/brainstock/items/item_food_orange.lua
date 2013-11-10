ITEM.PrintName	 = "Orange"; //name of the item
ITEM.Description = [[Gives you 5 hunger]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/props/cs_italy/orange.mdl";
ITEM.Icon		 = "icons/orange";

ITEM.OnUse		 = function( pl )
	pl:AddHunger( 5 );
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:GetHunger() >= 100 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end