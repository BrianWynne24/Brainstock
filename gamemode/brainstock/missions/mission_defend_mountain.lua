//This is for testing/example purposes

MISSION.Name		= "Defense - Mountside"
MISSION.Description = [[]];
MISSION.Category 	= MISSION_CATEGORY_DEFEND;
MISSION.Map			= "gm_mountainside";

MISSION.Setup = function() //Called on GM:Initialize();
	local t_Pos = {
		["ent_defensepoint"] = { Pos = Vector( -6959.0180664063, -915.27978515625, 1182.0533447266 ), Ang = Angle( 0, 0, 90 ) },
		["ent_missionspawn"] = { Pos =  Vector( -6944.857421875, -1213.8155517578, 1185.5545654297 ), Ang = Angle( 0, 90, 0 ) },
		["ent_helicopter"] = { Pos = Vector( -12788.65234375, -1994.5180664063, 1878.2958984375 ), Ang = Angle( 0, 180, 0 ) },
		["ent_lo_camera"] = { Pos = Vector( -5827.8989257813, -529.70166015625, 1518.8421630859 ), Ang = Angle( 20, -153, 0 ) }
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