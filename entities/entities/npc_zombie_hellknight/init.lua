ENT.Base 		= "npc_zombie_base";

ENT.HP     		 = 50000;
ENT.Model		= "models/hellknight.mdl";
ENT.Speed       = 180;
ENT.RunSpeed	= 240;
ENT.Damage      = 23;
ENT.HitDist		= 280;
ENT.ScaleSize	= 1.15;
ENT.CanRun		= false;

ENT.Sequences = {
	[ MODE_SLEEP ] = { "idle" },
	[ MODE_IDLE ] = { "idle" },
	[ MODE_ALERT ] = { "roar1" },
	[ MODE_ATTACK ] = { "attack3" }
};
ENT.Sounds = {
	[ MODE_SLEEP ] = "",
	[ MODE_IDLE ] = {},
	[ MODE_ALERT ] = { "hellknight/sight1.wav", "hellknight/sight2.wav", "hellknight/sight3.wav", "hellknight/sight4.wav" };
	[ "FOOTSTEPS" ] = { "npc/fast_zombie/foot1.wav", "npc/fast_zombie/foot2.wav", "npc/fast_zombie/foot3.wav", "npc/fast_zombie/foot4.wav" }
};

function ENT:Alert()
	/*if ( self.bAlerted ) then
		self:SetMode( MODE_CHASE );
		return;
	end*/
	
	//self:AlertOthers( 1200, self:GetEnemy() );
	self:EmitSound( self.Sounds[ MODE_ALERT ][ math.random(1,3) ], 400 );
	self:PlaySequenceAndWait( self.Sequences[ MODE_ALERT ][ 1 ], 1.0 );
	self:SetMode( MODE_CHASE );
	
	//self.bAlerted = true;
end

function ENT:Attack()
	local victim = self:GetEnemy();

	if ( (!IsValid(self:GetEnemy()) || !self:GetEnemy():Alive()) && self:Mode() != MODE_ROAM ) then
		self:SetEnemy( nil );
		self:SetMode( MODE_ROAM );
		return;
	end
	
	self:EmitSound( "hellknight/attack" .. math.random( 1, 5 ) .. ".wav", 200 );
	self:PlaySequenceAndWait( self.Sequences[ self:Mode() ][ 1 ], 1.4 );
	self:SetMode( MODE_CHASE );
	
	local pos = self:EnemyDist();
	if ( pos > self.HitDist ) then
		self:EmitSound( "brainstock/zombies/claw_miss" .. math.random( 1, 3 ) .. ".wav", 200 );
		self:EmitSound( self.Sounds[ MODE_ALERT ][ math.random(1,3) ], 400 );
		self:PlaySequenceAndWait( self.Sequences[ MODE_ALERT ][ 1 ], 1.0 );
		return;
	end
	
	self:DamageEnemy( victim, self.Damage );
	
	//victim:SetVelocity( victim:GetUp() * 500 );
	victim:SetVelocity( self:GetForward() * 300 );
	
	victim:EmitSound( "hellknight/hit" .. math.random( 1, 3 ) .. ".wav", 200 );

	local x, y, z = math.Rand( -4, 4 ), math.Rand( -4, 4 ), math.Rand( -4, 4 );
	victim:ViewPunchReset(0);
	victim:ViewPunch( Angle( x, y, z ) );
	
	GAMEMODE:PlayerHurt( victim, self, victim:Health(), self.Damage );
	
	self:EmitSound( self.Sounds[ MODE_ALERT ][ math.random(1,3) ], 400 );
	self:PlaySequenceAndWait( self.Sequences[ MODE_ALERT ][ 1 ], 1.0 );
end