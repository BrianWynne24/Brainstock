ENT.Base 		= "npc_zombie_base";

ENT.HP     		 = 300;
ENT.Model		= "models/Zombie/Poison.mdl";
ENT.Speed       = 40;
ENT.RunSpeed	= 100;
ENT.Damage      = 40;
ENT.HitDist		= 120;
ENT.CanRun		= false;

ENT.Sequences = {
	[ MODE_SLEEP ] = { "Idle01" },
	[ MODE_IDLE ] = { "Idle01" },
	[ MODE_ALERT ] = { "releasecrab" },
	[ MODE_ATTACK ] = { "Throw" }
};
ENT.Sounds = {
	[ MODE_SLEEP ] = "npc/zombie_poison/pz_warn1.wav",
	[ MODE_IDLE ] = {},
	[ MODE_ALERT ] = { "npc/zombie_poison/pz_warn2.wav", "npc/zombie_poison/pz_alert1.wav", "npc/zombie_poison/pz_pain1.wav" };
	[ "FOOTSTEPS" ] = { "npc/fast_zombie/foot1.wav", "npc/fast_zombie/foot2.wav", "npc/fast_zombie/foot3.wav", "npc/fast_zombie/foot4.wav" }
};

function ENT:Attack()
	self:EmitSound( self.Sounds[ MODE_ALERT ][ math.random(1,3) ] );
	self:PlaySequenceAndWait( self.Sequences[ MODE_ALERT ][ 1 ] );
	
	local effect = EffectData();
	local pos = self:GetPos() + Vector( 0, 0, 5 );
	
	effect:SetStart( pos );
	effect:SetOrigin( pos );
	effect:SetScale( 1 );
	util.Effect( "Explosion", effect );
	
	local Radius = ents.FindInSphere( pos, self.HitDist+80 );
	for k, v in pairs( Radius ) do
		if ( IsValid(v) && v:IsPlayer() && v:Alive() ) then
			v:SetHealth( v:Health() - self.Damage );
			
			local x, y, z = math.Rand( -9,94 ), math.Rand( -9, 9 ), math.Rand( -9, 9 );
			v:ViewPunchReset(0);
			v:ViewPunch( Angle( x, y, z ) );
			
			if ( v:Health() <= 0 ) then
				v:Kill();
			end
		end
	end
	self:Remove();
end