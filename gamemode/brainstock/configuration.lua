BrainStock.Configuration = {};


//Default Settings are as follows for the MySQL
//WARNING: THESE ONLY RUN IF MYSQL THAT WAS HOSTED ON WAS NOT FOUND
BrainStock.Configuration.Host			  = "localhost";
BrainStock.Configuration.User			  = "root";
BrainStock.Configuration.Password		  = "annoyed";
BrainStock.Configuration.Database		  = "brainstock";
BrainStock.Configuration.Port			  = 3306;

BrainStock.Configuration.InventorySlots   = 20;
BrainStock.Configuration.InventoryLose    = true;

BrainStock.Configuration.WalkSpeed		  = 120;
BrainStock.Configuration.RunSpeed		  = 220;

BrainStock.Configuration.HungerMod		  = true
BrainStock.Configuration.HungerVar		  = (2*60); //how many seconds it takes to lose 1% of hunger

BrainStock.Configuration.RespawnDelay     = 1;
BrainStock.Configuration.MaxStamina		  = 12;

BrainStock.Configuration.Debug 			  = false;
BrainStock.Configuration.VerStatus		  = "Build Pre-03";

BrainStock.Configuration.MaxGoodEvil	  = 200;

BrainStock.Configuration.MAIN_ServerIP    = "localhost";
BrainStock.Configuration.CURRENT_ServerIP = GetConVar( "ip" ):GetString();
BrainStock.Configuration.MISSION_ServerIP = "74.91.124.83"; 

BrainStock.Configuration.ItemLimit		  = 56;
BrainStock.Configuration.ZombieLimit	  = 40;

BrainStock.Configuration.SpotCrouch		  = 200;
BrainStock.Configuration.SpotStand        = 480;

BrainStock.Configuration.MaxWepUpgrade	  = 3;

/*BrainStock.Configuration.AddConVar( "brainstockcfg_inventoryslots", 
		9, 
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);

BrainStock.Configuration.AddConVar( "brainstockcfg_inventorylose", 
		true, 
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);

BrainStock.Configuration.AddConVar( "brainstockcfg_walkspeed",
		120,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);
	
BrainStock.Configuration.AddConVar( "brainstockcfg_runspeed",
		240,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);
	
BrainStock.Configuration.AddConVar( "brainstockcfg_hunger",
		true,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);
	
BrainStock.Configuration.AddConVar( "brainstockcfg_hungervar",
		1,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_ARCHIVE
	);
	
BrainStock.Configuration.AddConVar( "brainstockcfg_maxstamina",
		30,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);
	
BrainStock.Configuration.AddConVar( "brainstockcfg_debug",
		true,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	):
	
BrainStock.Configuration.AddConVar( "brainstockcfg_version",
		"Alpha Build",
		FCVAR_SERVER_CAN_EXECUTE | FCVAR_REPLICATED | FCVAR_ARCHIVE
	);
	
BrainStock.Configuration.AddConVar( "brainstockcfg_max_goodevil",
		200,
		FCVAR_NEVER_AS_STRING | FCVAR_SERVER_CAN_EXECUTE | FCVAR_ARCHIVE
	);*/