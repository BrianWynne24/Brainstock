require( "mysqloo" );

BrainStock.db.object = nil;

local DATABASE_HOST = BrainStock.Configuration.Host;
local DATABASE_USER = BrainStock.Configuration.User;
local DATABASE_PASS = BrainStock.Configuration.Password;
local DATABASE_DB	= BrainStock.Configuration.Database;
local DATABASE_PORT = BrainStock.Configuration.Port;

function BrainStock.db.connect()
	BrainStock.db.object = mysqloo.connect(DATABASE_HOST, DATABASE_USER, DATABASE_PASS, DATABASE_DB, DATABASE_PORT);
	function BrainStock.db.object:onConnected( db )
		print( ">", "Connection to MySQL Successful" );
		BrainStock.db.Init();
	end
	function BrainStock.db.object:onConnectionFailed( db, err )
		print( ">", "Connection to MySQL Failed" );
		print( err );
		//self:connect();
	end
	BrainStock.db.object:connect();
end

function BrainStock.db.query( query, callback )
	if ( !BrainStock.db.queries ) then BrainStock.db.queries = {}; end
	table.insert( BrainStock.db.queries, { query = query, sent = false, callback = callback } )
end

function BrainStock.db.Init()
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS playerdata (User VARCHAR(25) PRIMARY KEY, Model TINYTEXT, Inventory MEDIUMTEXT, Bank MEDIUMTEXT, Hunger TINYINT, GoodEvil SMALLINT, Health TINYINT, Armor TINYINT, Perks TINYTEXT, Achievements MEDIUMTEXT, Position TINYTEXT, Weapons TEXT, Titles MEDIUMTEXT, Map TINYTEXT, Hints TEXT, Upgrades MEDIUMTEXT, Accessories MEDIUMTEXT)" );
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS zombies (Map TINYTEXT, X DOUBLE, Y DOUBLE, Z DOUBLE)" );
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS boss (Map TINYTEXT, X DOUBLE, Y DOUBLE, Z DOUBLE)" );
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS player (Map TINYTEXT, X DOUBLE, Y DOUBLE, Z DOUBLE)" );
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS items (Map TINYTEXT, X DOUBLE, Y DOUBLE, Z DOUBLE)" );
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS shopsitems (Shopkeep TINYTEXT, Item TINYTEXT, Quantity TINYINT)" );
	BrainStock.db.query( "CREATE TABLE IF NOT EXISTS missiondata (Mission TINYTEXT, Players TEXT, Sent TINYINT)" );
end

function BrainStock.db.Think()
	if ( !BrainStock.db.queries || #BrainStock.db.queries <= 0 ) then return; end
	 
	local query = BrainStock.db.queries[ 1 ];
	if ( !query.sent ) then
		query.sent = true;
		
		local q = BrainStock.db.object:query( query.query );
		if ( q ) then
			function q:onSuccess( data )
				if ( query.callback ) then
					query.callback(data);
				end
				if ( #BrainStock.db.queries > 0 ) then
					table.remove( BrainStock.db.queries, 1 );
				end
			end	
			function q:onError( err )
				print( err );
				if ( #BrainStock.db.queries > 0 ) then
					table.remove( BrainStock.db.queries, 1 );
				end
			end
			q:start();
		else
			if ( #BrainStock.db.queries > 0 ) then
				table.remove( BrainStock.db.queries, 1 );
			end
		end
	end
end

BrainStock.db.connect();

function BrainStock.db.LoadItems()
	local function items( data )
		for k, v in pairs(data) do
			if ( v.Map == game.GetMap() ) then
				table.insert( BrainStock.SpawnPoints.Items, v );
			end
		end
	end
	BrainStock.db.query( "SELECT * FROM items", items );
end

function BrainStock.db.LoadZombies()
	local function zombies( data )
		for k, v in pairs(data) do
			if ( v.Map == game.GetMap() ) then
				table.insert( BrainStock.SpawnPoints.Zombies, v );
			end
		end
	end
	BrainStock.db.query( "SELECT * FROM zombies", zombies ); 
end

function BrainStock.db.LoadZombies()
	local function zombies( data )
		for k, v in pairs(data) do
			if ( v.Map == game.GetMap() ) then
				table.insert( BrainStock.SpawnPoints.Zombies, v );
			end
		end
	end
	BrainStock.db.query( "SELECT * FROM zombies", zombies ); 
end

function BrainStock.db.LoadPlayers()
	local function players( data )
		for k, v in pairs(data) do
			if ( v.Map == game.GetMap() ) then
				table.insert( BrainStock.SpawnPoints.Players, v );
			end
		end
	end
	BrainStock.db.query( "SELECT * FROM player", players ); 
end

function BrainStock.db.LoadShops()
	local function shops( data )
		for k, v in pairs(data) do
			if ( !BrainStock.Shops[ v.Shopkeep ] ) then BrainStock.Shops[ v.Shopkeep ] = {}; end
			table.insert( BrainStock.Shops[ v.Shopkeep ], v );
		end
	end
	BrainStock.db.query( "SELECT * FROM shopsitems", shops ); 
end

function BrainStock.db.LoadBoss()
	local function boss( data )
		for k, v in pairs(data) do
			if ( v.Map == game.GetMap() ) then
				table.insert( BrainStock.SpawnPoints.BossZombie, v );
			end
		end
	end
	BrainStock.db.query( "SELECT * FROM boss", boss ); 
end

function BrainStock.db.LoadMission()
	//if ( !BrainStock.Missions.IsServer() ) then return; end
	local function mission( data )
		if ( !data || #data <= 0 ) then return; end
		if ( game.GetMap() == "gm_construct" ) then
			BrainStock.Missions.SaveMapReload( data[1].Mission, data[1].Players );
			BrainStock.db.query( "UPDATE missiondata SET Sent = 2" );
			//BrainStock.Mission.Current = data[1].Mission;
		end
	end
	BrainStock.db.query( "SELECT * FROM missiondata", mission ); 
end

function BrainStock.db.UpdateMissionData( mission, players )
	BrainStock.db.query( "TRUNCATE TABLE missiondata" );
	BrainStock.db.query( "INSERT INTO missiondata (Mission,Players,Sent) VALUES('" .. mission .. "','" .. players .. "',1)" );
end

function BrainStock.db.RecieveMissionData() //This is a check every 10 seconds when a game is not up
	if ( game.GetMap() == "gm_construct" && BrainStock.Configuration.MISSION_ServerIP == BrainStock.Configuration.CURRENT_ServerIP ) then
		if ( !BrainStock.Missions.RecieveDataDelay ) then BrainStock.Missions.RecieveDataDelay = CurTime() + 10; end
		if ( CurTime() < BrainStock.Missions.RecieveDataDelay ) then return; end
		
		print( "Tick" );

		BrainStock.db.LoadMission();
		BrainStock.Missions.RecieveDataDelay = CurTime() + 10;
	end
end