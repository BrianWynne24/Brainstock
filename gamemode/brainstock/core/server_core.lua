
/*=======================================
	Think Functions
========================================*/
function BrainStock.PlayerSprint()
	if ( #player.GetAll() < 1 ) then return; end
	
	for k, v in pairs( player.GetAll() ) do
	
		if ( v:KeyDown( IN_SPEED ) && v:KeyDown( IN_FORWARD ) ) then
			if ( CurTime() >= v.nSprintDelay ) then
				v.nSprintDelay = CurTime() + 1;
				v:AddStamina( 1 );
			end
			
		else
		
			if ( v:GetStamina() <= 0 ) then return; end
			if ( CurTime() >= v.nSprintDelay ) then
				v.nSprintDelay = CurTime() + 0.8;
				v:AddStamina( -1 );
				if ( v:GetStamina() < 0 ) then
					v:SetStamina( 0 );
				end
			end
			
		end
		
	end
end

function BrainStock.PlayerSlide()
	if ( #player.GetAll() <= 0 ) then return; end
	
	for k, v in pairs( player.GetAll() ) do
		if ( v:IsSliding() ) then
			v:DoSlide();
		end
	end
end

function BrainStock.HungerThink()
	if ( !BrainStock.Configuration.HungerMod || BrainStock.Missions.IsServer() ) then return; end
	for k, v in pairs( player.GetAll() ) do
		if ( !IsValid( v ) || !v:IsPlayer() || !v:Alive() || CurTime() < v.nHungerDelay || v:HasPerk( "perk_motabalism" ) ) then return; end
		
		if ( v:GetHunger() > 0 ) then
			v:AddHunger( -1 );
		else
			v:Hint( "You're starving! Try eating some food" );
			v:SetHealth( v:Health() - 2 );
			if ( v:Health() <= 0 ) then
				v:Kill();
			end
		end
		v.nHungerDelay = CurTime() + BrainStock.Configuration.HungerVar;
	end
end

function BrainStock.PlayerPerkThink()
	if ( #player.GetAll() <= 0 ) then return; end
	
	for k, v in pairs( player.GetAll() ) do
		v:PerkThink();
	end
end

//Add BrainStock Think_Function to here
function GM:Think()
	BrainStock.PlayerSprint();
	BrainStock.PlayerSlide();
	BrainStock.HungerThink();
	BrainStock.Missions.Think();
	BrainStock.PlayerPerkThink();
	BrainStock.db.Think();
	BrainStock.Missions.QueueThink();
	BrainStock.db.RecieveMissionData();
end

function BrainStock.SavePointData( class, pos )
	/*local dir = "brainstock/" .. game.GetMap() .. "/" .. class .. ".txt";
	
	//if ( !file.Exists( dir, "DATA" ) ) then file.CreateDir( "brainstock/" .. game.GetMap() ); end
	if ( !file.IsDir( "brainstock/" .. game.GetMap(), "DATA" ) ) then
		file.CreateDir( "brainstock/" .. game.GetMap() );
	end
	
	local tbl = {};
	for k, v in pairs( ents.FindByClass( class ) ) do
		table.insert( tbl, v:GetPos() );
	end
	
	if ( file.Exists( dir, "DATA" ) ) then
		file.Delete( dir );
	end
	
	file.Write( dir, util.TableToJSON( tbl ) );*/
	class = string.gsub( class, "ent_", "" );
	class = string.gsub( class, "_spawner", "" );
	class = class .. "s";
	
	if ( class == "players" ) then
		class = "player";
	elseif ( class == "bosss" ) then
		class = "boss";
	end
	
	local map = tostring( game.GetMap() );
	BrainStock.db.query( "INSERT INTO " .. class .. " (Map,X,Y,Z) VALUES('" .. map .. "'," .. pos.x .. "," .. pos.y .. "," .. pos.z .. ")" );
end

function BrainStock.LoadPointData( class )
	/*local dir = "brainstock/" .. game.GetMap() .. "/" .. class .. ".txt"; 
	
	dir = util.JSONToTable( file.Read( dir, "DATA" ) );
	for k, v in pairs( dir ) do
		local ent = ents.Create( class );
		ent:SetPos( v );
		ent:SetAngles( Angle( 0, 0, 0 ) );
		ent:Spawn();
	end*/
	/*local tbl = BrainStock.SpawnPoints.Items;
	if ( class == "ent_zombie_spawner" ) then
		tbl = BrainStock.SpawnPoints.Zombies;
	elseif ( class == "ent_player_spawner" ) then
		tbl = BrainStock.SpawnPoints.Players;
	elseif ( class == "ent_hellknight_spawner" ) then
		tbl = BrainStock.SpawnPoints.Bosses;
	end*/
	local tbl = {};
	tbl[ "ent_item_spawner" ] = BrainStock.SpawnPoints.Items;
	tbl[ "ent_zombie_spawner" ] = BrainStock.SpawnPoints.Zombies;
	tbl[ "ent_boss_spawner" ] = BrainStock.SpawnPoints.BossZombie;
	tbl[ "ent_player_spawner" ] = BrainStock.SpawnPoints.Players;
	
	for k, v in pairs( tbl[ class ] ) do
		if ( game.GetMap() == v.Map ) then
			local ent = ents.Create( class );
			local x, y, z = v.X, v.Y, v.Z;
			
			ent:SetPos( Vector( x, y, z ) );
			ent:SetAngles( Angle( 0, 0, 0 ) );
			ent:Spawn();
		end
	end
	
	print( "Spawn points loaded from " .. class );
end

function GM:Initialize()
	if ( BrainStock.Missions.IsServer() && game.GetMap() != BrainStock.Missions[ BrainStock.Missions.Current ].Map ) then
		BrainStock.Missions.Current = nil;
		return;
	end
	BrainStock.db.LoadItems();
	BrainStock.db.LoadZombies();
	BrainStock.db.LoadPlayers();
	timer.Simple( 1, function() BrainStock.LoadData.Spawns() end );
	BrainStock.db.LoadShops();
	BrainStock.db.LoadBoss();
end

function GM:InitPostEntity()
	if ( BrainStock.Missions.IsServer() ) then
		BrainStock.Missions.InitPostEntity();
	end
	
	for k, v in pairs( ents.FindByClass( "func_door*" ) ) do
		if ( IsValid(v) ) then
			v:Remove();
		end
	end
end

function GM:PlayerCanPickupWeapon( pl, weapon )
	if ( !string.find( weapon:GetClass(), "bs_weapon_" ) ) then
		return false;
	end
	return true;
end

function BrainStock.Missions.QueueSquad( num, mission )
	if ( !BrainStock.Squads[ num ] || #BrainStock.Squads[ num ] <= 1 || table.HasValue( BrainStock.Missions.Queue, num ) || !BrainStock.Missions[ mission ] ) then return; end
	
	table.insert( BrainStock.Missions.Queue, { squad = num, mission = mission } );
	print( "Squad Enrolled" );
end

function BrainStock.Missions.QueueThink()
	if ( #BrainStock.Missions.Queue <= 0 || CurTime() < BrainStock.Missions.QueueDelay ) then return; end
	
	local squad = BrainStock.Missions.Queue[1].squad;
	local mission = BrainStock.Missions.Queue[1].mission;
	
	if ( #BrainStock.Squads[ squad ] <= 3 || !BrainStock.Missions[ mission ] ) then
		table.remove( BrainStock.Missions.Queue, 1 );
		print( "Squad Removed - not enough players or invalid mission" );
		//BrainStock.Missions.QueueDelay = CurTime() + 1;
		return;
	end
	
	local time =  BrainStock.Missions[ mission ].TimeLimit();
	if ( !time || time <= 0 ) then
		time = 10;
	end
	
	local players = "";
	for k, v in pairs( BrainStock.Squads[ squad ] ) do
		if ( v:IsPlayer() ) then
			players = v:SteamID() .. "," .. players;
			
			timer.Simple( 15, function()
				if ( IsValid(v) ) then
					v:ConCommand( "password bjg" );
					v:ConCommand( "connect " .. BrainStock.Configuration.MISSION_ServerIP );
				end
			end );
			
		end
	end
	
	players = string.sub( players, 1, -2 );
	BrainStock.db.UpdateMissionData( mission, players );
	
	print( "Squad Accepted" );
	
	table.remove( BrainStock.Missions.Queue, 1 );
	BrainStock.Missions.QueueDelay = CurTime() + 5//(time*60);
end

function BrainStock.Missions.SaveMapReload( mission, players )
	mission = tostring(mission);
	players = tostring(players);
	
	local txt = "brainstock/mission.txt";
	local plytxt = "brainstock/players.txt";
	
	if ( file.Exists( txt, "DATA" ) ) then
		file.Delete( txt );
	end
	if ( file.Exists( plytxt, "DATA" ) ) then
		file.Delete( plytxt );
	end
	
	if ( !file.IsDir( "brainstock", "DATA" ) ) then
		file.CreateDir( "brainstock" );
	end
	
	file.Write( txt, mission );
	file.Write( plytxt, players );
	RunConsoleCommand( "changelevel", BrainStock.Missions[ mission ].Map );
end

function BrainStock.FindPlayer( name )
	name = string.lower( name );
	
	for k, v in pairs( player.GetAll() ) do
		if ( string.find( string.lower(v:Name()), name ) ) then
			return v;
		end
	end
	return nil;
end