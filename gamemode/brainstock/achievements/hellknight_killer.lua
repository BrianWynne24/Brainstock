
ACHIEVEMENT.PrintName	= "The bigger they are..."; //Print name
ACHIEVEMENT.Description = [[Kill the fucking hellknight!]];
ACHIEVEMENT.Icon		= ""; //The material of the icon, what the avatar looks like
ACHIEVEMENT.Type		= ACHIEVEMENT_INSTANT; //NULL does not exist. Choose 'ACHIEVEMENT_UNLOCK' or 'ACHIEVEMENT_PROGRESS'
ACHIEVEMENT.MovingVar	= nil //Only used for ACHIEVEMENT_PROGRESS.
ACHIEVEMENT.EndingVar	= nil //The ending variable to earn the achievement

ACHIEVEMENT.OnReward		= function( pl )
	pl:AddTitle( "Beast Killer" );
end

ACHIEVEMENT.OnNPCKill		= function( pl, npc )
	if ( npc:GetClass() == "npc_zombie_hellknight" ) then
		pl:RewardAchievement( "hellknight_killer" );
	end
end