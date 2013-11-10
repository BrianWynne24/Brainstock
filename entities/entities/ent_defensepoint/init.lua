AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/weapons/w_eq_smokegrenade_thrown.mdl" );
	self:SetSolid( SOLID_NONE );
	self:SetMoveType( MOVETYPE_NONE );
	self:PhysicsInit( SOLID_NONE );
	self:SetUseType( SIMPLE_USE );
	
	//CreateSmoke
	self.Smoke = {};
	for i = 1, 25 do
		local rand = math.Rand( -1.2, 1.2 );
		self.Smoke[ i ] = ents.Create( "env_smoketrail" );
		self.Smoke[ i ]:SetPos( self:GetPos() + Vector( rand * i, rand * i, (i*14) ) );
		self.Smoke[ i ]:SetKeyValue( "InitialState", "1" );
		self.Smoke[ i ]:SetKeyValue( "WideAngle", "0 10 0" );
		self.Smoke[ i ]:SetKeyValue( "WideSpeed", "0" );
		self.Smoke[ i ]:SetKeyValue( "StartSize", "20" );
		self.Smoke[ i ]:SetKeyValue( "EndSize", tostring(i*1.6) );
		self.Smoke[ i ]:SetKeyValue( "Speed", "100" );
		//self.Smoke[ i ]:SetKeyValue( "SmokeMaterial", "particle/particle_smokegrenade1.vmt" );
		
		self.Smoke[ i ]:Spawn();
		self.Smoke[ i ]:SetParent( self );
		self.Smoke[ i ]:Activate();
		self.Smoke[ i ]:SetOwner( self );
		
		//self.fSmokeRise[ i ] = 0;
	end
end

function ENT:Use()
end

function ENT:Think()
	for k, pl in pairs( player.GetAll() ) do
		local dist = self:GetPos():Distance( pl:GetPos() );
		if ( dist > 750 ) then
			if ( !pl.nKillTime ) then pl.nKillTime = 16; end
		else
			if ( pl.nKillTime ) then pl.nKillTime = nil; end
			net.Start( "bs_mKillTime" );
				net.WriteInt( 0, 8 );
			net.Send( pl );
		end
	end
	
	/*if ( !self.Smoke || !self.fSmokeRise ) then return; end
	
	if ( self.fSmokeRise < 1 ) then
		self.fSmokeRise = self.fSmokeRise + 1;
	elseif ( self.fSmokeRise > 100 ) then
		self.fSmokeRise = self.fSmokeRise - 1;
	end
	
	local pos = self.Smoke:GetPos();
	self.Smoke:SetPos( pos + Vector( 0, 0, self.fSmokeRise ) );*/
end

function ENT:OnRemove()
	for k, v in pairs( self.Smoke ) do
		v:Remove();
	end
end