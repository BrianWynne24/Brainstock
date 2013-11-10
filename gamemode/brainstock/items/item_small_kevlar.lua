ITEM.PrintName	 = "Kevlar"; //name of the item
ITEM.Description = [[Adds 15 Armor to your Kevlar]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/items/battery.mdl";
ITEM.Icon		 = "icons/battery";

ITEM.OnUse		 = function( pl )
	pl:SetArmor( pl:Armor() + 15 );
	if ( pl:Armor() > 100 ) then
		pl:SetArmor( 100 );
	end
end

ITEM.CanUseItem	  = function( pl )
	if ( pl:Armor() >= 100 ) then
		return false;
	end
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end