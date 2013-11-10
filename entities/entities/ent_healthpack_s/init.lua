AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/bloocobalt/l4d/items/w_eq_fieldkit.mdl" );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	self:SetSolid( SOLID_NONE );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:Activate();
	
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then phys:Wake(); end
end

function ENT:Use( pl )
	if ( !IsValid( pl ) || !pl:Alive() || pl:Health() >= 100 ) then return; end
	
	pl:SetHealth( pl:Health() + 40 );
	if ( pl:Health() > 100 ) then
		pl:SetHealth( 100 );
	end
	self:EmitSound( "physics/metal/weapon_footstep" .. math.random( 1, 2 ) .. ".wav" );
	self:Remove();
end