AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/bloocobalt/l4d/items/w_eq_ammopack.mdl" );
	//self:SetSkin( 1 );
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
	if ( !IsValid( pl ) || !pl:Alive() ) then return; end
	
	for k, v in pairs( pl:GetWeapons() ) do
		if ( v.AmmoType && v.HoldType ) then
			local ammo = 90;
			if ( v.HoldType == "pistol" ) then
				ammo = 120;
			end
			pl:AddAmmoType( v.AmmoType, ammo );
		end
	end
	self:EmitSound( "physics/metal/weapon_footstep" .. math.random( 1, 2 ) .. ".wav" );
	self:Remove();
end