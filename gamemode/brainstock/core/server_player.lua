
function GM:PlayerSpawn( pl )
	pl:OnPlayerSetup();
	if ( BrainStock.Missions.IsServer() ) then
		BrainStock.Missions.OnPlayerSpawn( pl );
	end
end

function GM:PlayerInitialSpawn( pl )
	pl:OnPlayerInitSetup();
	if ( BrainStock.Missions.IsServer() ) then
		BrainStock.Missions.OnPlayerInitialSpawn( pl );
	end
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	pl:RemoveFlashlight();
	pl:RemovePerks();
	pl:RemoveNightvision();
	if ( BrainStock.Missions.IsServer() ) then
		BrainStock.Missions.DoPlayerDeath( pl, attacker, dmginfo );
	else
		pl.nNextSpawnTime = BrainStock.Configuration.RespawnDelay;
		
		pl:SetMoveType( MOVETYPE_OBSERVER );
		
		//if ( !attacker:IsZombie() ) then
			pl:CreateRagdead();
			//attacker:AddGoodEvil( -15 );
		//else
			//pl:Zombify();
			//pl:Spectate( OBS_MODE_CHASE );
			//pl:SpectateEntity( attacker );
		//end
	end
end

function GM:PlayerDeath( pl, wep, attacker )
	pl:Spectate( OBS_MODE_CHASE );
	pl:SpectateEntity( attacker );
	pl:SetHealth( 0 );
	
	pl:SaveMySQL();
	pl:Save_Inventory();
	pl:Save_Weapons();
	pl:Save_Position();
	
	if ( pl == attacker ) then return; end
	
	local name = ""
	if ( string.find( attacker:GetClass(), "npc_zombie") ) then
		name = "Zombie";
	elseif ( attacker:IsPlayer() ) then
		name = attacker:Name();
	else
		name = "Natural Selection";
	end
	
	net.Start( "bs_KillIcon" );
		net.WriteString( pl:Name() );
		net.WriteString( name );
	net.Broadcast();
end

function GM:PlayerDeathThink( pl )
	if ( BrainStock.Missions.IsServer() ) then
		BrainStock.Missions.PlayerDeathThink( pl );
	else
		if ( CurTime() < pl.fRespawnDelay || pl.nNextSpawnTime < 1 ) then return; end
		pl.nNextSpawnTime = pl.nNextSpawnTime - 1;
		net.Start( "bs_ResTime" );
			net.WriteInt( pl.nNextSpawnTime, 8 );
		net.Send( pl );
		pl.fRespawnDelay = CurTime() + 1;
	end
end

function GM:EntityTakeDamage( ent, dmginfo )
	if ( BrainStock.Missions.IsServer() ) then
		if ( !string.find( ent:GetClass(), "npc_zombie_" ) /*ent:IsPlayer() && dmginfo:IsBulletDamage()*/ ) then //Was shot by a friendly player
			dmginfo:ScaleDamage( 0 );
		end
	else 
		local attacker = dmginfo:GetInflictor() or nil;
		if ( IsValid( attacker ) && ent:IsPlayer() && attacker:IsPlayer() && (attacker:InMySquad( ent ) || attacker:InSafezone()) ) then
			dmginfo:ScaleDamage( 0.0 );
		elseif ( string.find( ent:GetClass(), "npc_zombie_" ) ) then //Was shot by a friendly player
			dmginfo:ScaleDamage( 1.8 );
		end
	end
	
	//if ( ent:IsPlayer() && ent:HasPerk
end

function GM:OnNPCKilled( npc, pl, weapon )
	//pl:Hint( "You can kill a zombie before he alerts his friends" );
	for k, v in pairs( BrainStock.Achievements ) do
		if ( pl.Achievements && !table.HasValue( pl.Achievements, k ) ) then
			BrainStock.Achievements[ k ].OnNPCKill( pl, npc, weapon );
		end
	end
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )
	if ( hitgroup == HITGROUP_HEAD ) then
		npc:OnKilled();
	end
end

function GM:KeyPress( pl, key )
	if ( !pl:Alive() && pl.nNextSpawnTime < 1 && key == IN_ATTACK && !BrainStock.Missions.IsServer() ) then
		pl:UnSpectate();
		pl:Spawn();
	end
	
	if ( pl:KeyDown( IN_BACK ) ) then
		pl:SetWalkSpeed( pl.nWalkSpeed / 2.2 );
		pl:SetRunSpeed( pl.nWalkSpeed / 2.2 );
	elseif ( pl:KeyDown( IN_FORWARD ) ) then
		if ( !pl:InIronsights() ) then
			pl:SetWalkSpeed( pl.nWalkSpeed );
			pl:SetRunSpeed( pl.nRunSpeed );
		else
			pl:SetWalkSpeed( BrainStock.Configuration.WalkSpeed - 40 );
		end
	elseif ( key == IN_SPEED && (pl:KeyDown(IN_MOVELEFT) || pl:KeyDown(IN_MOVERIGHT)) ) then
		pl:SetWalkSpeed( pl.nWalkSpeed );
		pl:SetRunSpeed( pl.nWalkSpeed );
	end
	
	if ( key == IN_DUCK && pl:InSprint() && !pl:IsSliding() && !pl:LookingAtWall() && pl:OnGround() ) then
		pl:ConCommand( "-duck" );
		pl:ConCommand( "-jump" );
		pl:Slide();
	end
	
	if ( key == IN_USE && pl:Alive() ) then
		local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 64, pl );
		
		if ( IsValid( tr.Entity ) && tr.Entity.Inventory && !tr.Entity:IsPlayer() ) then
			pl:OpenLootMenu( tr.Entity );
		end
	end
	
	if ( key == IN_FORWARD ) then
		pl:Hint( "First things first. Lets look for some items" );
	end
end

function GM:KeyRelease( pl, key )
	if ( !pl:Alive() ) then return; end
	
	if ( key == IN_FORWARD && pl:KeyDown( IN_SPEED ) ) then
		pl:SetWalkSpeed( pl.nWalkSpeed );
		pl:SetRunSpeed( pl.nWalkSpeed );
	elseif ( key == IN_BACK ) then
		pl:SetWalkSpeed( pl.nWalkSpeed );
		pl:SetRunSpeed( pl.nRunSpeed );
		if ( pl:InIronsights() ) then
			pl:SetWalkSpeed( BrainStock.Configuration.WalkSpeed - 40 );
		end
	elseif ( key == IN_ATTACK2 && pl:KeyDown( IN_BACK ) ) then
		pl:SetWalkSpeed( pl.nWalkSpeed / 2.2 );
		pl:SetRunSpeed( pl.nWalkSpeed / 2.2 );
	end
end

function GM:PlayerDisconnected( pl )
	pl:SaveAll();
	pl:LeaveSquad();
end

function GM:ShowHelp( pl )
	//if ( BrainStock.Missions.IsServer() || !pl:Alive() ) then return; end
	
	//umsg.Start( "Brainstock_Inventory", pl );
	//umsg.End();
end

function GM:PlayerHurt( pl, attacker, hpremain, dmgtaken )
	if ( !pl.Perks || #pl.Perks <= 0 ) then return; end
	
	for k, v in pairs( pl.Perks ) do
		BrainStock.Perks[ pl.Perks[ k ] ].OnHurt( pl, attacker, hpremain, dmgtaken );
	end
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if ( talker:InMySquad( listener ) ) then
		return true, false;
	elseif ( listener:GetPos():Distance( talker:GetPos() ) > (BrainStock.Configuration.SpotStand*2) ) then
		return false, false;
	end
	return true, true;
end