
ACHIEVEMENT.PrintName	= "Cherry Popped"; //Print name
ACHIEVEMENT.Description = [[Kill your first zombie]];
ACHIEVEMENT.Icon		= ""; //The material of the icon, what the avatar looks like
ACHIEVEMENT.Type		= ACHIEVEMENT_INSTANT; //NULL does not exist. Choose 'ACHIEVEMENT_UNLOCK' or 'ACHIEVEMENT_PROGRESS'
ACHIEVEMENT.MovingVar	= nil //Only used for ACHIEVEMENT_PROGRESS.
ACHIEVEMENT.EndingVar	= nil //The ending variable to earn the achievement

ACHIEVEMENT.OnReward		= function( pl )
	pl:AddTitle( "Cherry Popped" );
end

ACHIEVEMENT.OnNPCKill		= function( pl, npc )
	pl:RewardAchievement( "cherry_popped" );
end