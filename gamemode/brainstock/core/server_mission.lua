
function BrainStock.Missions.OnPlayerInitialSpawn( pl )
	if ( !table.HasValue( BrainStock.Missions.AllowedPlayers, pl:SteamID() ) ) then
		pl:Kick();
		return;
	end
	
	pl:Spectate( OBS_MODE_ROAMING );
	pl:SetMoveType( MOVETYPE_OBSERVER );
	pl:GodEnable();
	pl:Freeze( true );
	pl:SetNoTarget( true );
	pl:DrawViewModel( false );
	
	pl.nSpectatePlayer = 1;
	
	local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
	if ( !mission ) then return; end
	
	if ( mission.Category == MISSION_CATEGORY_DEFEND ) then
		pl.fKillDelay = 0;
	end
end

function BrainStock.Missions.OnPlayerSpawn( pl )
	pl:GodDisable();
	pl:UnSpectate();
	pl:SetMoveType( MOVETYPE_WALK );
	pl:SetNoTarget( false );
	pl:Freeze( false );
	pl:DrawViewModel( true );
	pl:SetCollisionGroup( COLLISION_GROUP_WEAPON );
	pl:SetArmor( 100 );
	
	local spawn = ents.FindByClass( "ent_missionspawn" );
	spawn = table.Random( spawn );
	
	pl:SetPos( spawn:GetPos() );
	pl:Give( "bs_weapon_remington" );
	pl:GiveAmmo( 7*12, "Buckshot" );
	
	local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
	mission.OnStart( pl );
	//local track = math.random( 1, 2 );
	//pl:EmitSound( "brainstock/music/track" .. track .. ".mp3" );
	//pl:LoadPlayerData();
end

function BrainStock.Missions.DoPlayerDeath( pl, attacker, dmginfo )
	local ent = attacker;
	if ( !IsValid( attacker ) ) then
		ent = player.GetByID(1);
	end
	
	pl:SetMoveType( MOVETYPE_OBSERVER );
	pl:Spectate( OBS_MODE_CHASE );
	//pl:SpectateEntity( attacker );
	
	BrainStock.Missions.DeadPlayers[ pl ] = true;
end

function BrainStock.Missions.PlayerDeathThink( pl )
	/*if ( pl:KeyPressed( IN_ATTACK ) ) then
		pl.nSpectatePlayer = pl.nSpectatePlayer + 1;
	elseif ( pl:KeyPressed( IN_ATTACK2 ) ) then
		pl.nSpectatePlayer = pl.nSpectatePlayer - 1;
	end
	if ( !player.GetByID(pl.nSpectatePlayer):IsPlayer() ) then
		pl.nSpectatePlayer = pl.nSpectatePlayer + 1;
		if ( pl.nSpectatePlayer > #player.GetAll() ) then
			pl.nSpectatePlayer = 1;
		elseif ( pl.nSpectatePlayer < 1 ) then
			pl.nSpectatePlayer = #player.GetAll();
		end
		return;
	end
	if ( pl.nSpectatePlayer > #player.GetAll() ) then 
		pl.nSpectatePlayer = 1;
	elseif ( pl.nSpectatePlayer < 1 ) then
		pl.nSpectatePlayer = #player.GetAll();
	end
	for k, v in pairs( player.GetAll() ) do
		if ( k == pl.nSpectatePlayer ) then
			pl.nSpectatePlayer = v;
			break;
		end
	end
	
	if ( !pl.nSpectatePlayer:IsPlayer() ) then return; end
	pl:SpectateEntity( pl.nSpectatePlayer );*/
end

function BrainStock.Missions.InitPostEntity()
	local mission = BrainStock.Missions.Current;
	mission = BrainStock.Missions[ mission ];
	
	mission.Setup();
	
	SetGlobalInt( "Mission_OBJ", 0 );
	
	if ( mission.TimeLimit() > 0 ) then
		BrainStock.Missions.nTimeDelay = CurTime() + 1;
		SetGlobalInt( "Mission_OBJ", (mission.TimeLimit()*60) );
	end
	
	//Now remove doors
	for k, v in pairs( ents.GetAll() ) do
		if ( IsValid( v ) && string.find( v:GetClass(), "door" ) ) then
			//if ( BrainStock.Missions[ BrainStock.Missions.Current ].InitDoors == "lock" ) then
				v:Fire( "lock", "", 0 );
			//else
			//	v:Remove();
			//end
		end
	end
