ENT.Base 		= "base_nextbot";

ENT.HP     		 = 150;
ENT.Model		= "models/Zombie/Fast.mdl";
ENT.Speed       = 50;
ENT.RunSpeed	= 245;
ENT.Damage      = 2;
ENT.CanRun		= true;
ENT.HitDist		= 76;
	
MODE_SLEEP  = 0;
MODE_ROAM   = 1;
MODE_ALERT  = 2;
MODE_ATTACK = 3;
MODE_IDLE   = 4;
MODE_CHASE  = 5;
MODE_FINDENEMY = 6;

ENT.Sequences = {
	[ MODE_SLEEP ] = { "slump_a", "slump_b" },
	[ MODE_IDLE ] = { "slumprise_a", "slumprise_b", "idle" },
	[ MODE_ALERT ] = { "idle_angry" },
	[ MODE_ATTACK ] = { "melee" }
};
ENT.Sounds = {
	[ MODE_SLEEP ] = "npc/fast_zombie/fz_alert_close1.wav",
	[ MODE_IDLE ] = {},
	[ MODE_ALERT ] = { "npc/zombie_poison/pz_pain3.wav", "npc/zombie_poison/pz_pain2.wav", "npc/zombie_poison/pz_pain1.wav" };
	[ "FOOTSTEPS" ] = { "npc/fast_zombie/foot1.wav", "npc/fast_zombie/foot2.wav", "npc/fast_zombie/foot3.wav", "npc/fast_zombie/foot4.wav" }
};

function ENT:SetSpeed( speed )
	self.loco:SetDesiredSpeed( speed );
	self.nSpeed = speed;
end

function ENT:SetMode( enum )
	if ( self.nMode != enum ) then
		/*if ( enum == MODE_ROAM && BrainStock.Missions.IsServer() ) then
			enum = MODE_FINDENEMY;
		end*/
		self.nMode = enum;
	end
end

function ENT:Mode()
	/*if ( enum == MODE_ROAM && BrainStock.Missions.IsServer() ) then
		return true;
	end*/
	return self.nMode;
end

function ENT:Initialize()
	//local rand = table.Random( self.Model );
	
	self:SetModel( self.Model );
	self:SetHealth( self.HP );
	
	//self:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) 
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS );
	self.ResetCollision = CurTime() + 1;
	
	self:SetSpeed( self.Speed );

	if ( !BrainStock.Missions.Current ) then
		self.nMode = MODE_ROAM;
	else
		self:FindEnemy();
		//self.nMode = MODE_CHASE;
	end
	
	self.fFootstep = 0;
	self.bOnFire = false;
	self.Damagers = {};
	self.LastEnemySwitch = CurTime();
	self.PlayerCheck = CurTime() + 10;
	
	if ( self.ScaleSize ) then
		self:SetModelScale( self.ScaleSize, 0 );
	end
end

function ENT:GetEnemy()
	return self.enemy;
end

function ENT:SetEnemy( ent )
	self.enemy = ent;
end

