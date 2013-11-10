BrainStock	 = {};

GM.Name		 = "Brainstock b02";
GM.Author 	 = "Annoyed Tree";
GM.Website	 = "http://www.brainstock.webs.com";
GM.Folder	 = "brainstock"; //Do not edit this...

if ( SERVER ) then
	AddCSLuaFile( GM.Folder .. "/load.lua" );
	AddCSLuaFile( GM.Folder .. "/configuration.lua" );
end

include( GM.Folder .. "/configuration.lua" );
include( GM.Folder .. "/load.lua" );