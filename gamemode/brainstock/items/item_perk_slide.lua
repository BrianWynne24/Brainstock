ITEM.PrintName	 = "Perk: Power Slide"; //name of the item
ITEM.Description = [[Use to equip this perk]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/Items/combine_rifle_ammo01.mdl";
ITEM.Icon		 = "icons/perk_slide";

ITEM.OnUse		 = function( pl )
	pl:AddPerk( "perk_slide" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end