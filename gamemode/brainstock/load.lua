//Everything written in this gamemode is by Annoyed Tree (Brian Wynne)
//With the 'CalculateLastAng' function is written by ZCOM but is unused (Adrian Leuzzi)
//Under no cirumstances are you allowed to edit, modify, or take without Brian Wynne's Permission
//This gamemode and the name 'Brainstock' is registered under Creative Commons Copyright License

BrainStock.Items		= {};
	BrainStock.Items.Spawned = {};
	BrainStock.Items.Classes = {};
BrainStock.Perks		= {};
BrainStock.Accessories  = {};
BrainStock.Register		= {};
BrainStock.Missions     = {};
	BrainStock.Missions.Current = nil;//"mission_supply_test";
	//BrainStock.Missions.TimeLimit = -1;
	BrainStock.Missions.DeadPlayers = {};
	BrainStock.Missions.ReadPlayers = {};
	BrainStock.Missions.AllowedPlayers = {};
	BrainStock.Missions.Queue = {};
	BrainStock.Missions.QueueDelay = 0;
BrainStock.Achievements    	= {};
BrainStock.PlayerData		= {};
BrainStock.LoadData		= {};
BrainStock.HUD				= {};
	//BrainStock.HUD.Delay   = {};
BrainStock.cc			= {};
BrainStock.VGUI			= {};
BrainStock.db 			= {};
BrainStock.SpawnPoints	= {
	Zombies = {},
	Items = {},
	Players = {},
	BossZombie = {}
};
BrainStock.Shops 		= {};
BrainStock.Squads		= {};
if ( !BrainStock.WeaponUpgrades ) then
	BrainStock.WeaponUpgrades = {};
end

if ( SERVER && game.GetMap() != "gm_construct" )  then
	local txt = "brainstock/mission.txt";
	if ( file.Exists( txt, "DATA" ) ) then
		txt = file.Read( txt, "DATA" );
		BrainStock.Missions.Current = txt;
		
		//file.Delete( txt );
	end
	
	local txt = "brainstock/players.txt";
	if ( file.Exists( txt, "DATA" ) ) then
		txt = file.Read( txt, "DATA" );
		
		txt = string.Explode( ",", txt );
		for k, v in pairs( txt ) do
			table.insert( BrainStock.Missions.AllowedPlayers, v );
		end
		//file.Delete( txt );
	end
	
	if ( !BrainStock.Missions[ BrainStock.Missions.Current ] || BrainStock.Missions[ BrainStock.Missions.Current ].Map != game.GetMap() ) then	
		BrainStock.Missions.Current = nil;
	end
end


//ENUM
MISSION_CATEGORY_SUPPLIES	= 0;
MISSION_CATEGORY_DEFEND		= 1;
MISSION_CATGEORY_VIP		= 2;

ITEM_SLOT_PRIMARY			= 0;
ITEM_SLOT_SECONDARY			= 1;
ITEM_SLOT_MELEE				= 2;
ITEM_SLOT_CRATE				= 3;
ITEM_SLOT_NULL				= -1;
 
ACHIEVEMENT_PROGRESSIVE		= 0;
ACHIEVEMENT_INSTANT			= 1;

PERK_OFFENSIVE				= 1;
PERK_DEFENSIVE				= 2;

ITEM_VERYCOMMON				= 9;
ITEM_COMMON					= 5;
ITEM_UNCOMMON				= 4;
ITEM_RARE					= 3;
ITEM_VERYRARE				= 2;
ITEM_MAXRARE				= 1;

//RunConsoleCommand( "sv_password 1234" );

game.AddAmmoType( {
	name = "9x19mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 35,
	npcdmg = 45,
	force = 2000,
	minsplash = 5,
	maxsplash = 10
} );
game.AddAmmoType( {
	name = "5.56x45mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 50,
	npcdmg = 60,
	force = 2000,
	minsplash = 5,
	maxsplash = 10
} );
game.AddAmmoType( {
	name = "7.62x51mm",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 65,
	npcdmg = 75,
	force = 2000,
	minsplash = 5,
	maxsplash = 10
} );
game.AddAmmoType( {
	name = ".45 ACP",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 70,
	npcdmg = 75,
	force = 200,
	minsplash = 5,
	maxsplash = 10
} );
game.AddAmmoType( {
	name = ".357 Magnum",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 10,
	npcdmg = 10,
	force = 200,
	minsplash = 5,
	maxsplash = 10
} );

