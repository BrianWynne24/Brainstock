//This is for testing/example purposes

MISSION.Name		= "Supplies Here!"
MISSION.Description = [[Go to the desolte town of Silenthill and grab [4] supply crates and bring them
back to the cargo truck.]];
MISSION.Category 	= MISSION_CATEGORY_SUPPLIES;
MISSION.Map			= "rp_silenthill";

MISSION.Setup = function() //Called on GM:Initialize();
	local t_Pos = {
		["ent_supplycrate_1"] = { Pos = Vector( -4871.3012695313, 1029.4497070313, 68.03125 ), Ang = Angle( 0, 60, 0 ) },
		["ent_supplycrate_2"] = { Pos = Vector( -4968.1850585938, 1031.0727539063, 68.03125 ), Ang = Angle( 0, 32, 0 ) },
		["ent_supplycrate_3"] = { Pos = Vector( -5035.7456054688, 864.42657470703, 68.03125 ), Ang = Angle( 0, 177, 0 ) },
		["ent_supplycrate_4"] = { Pos = Vector( -5024.0654296875, 954.83703613281, 68.03125 ), Ang = Angle( 0, 266, 0 ) },
		["ent_supplytruck"]   = { Pos = Vector( 4150.4370117188, 335.96267700195, 64.03125 ), Ang = Angle( 0, 180, 0 ) },
		["ent_missionspawn"] = { Pos = Vector( 4177.8364257813, 2.0166900157928, 64.03125 ), Ang = Angle( 0, 180, 0 ) }
		//"ent_lo_camera" = Vector( 0, 0, 0 )
	};
	
	for k, v in pairs( t_Pos ) do
		local class = k;
		if ( string.find( class, "ent_supplycrate" ) ) then // I had to do this because tables can't store same values
			class = "ent_supplycrate";
		end
		local ent = ents.Create( class );
		
		ent:SetPos( v.Pos );
		ent:SetAngles( v.Ang );
		ent:Spawn();
		ent:Activate();
	end
end

MISSION.OnStart = function( pl )
end

MISSION.OnCompleted = function()
end

MISSION.OnFailed = function()
end

MISSION.Objective = function() //The objectives of the mission
	return { "ent_supplycrate", "ent_supplytruck" }; //This is all handled clientside
end

MISSION.TimeLimit = function() //In minutes, return -1 for no timelimit
	return -1;
end

MISSION.Think	= function()
end

MISSION.ZSpawnDist = function( dist )
	local t = { 1024, 3024 };
	
	return t[ dist ];
	//return { 1024, 3024 }; //1 = mindist, 2 = maxdist
end

MISSION.Zombies = function()
	return { "npc_zombie_fast" };
end
/*MISSION.InitDoors	= function()
	return "lock"; //"remove";
end*/