function ENT:FindEnemy()
	if ( #player.GetAll() < 1 ) then return; end
	
	local target = player.GetAll()[ math.random(1,#player.GetAll()) ];
	if ( IsValid( target ) && target:IsPlayer() && target:Alive() ) then
		self:SetEnemy( target );
		self:SetMode( MODE_CHASE );
		return;
	end
end

function ENT:RunBehaviour()
	while (true) do
		if ( self:Mode() == MODE_SLEEP ) then
			self:PlaySequenceAndWait( self.Sequences[ self:Mode() ][ math.random(1,2) ], 1.0 );
		elseif ( self:Mode() == MODE_ROAM ) then
			if ( BrainStock.Missions.IsServer() ) then
				self:FindEnemy();
				coroutine.yield();
				return;
			end
			
			if ( self.bAlerted ) then
				self.bAlerted = false;
			end
			self:SetSpeed( self.Speed );
			self:StartActivity( ACT_WALK );
			
			local pos = self:FindSpot( "random", { radius = (10000) } );
			
			//self:CheckArea();
			
			if ( pos ) then
				local opts = { draw = false, maxage = math.Rand( 2, 3 ) };
				self:Search();
				//if ( self:HasValidEnemy() ) then
				//	coroutine.yield();
				//end
				self:MoveToPos( pos, opts );
			end
		elseif ( self:Mode() == MODE_ALERT ) then
				self:Alert();
		elseif ( self:Mode() == MODE_CHASE ) then
			self:SetSpeed( self.RunSpeed );
			if ( self.CanRun ) then
				self:StartActivity( ACT_RUN );
			else
				self:StartActivity( ACT_WALK );
			end
			self:ChaseTarget();
		elseif ( self:Mode() == MODE_ATTACK ) then
			self:Attack();
		end
		coroutine.yield();
	end
end

function ENT:AlertOthers( radius, pl )
	if ( !IsValid( self:GetEnemy() ) || !self:GetEnemy():Alive() ) then return; end
	
	local ent = ents.FindInSphere(self:GetPos(), radius);
	for k, v in pairs( ent ) do
		if ( IsValid(v) && string.find( v:GetClass(), "npc_zombie" ) && v != self && self:HasValidEnemy() && IsValid(pl) ) then
			v.bAlerted = true;
			v:SetEnemy( pl );
			v:SetMode( MODE_CHASE );
			//break;
		end
	end
end

function ENT:Search()
	if ( BrainStock.Missions.IsServer() ) then 
		self:FindEnemy();
		return; 
	end
	
	local Radius = ents.FindInSphere( self:GetPos(), (BrainStock.Configuration.SpotStand*1.6) );
	for k, v in pairs( Radius ) do
		if ( IsValid(v) && v:IsPlayer() ) then
			local dist = self:GetPos():Distance( v:GetPos() );
			local crouching = v:KeyDown( IN_DUCK );
			
			if ( v:Alive() && self:Visible( v ) && (((crouching || v:IsSliding()) && dist <= BrainStock.Configuration.SpotCrouch) || (!crouching && dist <= BrainStock.Configuration.SpotStand) || (v:InSprint() && dist <= BrainStock.Configuration.SpotStand*1.6) ) ) then
				if ( self:GetClass() == "npc_zombie_hellknight" && self:GetPos().z < (v:GetPos().z-100) ) then
					return;
				end
				self:SetEnemy( v );
				self:SetMode( MODE_ALERT );
				return
			end
		end
	end
end

function ENT:Alert()
	if ( self.bAlerted ) then
		self:SetMode( MODE_CHASE );
		return;
	end
	
	self:AlertOthers( 1200, self:GetEnemy() );
	self:EmitSound( self.Sounds[ self:Mode() ][ math.random(1,3) ] );
	self:PlaySequenceAndWait( self.Sequences[ self:Mode() ][ 1 ], 1.0 );
	self:SetMode( MODE_CHASE );
	
	self.bAlerted = true;
end

function ENT:BehaveUpdate( fInterval )
	if ( !self.BehaveThread ) then return end
	
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then

		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );
	end
end

function ENT:SetFire( bool )
	self.bOnFire = bool;
	if ( bool ) then
		self:Ignite( 100000 );
	else
		self:Extinguish();
	end
end

function ENT:Sunlight()

	local sun = nil;
	for k, v in pairs( ents.FindByClass( "light_environment" ) ) do
		sun = v;
	end

	if ( !sun ) then return; end
	
	local tr = {};
	
	tr.start = self:GetPos();
	tr.endpos = (sun:GetPos() - self:GetPos()):Normalize();
	//tr.endpos = self:GetPos() + Vector( 0, 0, 10000000 );
	tr.filter = { self.Entity };
	
	if ( self:HasValidEnemy() ) then
		table.insert( tr.filter, self:GetEnemy() );
	end
	
	tr = util.TraceLine( tr );
	
	if ( !tr.Hit ) then
		self:SetFire( true );
	else
		self:SetFire( false );
	end
end

function ENT:Think()
	//self:Sunlight();
	self:LookForPlayers();
	if ( (!IsValid( self:GetEnemy() ) || !self:GetEnemy():Alive()) && self:Mode() != MODE_ROAM ) then
		self:SetEnemy( nil );
		self:SetMode( MODE_ROAM );
	end
	
	if ( CurTime() > self.ResetCollision && self:GetCollisionGroup() != COLLISION_GROUP_NONE ) then
		self:SetCollisionGroup( COLLISION_GROUP_NONE );
	end
	
	/*local color = self:GetColor();
	if ( color.a < 255 ) then
		color.a = color.a + 1;
		self:SetColor( Color( 255, 255, 255, color.a ) );
	end*/
	
	if ( CurTime() < self.fFootstep || self:Mode() != MODE_ROAM ) then return; end
	
	self:EmitSound( self.Sounds[ "FOOTSTEPS" ][ math.random(1,4) ], 65 );
	self.fFootstep = CurTime() + (self.nSpeed/(self.nSpeed/50));
	
	if ( self:GetClass() != "npc_zombie_hellknight" ) then return; end
	util.ScreenShake( self:GetPos(), 5, 5, 0.25, 1000 );
end

function ENT:ChaseTarget()
	local path = Path("Chase")
    path:SetMinLookAheadDistance(200)
    path:SetGoalTolerance(20)
	
	self.StartChase = CurTime() + 8;

	if ( self:EnemyDist() <= self.HitDist ) then
		self:SetMode( MODE_ATTACK );
	end
	
    while (self:EnemyDist() > (self.HitDist/2)) do
		if ( !IsValid( self:GetEnemy() ) || !self:GetEnemy():Alive() || (self:EnemyDist() >= (BrainStock.Configuration.SpotStand*2.2) && CurTime() > self.StartChase) || (self:GetEnemy():GetPos().z > (self:GetPos().z+100) && self:GetClass() == "npc_zombie_hellknight") ) then
			if ( IsValid( self:GetEnemy() ) && self:GetEnemy():GetPos().z > (self:GetPos().z+100) && self:GetClass() == "npc_zombie_hellknight" ) then
				self:EmitSound( self.Sounds[ MODE_ALERT ][ math.random(1,3) ], 400 );
				self:PlaySequenceAndWait( self.Sequences[ MODE_ALERT ][ 1 ], 1.0 );
			end
			path:Invalidate();
			self:SetEnemy( nil );
			self:SetMode( MODE_ROAM );
			coroutine.yield();
			return;
		end
		
		
        path:Compute(self, self:GetEnemy():GetPos());
		path:Chase(self, self:GetEnemy());

        if self.loco:IsStuck() then
            self:HandleStuck()

            return "stuck"
        end

	coroutine.yield()
    end

end

function ENT:Attack()
	local victim = self:GetEnemy();

	if ( (!IsValid(self:GetEnemy()) || !self:GetEnemy():Alive()) && self:Mode() != MODE_ROAM ) then
		self:SetEnemy( nil );
		self:SetMode( MODE_ROAM );
		return;
	end
	
	self:PlaySequenceAndWait( self.Sequences[ self:Mode() ][ 1 ], 1.4 );
	self:SetMode( MODE_CHASE );
	
	local pos = self:EnemyDist();
	if ( pos > self.HitDist ) then
		self:EmitSound( "brainstock/zombies/claw_miss" .. math.random( 1, 3 ) .. ".wav" );
		return;
	end
	
	self:DamageEnemy( victim, self.Damage );
	victim:EmitSound( "brainstock/zombies/claw_strike" .. math.random( 1, 3 ) .. ".wav" );
	
	local x, y, z = math.Rand( -4, 4 ), math.Rand( -4, 4 ), math.Rand( -4, 4 );
	victim:ViewPunchReset(0);
	victim:ViewPunch( Angle( x, y, z ) );
	
	GAMEMODE:PlayerHurt( victim, self, victim:Health(), self.Damage );
end

function ENT:DamageEnemy( pl, dmg )
	if ( pl:Armor() > 0 ) then
		pl:SetArmor( pl:Armor() - dmg );
		pl:SetHealth( pl:Health() - math.Round(dmg/3) );
	else
		pl:SetHealth( pl:Health() - dmg );
	end
	if ( pl:Health() <= 0 ) then
		pl:Kill();
		GAMEMODE:PlayerDeath( pl, nil, self )
	end
end

function ENT:EnemyDist()
	if ( !self:GetEnemy() ) then return 100000; end
	return self:GetPos():Distance(self:GetEnemy():GetPos()) or 0;
end

function ENT:HasValidEnemy()
	if ( IsValid(self:GetEnemy()) && self:GetEnemy():IsPlayer() && self:GetEnemy():Alive() ) then
		return true;
	end
	//self:SetEnemy( nil );
	return false;
end

//Hooks
function ENT:OnInjured( dmginfo )
	//GAMEMODE:ScaleNPCDamage( self, hitgroup, dmginfo );
	self:SetHealth( self:Health() - dmginfo:GetDamage() );
	
	local attacker= dmginfo:GetAttacker() or "";
	if ( !self.Damagers[ attacker ] ) then
		self.Damagers[ attacker ] = 0;
	end
	self.Damagers[ attacker ] = self.Damagers[ attacker ] + dmginfo:GetDamage();
	
	if ( !self:HasValidEnemy() && attacker:IsPlayer() && attacker:Alive() ) then
		self:SetEnemy( dmginfo:GetAttacker() );
		self:SetMode( MODE_ALERT );
	end
	
	if ( attacker:IsPlayer() && (!self.Damagers[ self:GetEnemy() ] || self.Damagers[ attacker ] > self.Damagers[ self:GetEnemy() ]) && CurTime() > self.LastEnemySwitch ) then
		self:SetEnemy( attacker );
		self.LastEnemySwitch = CurTime() + 4;
	end
end

function ENT:OnKilled( dmginfo )
	GAMEMODE:OnNPCKilled( self, dmginfo:GetAttacker(), dmginfo:GetAttacker():GetActiveWeapon() );
	self:BecomeRagdoll( dmginfo );
	
	if ( IsValid( self:GetOwner() ) ) then
		self:GetOwner():RemoveZombie( self );
	end
end
/*function ENT:OnOtherKilled( dmginfo )
	local attacker = dmginfo:GetAttacker();
	local dist = self:GetPos():Distance( attacker:GetPos() );
	if ( attacker && attacker:IsPlayer() && dist <= 1024 ) then
		self:SetEnemy( attacker );
		self:SetMode( MODE_CHASE );
	end
end*/

function ENT:IsZombie()
	return true;
end

function ENT:LookForPlayers()
	if ( CurTime() < self.PlayerCheck || self:GetClass() == "npc_zombie_hellknight" ) then return; end
	self.PlayerCheck = CurTime() + 10;
	
	for k, v in pairs( player.GetAll() ) do
		local dist = v:GetPos():Distance( self:GetPos() );
		if ( dist <= 4000 || self:Visible( v ) ) then
			return;
		end
	end
	if ( IsValid( self:GetOwner() ) ) then
		self:GetOwner():RemoveZombie( self );
	end
	self:Remove();
end