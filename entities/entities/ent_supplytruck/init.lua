AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/props/de_nuke/truck_nuke.mdl" );
	self:SetSolid( SOLID_BBOX );
	self:SetMoveType( MOVETYPE_NONE );
	self:PhysicsInit( SOLID_BBOX );
end

function ENT:AddCrateToTruck()
	local pos, ang = self:GetPos(), self:GetAngles();
	local mul = GetGlobalInt( "Mission_OBJ" );
	
	pos = pos + Vector( 0, 0, 40 );
	pos = pos - (self:GetForward() * 52);
	if ( mul > 2 ) then
		mul = mul - 2;
		pos = pos - (self:GetRight() * 32 );
	end
	pos = pos + (self:GetForward() * (32 * mul));
	ang = ang + Angle( 0, 90, 0 );
	
	local prop = ents.Create( "prop_dynamic" );
	prop:SetModel( "models/items/item_item_crate.mdl" );
	prop:SetPos( pos );
	prop:SetAngles( ang );
	prop:Spawn();
	prop:SetOwner( self );
end

function ENT:Think()
	self:SetMoveType( MOVETYPE_NONE );
	local sphere = ents.FindInSphere( self:GetPos(), 256 );
	for k, v in pairs( sphere ) do
		if ( v:GetClass() == "ent_supplycrate" || (v:IsPlayer() && v:HasWeapon( "bs_weapon_crate" )) ) then
			if ( v:IsPlayer() && v:HasWeapon( "bs_weapon_crate" ) ) then
				v:StripWeapon( "bs_weapon_crate" );
			else
				v:Remove();
			end
			SetGlobalInt( "Mission_OBJ", GetGlobalInt( "Mission_OBJ" ) + 1 );
			self:AddCrateToTruck();
			if ( GetGlobalInt( "Mission_OBJ" ) >= 4 ) then
				BrainStock.Missions.End( 2 );
			end
		end
	end
end

function ENT:OnRemove()
	for k, v in pairs( ents.FindByClass( "prop_dynamic" ) ) do
		if ( v:GetOwner() == self ) then
			v:Remove();
		end
	end
end

function ENT:Use( pl )
	self:Resupply( pl );
end

function ENT:Resupply( pl )
	for k, v in pairs( pl:GetWeapons() ) do
		if ( v.Primary.ClipSize && v.Primary.Ammo ) then
			v.Owner:SetAmmo( v.Primary.ClipSize*8, v.Primary.Ammo );
		end
	end
end