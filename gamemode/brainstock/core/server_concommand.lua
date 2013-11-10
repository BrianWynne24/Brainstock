
function BrainStock.cc.SelectWeapon( pl, cmd, args )
	pl:SelectWeapon( args[ 1 ] );
end
concommand.Add( "bs_selectweapon", BrainStock.cc.SelectWeapon );

function BrainStock.cc.AddItemSpawn( pl )
	if ( !BrainStock.Configuration.Debug ) then return; end
	
	local ent = ents.Create( "ent_item_spawner" );
	ent:SetPos( pl:GetShootPos() );
	ent:SetAngles( Angle( 0, 0, 0 ) );
	ent:Spawn();
	
	BrainStock.SavePointData( "ent_item_spawner", pl:GetShootPos() );
end
concommand.Add( "bs_create_ispawn", BrainStock.cc.AddItemSpawn );

function BrainStock.cc.AddZombieSpawn( pl )
	if ( !BrainStock.Configuration.Debug ) then return; end
	
	local ent = ents.Create( "ent_zombie_spawner" );
	ent:SetPos( pl:GetShootPos() );
	ent:SetAngles( Angle( 0, 0, 0 ) );
	ent:Spawn();
	
	BrainStock.SavePointData( "ent_zombie_spawner", pl:GetShootPos() );
end
concommand.Add( "bs_create_zspawn", BrainStock.cc.AddZombieSpawn );

function BrainStock.cc.AddPlayerSpawn( pl )
	if ( !BrainStock.Configuration.Debug ) then return; end
	
	local ent = ents.Create( "ent_player_spawner" );
	ent:SetPos( pl:GetPos() );
	ent:SetAngles( Angle( 0, 0, 0 ) );
	ent:Spawn();
	
	BrainStock.SavePointData( "ent_player_spawner", pl:GetPos() );
end
concommand.Add( "bs_create_pspawn", BrainStock.cc.AddPlayerSpawn );

function BrainStock.cc.AddBossSpawn( pl )
	if ( !BrainStock.Configuration.Debug ) then return; end
	
	local ent = ents.Create( "ent_boss_spawner" );
	ent:SetPos( pl:GetPos() );
	ent:SetAngles( Angle( 0, 0, 0 ) );
	ent:Spawn();
	
	BrainStock.SavePointData( "ent_boss_spawner", pl:GetPos() );
end
concommand.Add( "bs_create_boss", BrainStock.cc.AddBossSpawn );

function BrainStock.cc.LoadPoints( pl, cmd, args )
	if ( !BrainStock.Configuration.Debug ) then return; end
	
	local class = tostring( args[1] );
	BrainStock.LoadPointData( class );
end
concommand.Add( "bs_loadspawns", BrainStock.cc.LoadPoints );

function BrainStock.cc.GetPosition( pl )
	local x, y, z = pl:GetPos().x, pl:GetPos().y, pl:GetPos().z;
	
	local pos = "Vector( " .. tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z) .. " )";
	print( pos );
end
concommand.Add( "bs_getpos", BrainStock.cc.GetPosition );

function BrainStock.cc.AddSquadMember( pl, cmd, args )
	local name = args[ 1 ];
	local ply = nil;
	//local count = 0;
	name = string.lower( name );
	
	for k, v in pairs( player.GetAll() ) do
		local nick = tostring( v:Name() );
		if ( string.find( string.lower( nick ), name ) ) then
			ply = v;
		end
	end
	
	if ( IsValid( ply ) && ply:IsPlayer() ) then
		pl:AddPlayerToSquad( ply );
	end
end
concommand.Add( "bs_squad_invite", BrainStock.cc.AddSquadMember );

function BrainStock.cc.LeaveSquad( pl )
	pl:LeaveSquad();
end
concommand.Add( "bs_squad_leave", BrainStock.cc.LeaveSquad );

function BrainStock.cc.SquadMission( pl, cmd, args )
	if ( !pl:InSquad() ) then return; end
	
	local mission = tostring( args[1] );
	BrainStock.Missions.QueueSquad( pl:InSquad(), mission );
end
concommand.Add( "bs_squad_mission", BrainStock.cc.SquadMission );

function BrainStock.cc.JoinIn( pl )
	if ( BrainStock.Missions.IsServer() || pl:GetObserverMode() == OBS_MODE_NONE || pl.nNextSpawnTime > 0 ) then return; end
	
	pl:UnSpectate();
	pl:Spawn();
end
concommand.Add( "bs_joingame", BrainStock.cc.JoinIn );

function BrainStock.cc.InvUse( pl, cmd, args )
	local item = args[ 1 ];
	local item = args[ 1 ];
	local slot = args[ 2 ];
	
	item = tostring( item );
	slot = tonumber( slot );
	
	pl:OnItemUse( item, slot );
end
concommand.Add( "bs_invuse", BrainStock.cc.InvUse );

