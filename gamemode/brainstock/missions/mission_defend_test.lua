//This is for testing/example purposes

MISSION.Name		= "Defend this position"
MISSION.Description = [[Your supply truck had no room for you. Now you must wait for a help to arrive]];
MISSION.Category 	= MISSION_CATEGORY_DEFEND;
MISSION.Map			= "rp_silenthill";

MISSION.Setup = function() //Called on GM:Initialize();
	local t_Pos = {
		["ent_defensepoint"] = { Pos = Vector( 1719.7053222656, -4.4681401252747, 65.00000 ), Ang = Angle( 0, 0, 90 ) },
		["ent_missionspawn"] = { Pos = Vector( 1716.1879882813, -221.18432617188, 68.03125 ), Ang = Angle( 0, 180, 0 ) },
		["ent_helicopter"] = { Pos = Vector( 4115.5229492188, 16.800727844238, 611.33221435547 ), Ang = Angle( 0, 180, 0 ) },
		["ent_lo_camera"] = { Pos = Vector( 1415.5589599609, 371.11123657227, 398.38391113281 ), Ang = Angle( 37, -98, 0 ) }
	};
	
	for k, v in pairs( t_Pos ) do
		local ent = ents.Create( k );
		
		ent:SetPos( v.Pos );
		ent:SetAngles( v.Ang );
		ent:Spawn();
		ent:Activate();
	end
end

MISSION.OnStart = function( pl )
	pl:EmitSound( "brainstock/mission/defend_start.wav" );
	//pl:SetMoveType( MOVETYPE_NOCLIP );
end

MISSION.OnCompleted = function()
end

MISSION.OnFailed = function()
end

MISSION.Objective = function() //The objectives of the mission
	return { "ent_defensepoint" }; //This is all handled clientside
end

MISSION.TimeLimit = function() //In minutes, return -1 for no timelimit
	return 8; //In minutes
end

MISSION.Think	= function()
end

MISSION.ZSpawnDist = function( dist )
	local t = { 1024, 3024 };
	
	return t[ dist ];
	//return { 1024, 3024 }; //1 = mindist, 2 = maxdist
end

MISSION.Zombies = function()
	return { "bs_zombie_walker", "bs_zombie_runner" };
end
/*MISSION.InitDoors	= function()
	return "lock"; //"remove";
end*/