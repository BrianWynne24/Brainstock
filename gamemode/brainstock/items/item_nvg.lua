ITEM.PrintName	 = "Nightvision Goggles"; //name of the item
ITEM.Description = [[I can see in darker places]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_MAXRARE;
ITEM.Model		 = "models/props_junk/cardboard_box004a.mdl";
ITEM.Icon		 = "icons/nightvision";

ITEM.OnUse		 = function( pl )
	pl:UseNightvision();
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return true;
end

ITEM.OnDropped		= function( pl )
	pl:UseNightvision();
end