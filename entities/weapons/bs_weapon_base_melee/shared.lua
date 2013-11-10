SWEP.Base					= "weapon_base";
SWEP.HoldType 				= "melee"; //How the weapon should be held
SWEP.ViewModel				= ""; //How the gun looks in 1st person
SWEP.WorldModel				= ""; //How the gun looks in 3rd person
SWEP.ViewModelFOV			= 80;
SWEP.ViewModelFlip			= true;
SWEP.PrintName				= "#WEAPON_BASE";

SWEP.WeaponSlot				= ITEM_SLOT_MELEE;
SWEP.Delay					= 0.00;
SWEP.HitSound				= {};
SWEP.MissSound				= {};
SWEP.Damage					= 0;
SWEP.MaxCharge				= 0;
SWEP.StartHealth			= 0;

SWEP.Secondary.Automatic	= false;

SWEP.ChargePos				= Vector( 0, 0, 0 );
SWEP.ChargeAng				= Angle( 0, 0, 0 );

SWEP.HolsterPos				= Vector( 0, 0, 0 );
SWEP.HolsterAng				= Angle( 0, 0, 0 );

function SWEP:Initialize()
	self:SetDeploySpeed( 1.0 );
	self:SetHealth( self.StartHealth );
	self:SetWeaponHoldType( self.HoldType );
	
	self.nCharge = 0;
	
	self.bPlayed = false;
	self.nChargeDelay = 0;
	
	self.fNextCharge = 0;
end

function SWEP:AddHealth( hp )
	self:SetHealth( self:Health() - 5 );
end
function SWEP:GetHealth()
	return self:Health();
end

function SWEP:Precache()
end

function SWEP:Equip()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DEPLOY );
end

function SWEP:PrimaryAttack( charge )
	if ( !self:CanPrimaryAttack() ) then return; end
	self:DoHit();
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_VM_IDLE );
	if ( !self:CanSecondaryAttack() ) then return; end
end

function SWEP:CanPrimaryAttack()
	local pl = self.Owner;
	
	if ( pl:InSprint() || pl:InSafezone() || pl:WaterLevel() > 0 || pl:KeyDown( IN_ATTACK2 ) ) then
		return false;
	end
	return true;
end

function SWEP:CanHit()
	local tr_forward = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector() * 74, self.Owner );
	local tr_right = util.QuickTrace( self.Owner:GetShootPos(), (self.Owner:GetAimVector() * 74) + (self.Owner:GetRight() * 6), self.Owner );
	local tr_left = util.QuickTrace( self.Owner:GetShootPos(), (self.Owner:GetAimVector() * 74) + (self.Owner:GetRight() * -6), self.Owner );
	
	if ( tr_forward || tr_right || tr_left ) then
		if ( tr_forward.Hit ) then
			return "direct";
		elseif ( tr_left.Hit ) then
			return "sideleft";
		elseif ( tr_right.Hit ) then
			return "sideright";
		end
	end
	return nil;
end

function SWEP:DoHit()
	self.Owner:Hint( "You can charge your weapon by holding RMB" );
	local tr = self:CanHit();//util.QuickTrace( self.Owner:GetShootPos(), (self.Owner:GetAimVector() * 74), self.Owner );
	if ( tr ) then //We hit something
		self:EmitSound( self.HitSound );
		self:SendWeaponAnim( ACT_VM_HITCENTER );
		self:ShootBullet( self.Owner, tr );
		
		self:AddHealth( 5 );
		if ( self:GetHealth() <= 0 && SERVER ) then
			self.Owner:EmitSound( "physics/plastic/plastic_box_break" .. math.random(1,2) .. ".wav" );
			self.Owner:StripWeapon( self:GetClass() );
			/*for k, v in pairs( self.Owner:GetWeapons() ) do
				self.Owner:SelectWeapon( v:GetClass() );
				return;
			end*/
			return;
		end
	else
		self:EmitSound( self.MissSound );
		self:SendWeaponAnim( ACT_VM_MISSCENTER );
	end
	
	self.Owner:ViewPunchReset( 1 );
	self.Owner:ViewPunch( Angle( 2, 2, math.Rand(0.5,-0.5) ) );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self:SetNextPrimaryFire( CurTime() + self.Delay );
	self:SetNextSecondaryFire( CurTime() + 1 );
	
	self.fNextCharge = CurTime() + 1;
end

function SWEP:Think()
	local pl = self.Owner;
	
	if ( pl:KeyDown( IN_SPEED ) ) then
		self.nCharge = 0;
		return;
	end
	
	if ( pl:KeyDown( IN_ATTACK2 ) && CurTime() > self.fNextCharge ) then
		self:SendWeaponAnim( ACT_VM_IDLE );
		self.nCharge = self.nCharge + 15;
		if ( self.nCharge > self.MaxCharge ) then
			self.nCharge = self.MaxCharge;
		end
		self.fNextCharge = CurTime() + 0.05;
		self:SetNextPrimaryFire( CurTime() + self.Delay );
	elseif ( !pl:KeyDown( IN_ATTACK2 ) && self.nCharge > 0 ) then
		//self:PrimaryAttack( self.nCharge );
		self:SetNextPrimaryFire( CurTime() + self.Delay );
		self:DoHit();
		self.nCharge = 0;
		self.fNextCharge = CurTime() + 1;
	end
end

function SWEP:ShootBullet( pl, side )
	local dmg = self.Damage;
	local cone = 0;
	if ( side == "sideleft" || side == "sideright" ) then
		dmg = dmg - 5;
		if ( side == "sideleft" ) then
			cone = cone - 6;
		else
			cone = cone + 6;
		end
	end
	

	cone = self.Owner:GetAimVector() + (self.Owner:GetRight() * (cone/50));
	
	local bullet = {}
		bullet.Num 		  = 1;
		bullet.Src 		  = self.Owner:GetShootPos();
		bullet.Dir 		  = cone;
		bullet.Spread 	  = Vector(0, 0, 0);
		bullet.Tracer	  = 1;
		bullet.TracerName = TracerName;
		bullet.Force	  = self.Damage * 0.5;
		bullet.Damage	  = self.Damage * math.Clamp((self.nCharge/25), 1, 6);
		
	pl:FireBullets( bullet );
end

function SWEP:Reload()
end

function SWEP:Holster()
	self.nCharge = 0;
	return true;
end