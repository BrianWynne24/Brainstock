
ACHIEVEMENT.PrintName	= "Killer with a conscious"; //Print name
ACHIEVEMENT.Description = [[Kill your first player]];
ACHIEVEMENT.Icon		= ""; //The material of the icon, what the avatar looks like
ACHIEVEMENT.Type		= ACHIEVEMENT_INSTANT; //NULL does not exist. Choose 'ACHIEVEMENT_UNLOCK' or 'ACHIEVEMENT_PROGRESS'
ACHIEVEMENT.MovingVar	= nil //Only used for ACHIEVEMENT_PROGRESS.
ACHIEVEMENT.EndingVar	= nil //The ending variable to earn the achievement

ACHIEVEMENT.OnReward		= function( pl )
	pl:AddTitle( "Cherry Popped" );
end

ACHIEVEMENT.OnNPCKill		= function( pl, npc )
end

local function _onplayerkill( pl, wep, attacker )
	if ( IsValid(attacker) && attacker:IsPlayer() && attacker != pl ) then
		attacker:RewardAchievement( "killer_with_a_conscious" );
	end
end
hook.Add( "PlayerDeath", "hedies", _onplayerkill );