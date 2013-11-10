AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	//self.SpawnAngles = Angle( 0, 0, 0 );
end

/*function ENT:SetAngles( ang )
	self.SpawnAngles = ang;
end

function ENT:GetAngles()
	return self.SpawnAngles;
end*/

function ENT:Think()
end