if ( SERVER ) then
	resource.AddWorkshop( "159888563" );
	resource.AddWorkshop( "153107423" );
	
	util.AddNetworkString( "bs_Inventory" );
	util.AddNetworkString( "bs_Ironsights" );
	util.AddNetworkString( "bs_Hunger" );
	util.AddNetworkString( "bs_Stamina" );
	util.AddNetworkString( "bs_GoodEvil" );
	util.AddNetworkString( "bs_ResTime" );
	util.AddNetworkString( "bs_AchieveUnlock" );
	util.AddNetworkString( "bs_mKillTime" );
	util.AddNetworkString( "bs_misEnd" );
	util.AddNetworkString( "bs_Squad" );
	util.AddNetworkString( "bs_LootBody" );
	util.AddNetworkString( "bs_Perk" );
	util.AddNetworkString( "bs_Hint" );
	util.AddNetworkString( "bs_Slide" );
	util.AddNetworkString( "bs_Shield" );
	util.AddNetworkString( "bs_WepUpgrade" );
	util.AddNetworkString( "bs_Titles" );
	util.AddNetworkString( "bs_SetTitle" );
	util.AddNetworkString( "bs_Shoot" );
	util.AddNetworkString( "bs_KillIcon" );
	util.AddNetworkString( "bs_NVG" );
	util.AddNetworkString( "bs_Cells" );
else
	BrainStock.WeaponAttachments = {};
		BrainStock.WeaponAttachments[ "eotech" ] = { Model = "models/battery/weapons/attachment/eotech.mdl", Scale = 0.5 };
end
	/*AddCSLuaFile( "core/cl_networking.lua" );
	AddCSLuaFile( "core/sh_player_ext.lua" );
	AddCSLuaFile( "core/sh_animations.lua" );
	AddCSLuaFile( "core/sh_weapon_sounds.lua" );
	AddCSLuaFile( "core/cl_hud.lua" );
	
	include( "core/sv_core.lua" );
	include( "core/sv_player.lua" );
	include( "core/sv_player_ext.lua" );
	include( "core/sv_mission.lua" );
	include( "core/sv_concommand.lua" );
	include( "core/sh_player_ext.lua" );
	include( "core/sh_animations.lua" );
	include( "core/sh_weapon_sounds.lua" );
else
	include( "core/cl_networking.lua" );
	include( "core/sh_player_ext.lua" );
	include( "core/sh_animations.lua" );
	include( "core/sh_weapon_sounds.lua" );
	include( "core/cl_hud.lua" );
end*/
 
print( "=======================================" );
print( "     BrainStock by: Annoyed Tree       " );
print( "=======================================" );

function BrainStock.Register.Items( item )
	BrainStock.Items[ item.Class ] = item;
	
	table.insert( BrainStock.Items.Classes, item.Class );
end

function BrainStock.Register.Achievements( achievement )
	BrainStock.Achievements[ achievement.Class ] = achievement;
end

function BrainStock.Register.Mission( mission )
	BrainStock.Missions[ mission.Class ] = mission;
end

function BrainStock.Register.Perk( perk )
	BrainStock.Perks[ perk.Class ] = perk;
end

function BrainStock.Register.Accessory( accessory )
	BrainStock.Accessories[ accessory.Class ] = accessory;
end

function BrainStock.LoadData.LuaFiles( dir ) //BrainStock/gamemode/BrainStock/core/sv_*.lua
	print( "Loading Server files" );
	for k, v in pairs( file.Find( dir .. "/client_*.lua", "LUA" ) ) do
		
		if( SERVER ) then
			AddCSLuaFile( "core/" .. v );
			print( "> core/" .. v );
		else
			include( "core/" .. v );
		end
		
	end
	for k, v in pairs( file.Find( dir .. "/shared_*.lua" , "LUA" ) ) do
		
		if( SERVER ) then
			AddCSLuaFile( "core/" .. v );
			print( "> core/" .. v );
		end
		include( "core/" .. v );
	
	end
	for k, v in pairs( file.Find( dir .. "/server_*.lua", "LUA" ) ) do
		
		if( SERVER ) then
			include( "core/" .. v );
			print( "> core/" .. v );
		end
		
	end
	print( "Done." );
end

function BrainStock.LoadData.Items( dir )
	print( "=======================================" );
	print( "Loading Items" );
	
	for k, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
		ITEM = {};
		if ( SERVER ) then
			AddCSLuaFile( "items/" .. v );
		end
		include( "items/" .. v );
		
		local class = v;
		class = string.gsub( class, ".lua", "" );
		
		ITEM.Class = class;
		BrainStock.Register.Items( ITEM );
		
		print( "> ", ITEM.Class );
		
		ITEM = {};
	end
	print( "Done." );
end

