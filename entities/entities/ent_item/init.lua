AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/Items/HealthKit.mdl" );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:Activate();
	
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then phys:Wake(); phys:EnableMotion( true ); end
end

function ENT:Use( pl )
	/*if ( self:GetMoveType() != MOVETYPE_VPHYSICS ) then
		self:SetMoveType( MOVETYPE_VPHYSICS );
	end*/
	
	if ( !IsValid( pl ) || !pl:Alive() ) then return; end
	
	pl:OnItemPickup( self );
	
	if ( BrainStock.Items[ self.Class ].OnPickup ) then
		BrainStock.Items[ self.Class ].OnPickup( pl );
	end
end

function ENT:OnRemove()
	if ( !IsValid(self.OtherOwner) || self.OtherOwner:GetClass() != "ent_item_spawner" ) then return; end
	self.OtherOwner:SetMeFree( self );
end

function ENT:SetupDataTables()
	self:DTVar( "String", 0, "itemname" );
	self:DTVar( "Int", 0, "rare" );
end