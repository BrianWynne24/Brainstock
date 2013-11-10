ITEM.PrintName	 = "Flashlight"; //name of the item
ITEM.Description = [[I can see in dark places]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_COMMON;
ITEM.Model		 = "models/flashlight/flashlight.mdl";
ITEM.Icon		 = "icons/flashlight";

ITEM.OnUse		 = function( pl )
	pl:FlashlightToggle();
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return true;
end

ITEM.OnDropped		= function( pl )
	pl:RemoveFlashlight();
end