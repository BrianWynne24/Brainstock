ITEM.PrintName	 = "Watermelon"; //name of the item
ITEM.Description = [[Gives you 25 hunger]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/props_junk/watermelon01.mdl";
ITEM.Icon		 = "icons/melon";

ITEM.OnUse		 = function( pl )
	pl:AddHunger( 20 );
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