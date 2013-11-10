ITEM.PrintName	 = "Riot Helmet"; //name of the item
ITEM.Description = [[For all of your rifle needs]]; //Description of the item, what it does
ITEM.Slot		 = ITEM_SLOT_NULL;
ITEM.Rarity		 = ITEM_RARE;
ITEM.Model		 = "models/bloocobalt/l4d/riot_helmet.mdl";
ITEM.Icon		 = "icons/riothelmet";

ITEM.OnPickup	 = function( pl )
end

ITEM.OnUse		 = function( pl )
	pl:AddAccessory( "object_riothelmet" );
end

ITEM.CanUseItem	  = function( pl )
	return true;
end

ITEM.DontRemoveOnUse	= function()
	return false;
end