function BrainStock.cc.InvDrop( pl, cmd, args )
	local item = args[ 1 ];
	local slot = args[ 2 ];
	
	item = tostring( item );
	slot = tonumber( slot );
	
	pl:OnItemDropped( item, slot );
end
concommand.Add( "bs_invdrop", BrainStock.cc.InvDrop );

function BrainStock.cc.Noclip( pl ) //Got damn tired of walking everywhere
	//if ( !BrainStock.Configuration.Debug ) then return; end
	if ( pl:GetMoveType() == MOVETYPE_NOCLIP ) then
		pl:SetMoveType( MOVETYPE_WALK );
	else
		pl:SetMoveType( MOVETYPE_NOCLIP );
	end
end
concommand.Add( "bs_noclip", BrainStock.cc.Noclip );

function BrainStock.cc.CreateItem( pl, cmd, args )
	local item, amt = args[ 1 ], args[ 2 ];
	item, amt = tostring( item ), tonumber( amt );
	
	if ( !BrainStock.Items[ item ] ) then
		pl:PrintMessage( 1, item .. " is an invalid item" );
		return;
	end
	
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector() * 64, pl );
	
	local ent = ents.Create( "ent_item" );
	ent:SetPos( tr.HitPos );
	ent:SetAngles( pl:GetAngles() );
	ent:Spawn();
	ent:Activate();
	ent:SetModel( BrainStock.Items[ item ].Model );
	
	ent.Class = item;
end
concommand.Add( "bs_createitem", BrainStock.cc.CreateItem );

function BrainStock.cc.Flashlight( pl )
	pl:FlashlightToggle();
end
concommand.Add( "bs_flashlight", BrainStock.cc.Flashlight );

function BrainStock.cc.Nightvision( pl )
	pl:UseNightvision();
end
concommand.Add( "bs_nightvision", BrainStock.cc.Nightvision );

function BrainStock.cc.LootAdd( pl, cmd, args ) //Adds loot FROM the *dead body* TO the *player*
	local item = args[ 1 ];
	local slot = args[ 2 ];
	item = tostring( item );
	slot = tonumber( slot );
	
	local ent = pl:IsLooting();
	if ( !ent ) then return; end
	
	if ( ent.Inventory && table.HasValue( ent.Inventory, item ) && ent.Inventory[ slot ] == item ) then
		local pickup = BrainStock.Items[ item ];
		
		pl:OnItemPickup( pickup );
		
		ent.Inventory[ slot ] = nil;
		pl:UpdateLoot( ent, item );
	end
end
concommand.Add( "bs_lootadd", BrainStock.cc.LootAdd );

function BrainStock.cc.LootRemove( pl, cmd, args )
	local item = args[ 1 ];
	local slot = args[ 2 ];
	item = tostring( item );
	slot = tonumber( slot );
	
	local ent = pl:IsLooting();
	if ( !ent ) then return; end
	
	if ( ent.Inventory && table.Count(ent.Inventory) < BrainStock.Configuration.InventorySlots && pl.Inventory ) then
		//pl.Inventory[ slot ] = nil;
		
		for i = 1, BrainStock.Configuration.InventorySlots do
			if ( !ent.Inventory[i] ) then
				ent.Inventory[ i ] = item;
				break;
			end
		end
		
		pl:OnRemoveItem( item, slot );
		pl:UpdateLoot( ent, item );
	end
end
concommand.Add( "bs_lootrem", BrainStock.cc.LootRemove );

function BrainStock.cc.WeaponUpgrade( pl, cmd, args )
	//local wep = tostring( args[1] );
	local weapon = pl:GetActiveWeapon();
	local type = tostring( args[1] );
	
	if ( !IsValid( weapon ) || !BrainStock.WeaponUpgrades[ weapon:GetClass() ] || !BrainStock.WeaponUpgrades[ weapon:GetClass() ][ type ] ) then return; end
	pl:UpgradeWeapon( weapon:GetClass(), type );
end
concommand.Add( "bs_weapon_upgrade", BrainStock.cc.WeaponUpgrade );

function BrainStock.cc.SetTitle( pl, cmd, args )
	args[1] = tostring( args[1] );
	local title = args[1];
	
	pl:SetTitle( title );
end
concommand.Add( "bs_settitle", BrainStock.cc.SetTitle );

function BrainStock.cc.AddTitlePlayer( pl, cmd, args )
	local name = tostring( args[1] );
	local title = tostring( args[2] );
	
	name = BrainStock.FindPlayer( name );
	if ( !name ) then
		pl:PrintMessage( 1, "No player found" );
		return;
	end
	
	name:AddTitle( title );
	name:PrintMessage( 3, "You have been given a title by " .. pl:Name() );
end
concommand.Add( "bs_addtitle", BrainStock.cc.AddTitlePlayer );