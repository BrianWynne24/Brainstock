PERK.PrintName	= "Shield";
PERK.Description= "Will take a small amount of damage for you. Recharges quickly out of combat";
PERK.Icon		= "";
PERK.Slot		= PERK_DEFENSIVE;

PERK.OnEquip	= function( pl )
	pl._shieldrecharge = 0;
	pl._shielddelay = CurTime() + 8;
end

PERK.OnThink 		= function( pl )
	if ( pl:Armor() > 80 ) then
		pl:SetArmor( 80 );
	end
	
	if ( CurTime() < pl._shielddelay || pl._shieldrecharge >= 15 ) then return; end
	pl._shieldrecharge = pl._shieldrecharge + 1;
	pl._shielddelay = CurTime() + 0.1;
	net.Start( "bs_Shield" );
		net.WriteInt( pl._shieldrecharge, 8 );
	net.Send( pl );
end

PERK.OnHurt		= function( pl, attacker, hpremain, dmgtaken )
	if ( dmgtaken >= 50 ) then 
		pl._shieldrecharge = 0;
		pl._shielddelay = CurTime() + 8;
		
		net.Start( "bs_Shield" );
			net.WriteInt( pl._shieldrecharge, 8 );
		net.Send( pl );
		return; 
	end
	
	//local dmg = dmgtaken;
	//dmg = dmg - pl._shieldrecharge;
	pl._shielddelay = CurTime() + 8;
	if ( pl._shieldrecharge <= 0 ) then return; end
	
	pl._shieldrecharge = pl._shieldrecharge - dmgtaken;
	if ( pl._shieldrecharge > 0 ) then
		if ( pl:Armor() <= 0 ) then
			pl:SetHealth( pl:Health() + dmgtaken );
		else
			pl:SetHealth( pl:Health() + math.Round(dmgtaken/3) );
			pl:SetArmor( pl:Armor() + dmgtaken );
		end
	end
	
	net.Start( "bs_Shield" );
		net.WriteInt( pl._shieldrecharge, 8 );
	net.Send( pl );
end

PERK.OnRemove	= function( pl )
	pl._shieldrecharge = nil;
	pl._shielddelay = nil;
end

if ( CLIENT ) then
	PERK.Draw		= function( pl, x, y )
		if ( !pl._shieldrecharge ) then pl._shieldrecharge = 15; end
		local amt = (pl._shieldrecharge/15);
		local fade = math.Clamp( BrainStock.HUD.Fade_Health, 0, 100 );
		
		draw.RoundedBox( 0, x * 0.02, y * 1.73, x * 0.10, y * 0.02, Color( 0, 0, 0, fade/1.2 ) );
		if ( amt <= 0 ) then
			draw.RoundedBox( 0, x * 0.02, y * 1.73, x * 0.10, y * 0.02, Color( 255, 0, 0, fade ) );
		else
			draw.RoundedBox( 0, x * 0.02, y * 1.73, (x * 0.10) * amt, y * 0.02, Color( 255, 255, 255, fade ) );
		end
	end
end