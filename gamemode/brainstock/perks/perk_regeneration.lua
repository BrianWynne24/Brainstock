PERK.PrintName	= "Regeneration";
PERK.Description= "While out of combat, you regenerate health over time";
PERK.Icon		= "";
PERK.Slot		= PERK_DEFENSIVE;

PERK.OnEquip	= function( pl )
	pl.RegenTimeDelay = CurTime() + 10;
end

PERK.OnThink 		= function( pl )
	if ( CurTime() < pl.RegenTimeDelay || pl:Health() >= 100 ) then return; end
	
	pl:SetHealth( pl:Health() + 1 );
	pl:EmitSound( "ambient/levels/canals/toxic_slime_gurgle7.wav", 35 );
	pl.RegenTimeDelay = CurTime() + 10;
end

PERK.OnHurt		= function( pl, victim )
	pl.RegenTimeDelay = CurTime() + 15;
end

PERK.OnRemove	= function( pl )
	pl.RegenTimeDelay = nil;
end