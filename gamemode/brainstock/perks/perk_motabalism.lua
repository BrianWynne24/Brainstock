PERK.PrintName	= "Slow Motabalism";
PERK.Description= "You do not have to eat, your enyzmes are super-human";
PERK.Icon		= "";
PERK.Slot		= PERK_DEFENSIVE;

PERK.OnEquip	= function( pl )
	pl:SetHunger( 100 );
end

PERK.OnThink 		= function( pl )
end

PERK.OnHurt		= function( pl, victim )
end

PERK.OnRemove	= function( pl )
end