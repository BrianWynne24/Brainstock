AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self:SetModel( "models/props/CS_militia/table_shed.mdl" );
	self:SetSolid( SOLID_BBOX );
	self:SetMoveType( MOVETYPE_NONE );
	self:PhysicsInit( SOLID_BBOX );
	self.Removeables = {};
	self.BenchDelay = CurTime() + 1;
	timer.Simple( 0.01, function() self:CreateObjects() end );
end

function ENT:CreateObjects()
	local objects = {};
	objects[ "models/battery/weapons/attachment/cmore.mdl" ] = { offset = Vector( -16, -35, 36 ), angoffset = Angle( 90, 60, 0 ) };
	objects[ "models/weapons/w_dsa_fall.mdl" ] = { offset = Vector( 12, 6, 35 ), angoffset = Angle( 0, -90, 90 ) };
	objects[ "models/props_c17/tools_wrench01a.mdl" ] = { offset = Vector( 0, 20, 35 ), angoffset = Angle( 0, 130, 0 ) };
	objects[ "models/props/de_vostok/wrenchgripper01.mdl" ] = { offset = Vector( 3, 14, 35 ), angoffset = Angle( 0, -45, 0 ) };
	objects[ "models/props/de_vostok/monkeywrench01.mdl" ] = { offset = Vector( -15, 0, 35 ), angoffset = Angle( 0, 0, 0 ) };
	objects[ "models/Items/grenadeAmmo.mdl" ] = { offset = Vector( -13, 36, 38.5 ), angoffset = Angle( 0, 0, 0 ) };
	objects[ "models/weapons/w_pist_usp4.mdl" ] = { offset = Vector( 0, -25, 35 ), angoffset = Angle( 0, -40, 90 ) };
	//objects[ "models/Items/grenadeAmmo.mdl" ] = { offset = Vector( -13, 36, 38 ), angoffset = Angle( 90, 0, 0 ) };
	
	for k, v in pairs( objects ) do
		local mdl = ents.Create( "prop_dynamic" );
		mdl:SetModel( k );
		mdl:SetPos( self:GetPos() + v.offset );
		mdl:SetAngles( self:GetAngles() + v.angoffset );
		mdl:Spawn();
		mdl:SetParent( self );
		//ent:SetCollisionGroup( COLLISION_GROUP_NONE );
		//ent:SetMoveType( MOVETYPE_NONE );
		
		table.insert( self.Removeables, mdl );
	end
end

function ENT:Think()
	if ( self:GetMoveType() != MOVETYPE_NONE ) then
		self:SetMoveType( MOVETYPE_NONE );
	end
end

function ENT:OnRemove()
	for k, v in pairs( self.Removeables ) do
		v:Remove();
	end
end

function ENT:Use( pl )
	if ( CurTime() < self.BenchDelay || !IsValid( pl:GetActiveWeapon() ) ) then return; end
	
	umsg.Start( "Brainstock_Workbench", pl );
	umsg.End();
	self.BenchDelay = CurTime() + 1;
end