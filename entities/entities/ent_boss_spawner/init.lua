AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self.bEnabled = true;
	self.nNextThink = 0;
	//self:KeyValue( "maxchildren", 4 );
end

function ENT:Think()
	local zahmbees = #ents.FindByClass( "npc_zombie_hellknight" )
	
	if ( zahmbees >= 1 || CurTime() < self.nNextThink ) then return; end
	
	self:CreateZombie();
	self.nNextThink = CurTime() + 60;
end

function ENT:RemoveZombie( zombie )
end

function ENT:CreateZombie()
	local zombie = ents.Create( "npc_zombie_hellknight" );
	zombie:SetPos( self:GetPos() );
	zombie:Spawn();
	zombie:SetOwner( self );
end