end

function BrainStock.Missions.Think()
	if ( !BrainStock.Missions.IsServer() ) then return; end
	
	local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
	mission.Think();
	
	if ( BrainStock.Missions.AllPlayersDead() ) then
		BrainStock.Missions.End( 1 );
	end
	
	if ( mission.Category != MISSION_CATEGORY_DEFEND ) then return; end
	if ( !BrainStock.Missions.nTimeDelay ) then BrainStock.Missions.nTimeDelay = 0; end
	
	if ( GetGlobalInt( "Mission_OBJ" ) > 0 && CurTime() > BrainStock.Missions.nTimeDelay/*&& BrainStock.Missions.AllPlayersReady()*/ ) then
		SetGlobalInt( "Mission_OBJ", GetGlobalInt( "Mission_OBJ" ) - 1 );
		if ( GetGlobalInt( "Mission_OBJ" ) < 1 ) then
			BrainStock.Missions.End( 2 );
		end
		BrainStock.Missions.nTimeDelay = CurTime() + 1;
	end
	
	for k, pl in pairs( player.GetAll() ) do
		if ( pl.nKillTime && pl.nKillTime > 0 && CurTime() > pl.fKillDelay && pl:Alive() ) then
			pl.nKillTime = pl.nKillTime - 1;
			net.Start( "bs_mKillTime" );
				net.WriteInt( tonumber( pl.nKillTime ), 8 );
			net.Send( pl );
			if ( pl.nKillTime < 1 ) then
				pl:Kill();
				pl.nKillTime = nil;
			end
			pl.fKillDelay = CurTime() + 1;
		end
	end
end

//Calling functions
function BrainStock.Missions.AllPlayersReady()
	if ( table.Count( BrainStock.Missions.ReadyPlayers ) >= #player.GetAll() && #player.GetAll() > 0 ) then
		return true;
	end
	return false;
end

function BrainStock.Missions.AllPlayersDead()
	if ( table.Count( BrainStock.Missions.DeadPlayers ) >= #player.GetAll() && #player.GetAll() > 0 ) then
		return true;
	end
	return false;
end

function BrainStock.Missions.End( num )

	if ( BrainStock.Missions.bEnd ) then return; end
	
	BrainStock.Missions.bEnd = true;
	//BrainStock.Configuration.ZombieLimit = 0;
	
	for k, pl in pairs( player.GetAll() ) do
		pl:SetMoveType( MOVETYPE_NONE );
		//pl:Spectate( OBS_MODE_ROAMING );
		pl:Freeze( true );
		pl:StripWeapons();
		pl:GodEnable();
		//pl:SetPos( ents.FindByClass( "ent_lo_camera" )[ 1 ]:GetPos() );
		//pl:SetAngles( ents.FindByClass( "ent_lo_camera" )[ 1 ]:GetAngles() );
	end
	
	for k, zombie in pairs( ents.FindByClass( "npc_zombie_*" ) ) do
		zombie:Remove();
	end
	
	net.Start( "bs_misEnd" );
		net.WriteInt( num, 4 );
	net.Broadcast();
	
	//BrainStock.db.query( "UPDATE missiondata SET Sent = 3" );
	BrainStock.db.query( "TRUNCATE TABLE missiondata" );
	
	timer.Simple( 15, function() RunConsoleCommand( "changelevel", "gm_construct" ) end );
	
	local txt = "brainstock/mission.txt";
	local plytxt = "brainstock/players.txt";
	if ( file.Exists( txt, "DATA" ) ) then
		file.Delete( txt );
	end
	if ( file.Exists( plytxt, "DATA" ) ) then
		file.Delete( plytxt );
	end
end