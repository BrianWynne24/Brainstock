AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self.nNextSpawn = 0;
end

function ENT:SpawnPlayer()
	self.nNextSpawn = CurTime() + 340;
end

function ENT:CanRespawn()
	if ( CurTime() < self.nNextSpawn ) then
		return false;
	end
	return true;
end

/*function ENT:OnRemove()
	BrainStock.Items.Spawned[ self.Rarity ] = BrainStock.Items.Spawned[ self.Rarity ] - 1;
	self:SetOwner( nil );
end*/