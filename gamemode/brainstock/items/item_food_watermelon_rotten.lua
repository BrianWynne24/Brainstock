ITEM.PrintName	 = "Rotten Watermelon"; //name of the item
ITEM.Description = [[Gives you 15 hunger but takes 10HP]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/props_junk/watermelon01.mdl";
ITEM.Icon		 = "icons/rotten_melon";

ITEM.OnUse		 = function( pl )
	pl:SetHealth( pl:Health() - 10 );
	pl:AddHunger( 15 );
	if ( pl:Health() <= 0 ) then
		pl:Kill();
	end
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