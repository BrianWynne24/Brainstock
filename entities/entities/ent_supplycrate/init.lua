AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/items/item_item_crate.mdl" );
	self:SetSolid( SOLID_NONE );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:Activate();
	
	local phys = self:GetPhysicsObject();
	if( phys:IsValid() ) then phys:Wake(); end
end

function ENT:Use( pl )
	if ( !IsValid( pl ) || !pl:Alive() || pl:HasWeapon( "bs_weapon_crate" ) ) then return; end
	
	pl:Give( "bs_weapon_crate" );
	pl:SelectWeapon( "bs_weapon_crate" );
	
	self:Remove();
end