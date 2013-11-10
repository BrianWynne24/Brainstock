AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self.bEnabled = true;
	self.nNextThink = 0;
	
	self.ZombieList = {};
end

function ENT:PlayerAround()
	if ( #player.GetAll() <= 0 ) then return false; end
	
	if ( !BrainStock.Missions.IsServer() ) then
		for k, pl in pairs( player.GetAll() ) do
			local dist = self:GetPos():Distance( pl:GetPos() );
			if ( pl:Alive() && (dist <= 1200) ) then
				return true;
			end
		end
		//return true;
		return false;
	else
		for k, pl in pairs( player.GetAll() ) do
			local pos = pl:GetPos();
			local min_dist, max_dist = BrainStock.Missions[ BrainStock.Missions.Current ].ZSpawnDist( 1 ), BrainStock.Missions[ BrainStock.Missions.Current ].ZSpawnDist( 2 );
			if ( pl:Alive() && (pos:Distance( self:GetPos() ) >= min_dist && pos:Distance( self:GetPos() ) <= max_dist ) ) then
				return false;
			end
			return true;
		end
	end
end

function ENT:Think()
	local limit = #player.GetAll()*6;
	limit = math.Clamp( limit, 6, BrainStock.Configuration.ZombieLimit );
	
	if ( #ents.FindByClass( "npc_zombie_fast" ) >= limit || CurTime() < self.nNextThink || self:PlayerAround() || #self.ZombieList >= 3 || BrainStock.Missions.bEnd ) then return; end
	
	local Z = {}
		if ( !BrainStock.Missions.IsServer() ) then
			Z[ 1 ] = "npc_zombie_fast";
		else
			local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
			for k, v in pairs( mission.Zombies() ) do
				Z[ k ] = v;
			end
		end
		
	/*if ( BrainStock.Missions.IsServer() ) then
		Z = Z[1];
	end*/
	
	self:CreateZombie( Z[math.random( 1, #Z )] )

	local delay = (#self.ZombieList*10);
	if ( BrainStock.Missions.IsServer() ) then
		delay = 3.4;
	end
	self.nNextThink = CurTime() + delay;
end

function ENT:RemoveZombie( zombie )
	//if ( !IsValid( zombie ) ) then return; end
	
	for k, v in pairs( self.ZombieList ) do
		if ( v == zombie ) then
			table.remove( self.ZombieList, k );
			break;
		end
	end
end

function ENT:CreateZombie( class )
	local zombie = ents.Create( class );
	zombie:SetPos( self:GetPos() );
	zombie:Spawn();
	zombie:DropToFloor();
	zombie:SetOwner( self );
	//zombie:SetColor( Color(255, 255, 255, 1) );
	if ( !BrainStock.Missions.IsServer() ) then
		table.insert( self.ZombieList, zombie );
	end
end