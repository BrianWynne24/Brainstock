AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
end

function ENT:StartTouch( pl ) //Added "LoweredWeapon" variable so that it is not constantly sending unnecessary data
	self:Touched( pl, true );
end

function ENT:EndTouch( pl )
	self:Touched( pl, false );
end

function ENT:Touched( pl, bool )
	if ( !IsValid( pl ) || !pl:IsPlayer() ) then return; end
	
	pl.bInSafezone = bool;
	
	if ( bool == true ) then
		pl:SetIronSights( false );
	end
	
	net.Start( "bs_LowerWep" );
		net.WriteBit( bool );
	net.Send( pl );
end

function ENT:Touch( pl )
	if ( pl:IsPlayer() ) then return; end
	pl:Remove();
end
/*function ENT:PassesTriggerFilters( ent )
	return ent:GetClass() == "player";
end*/