function BrainStock.LoadData.Achievements( dir )
	print( "=======================================" );
	print( "Loading Achievements" );

	for k, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
		ACHIEVEMENT = {};
		if ( SERVER ) then
			AddCSLuaFile( "achievements/" .. v );
		end
		include( "achievements/" .. v );
		
		local class = v;
		class = string.gsub( class, ".lua", "" );
		
		ACHIEVEMENT.Class = class;
		BrainStock.Register.Achievements( ACHIEVEMENT );
		
		print( "> ", ACHIEVEMENT.Class );
		
		ACHIEVEMENT = {};
	end
	print( "Done." );
end

function BrainStock.LoadData.Missions( dir )
	print( "=======================================" );
	print( "Loading Missions" );

	for k, v in pairs( file.Find( dir .. "/*", "LUA" ) ) do
		
		if ( string.find( v, ".lua" ) ) then
			MISSION = {};
			if ( SERVER ) then
				AddCSLuaFile( "missions/" .. v );
				//AddCSLuaFile( "missions/" .. v .. "/shared.lua" );
			end
			include( "missions/" .. v );
			//include( "missions/" .. v .. "/shared.lua" );
		
			local class = v;
			class = string.gsub( class, ".lua", "" );
		
			MISSION.Class = class;
			BrainStock.Register.Mission( MISSION );
		
			print( "> ", MISSION.Class );
			
			MISSION = {};
		end

	end
	print( "Done." );
end

function BrainStock.LoadData.Perks( dir )
	print( "=======================================" );
	print( "Loading Perks" );

	for k, v in pairs( file.Find( dir .. "/*", "LUA" ) ) do
		
		if ( string.find( v, ".lua" ) ) then
			PERK = {};
			if ( SERVER ) then
				AddCSLuaFile( "perks/" .. v );
			end
			include( "perks/" .. v );
		
			local class = v;
			class = string.gsub( class, ".lua", "" );
		
			PERK.Class = class;
			BrainStock.Register.Perk( PERK );
		
			print( "> ", PERK.Class );
			
			PERK = {};
		end

	end
	print( "Done." );
end

function BrainStock.LoadData.Accessories( dir )
	print( "=======================================" );
	print( "Loading Accessories" );

	for k, v in pairs( file.Find( dir .. "/*", "LUA" ) ) do
		
		if ( string.find( v, ".lua" ) ) then
			ACCESSORY = {};
			if ( SERVER ) then
				AddCSLuaFile( "accessories/" .. v );
			end
			include( "accessories/" .. v );
		
			local class = v;
			class = string.gsub( class, ".lua", "" );
		
			ACCESSORY.Class = class;
			BrainStock.Register.Accessory( ACCESSORY );
		
			print( "> ", ACCESSORY.Class );
			
			ACCESSORY = {};
		end

	end
	print( "Done." );
end

function BrainStock.Missions.IsServer()
	if ( BrainStock.Missions[ BrainStock.Missions.Current ] && BrainStock.Configuration.CURRENT_ServerIP == BrainStock.Configuration.MISSION_ServerIP ) then
		return true;
	end
	return false;
end

function BrainStock.LoadData.Spawns()
	if ( /*BrainStock.Configuration.Debug ||*/ CLIENT ) then return; end

	//BrainStock.LoadPointData( "ent_zombie_spawner" );
	//BrainStock.LoadPointData( "ent_player_spawner" );
	timer.Simple( 1, function() 
		BrainStock.LoadPointData( "ent_zombie_spawner" );
		BrainStock.LoadPointData( "ent_player_spawner" );
		BrainStock.LoadPointData( "ent_boss_spawner" ) 
	end );
	if ( !BrainStock.Missions.IsServer() ) then
		BrainStock.LoadPointData( "ent_item_spawner" );
	end
end

BrainStock.LoadData.LuaFiles( "brainstock/gamemode/brainstock/core" );
BrainStock.LoadData.Items( "brainstock/gamemode/brainstock/items" );
BrainStock.LoadData.Achievements( "brainstock/gamemode/brainstock/Achievements" );
BrainStock.LoadData.Missions( "brainstock/gamemode/brainstock/missions" );
BrainStock.LoadData.Perks( "brainstock/gamemode/brainstock/perks" );
BrainStock.LoadData.Accessories( "brainstock/gamemode/brainstock/accessories" );

if ( BrainStock.Missions.IsServer() && SERVER ) then
	BrainStock.db.LoadMission();
end

/*function BrainStock.Configuration.AddConvar( name, value, flags, helptxt )

	local searchFlags = tostring( flags );
	searchFlags = string.upper( searchFlags );
	if ( string.find( searchFlags, "FCVAR_USERINFO" ) ) then
		_G[name] = CreateClientConVar( name, value, flags, helptxt );
	else
		_G[name] = CreateConVar( name, value, flags, helptxt );
	end
	
end*/