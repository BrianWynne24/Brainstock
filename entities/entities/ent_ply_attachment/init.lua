AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:DrawShadow( false );
	self:SetModel( "models/props_c17/oildrum001_explosive.mdl" );
	//self:SetMoveType( MOVETYPE_NONE );
	//self:PhysicsInit( SOLID_NONE );
	//self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	//self:SetSolid( SOLID_NONE );
	self.CreateTime = CurTime();
end

function ENT:OnRemove()
end

function ENT:Think()
	if ( CurTime() > self.CreateTime+2 && (!IsValid( self:GetOwner() ) || !self:GetOwner():IsPlayer()) ) then
		self:Remove();
	end
end

function ENT:SetupDataTables()
	self:DTVar( "Vector", 0, "OffsetPos" );
	self:DTVar( "Angle", 0, "OffsetAng" );
	self:DTVar( "String", 0, "Attaching" );
end