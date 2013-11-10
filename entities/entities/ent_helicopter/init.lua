AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/combine_helicopter.mdl" );
	self:SetCollisionGroup( COLLISION_GROUP_NONE );
	self:SetSolid( SOLID_NONE );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	
	self:ResetSequence( self:LookupSequence( "idle" ) );
	
	self.nHoverZ = 0;
	self.nDropDelay = 0;
	//self.bDone	= false;
	
	self.Supplies = {}
		self.Supplies[ 1 ] = "ent_healthpack_s";
		self.Supplies[ 2 ] = "ent_ammopack_s";
end

function ENT:CanDropSupplies()
	local tr = util.QuickTrace( self:GetPos(), self:GetPos() - Vector( 0, 0, 10000 ), { self, "player" } );
	
	local dist = tr.HitPos:Distance( ents.FindByClass( "ent_defensepoint" )[ 1 ]:GetPos() );
	local radius = 700 + (#player.GetAll() * 100);
	
	if ( dist < radius || #self.Supplies < 1 ) then
		timer.Simple( 5, function() if IsValid( self ) then self:Remove() end end );
		return true;
	end
	return false;
end

function ENT:Think()
	local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
	if ( GetGlobalInt( "Mission_OBJ" ) > (mission.TimeLimit()*60)/2 ) then 
		return; 
	end
	
	if ( !self.sSound ) then
		self.sSound = CreateSound( self, Sound("npc/attack_helicopter/aheli_rotor_loop1.wav") );
		self.sSound:Play();
	end
	
	local pos, ang = self:LocalToWorld( self:OBBCenter() ), self:GetAngles();
	//self:SetAngles( Angle( 0, ang.y, 0 ) );
	
	local phys = self:GetPhysicsObject();
	if ( !phys ) then return; end
	
	if ( self.nHoverZ > 75 ) then
		self.nHoverZ = self.nHoverZ - 1;
	elseif ( self.nHoverZ < 58 ) then
		self.nHoverZ = self.nHoverZ + 1;
	end
	
	local hover = math.Clamp( self.nHoverZ, 58, 75 );
	local speed = 1000;
	if ( self:CanDropSupplies() ) then
		speed = 650;
		local random = math.random( 1, table.Count(self.Supplies) );
		
		if ( self.Supplies[ random ] ) then
			local ent = ents.Create( self.Supplies[ random ] );
			ent:SetPos( self:GetPos() - Vector( 0, 0, 55 ) );
			ent:SetAngles( ang );
			ent:Spawn();
			ent:Activate();
			
			local phys = ent:GetPhysicsObject();
			if ( phys ) then
				phys:SetVelocity( self:GetForward() * (speed/3.2) );
			end
			
			if ( #ents.FindByClass( self.Supplies[ random ] ) >= (#player.GetAll()*3) ) then
				table.remove( self.Supplies, random );
			end
		end
	end

	phys:SetVelocity( (self:GetUp() * hover) + (self:GetForward() * speed) );
	//if ( self.bDone ) then
	//	self:Remove();
	//end
end

function ENT:OnRemove()
	if ( self.sSound ) then
		self.sSound:Stop();
		self.sSound = nil;
	end
end

function ENT:StartTouch()
end