SWEP.Base					= "weapon_base";
SWEP.HoldType 				= "pistol"; //How the weapon should be held
SWEP.ViewModel				= ""; //How the gun looks in 1st person
SWEP.WorldModel				= ""; //How the gun looks in 3rd person
SWEP.ViewModelFOV			= 80;
SWEP.ViewModelFlip			= true;
SWEP.PrintName				= "#WEAPON_BASE";

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "";
SWEP.Delay					= 0.00;
SWEP.ShootSound				= Sound( "" );
SWEP.Recoil					= 0;
SWEP.Damage					= 0;
SWEP.NumShots				= 0;
SWEP.Spread					= 0;
SWEP.IronSpread				= 0;
SWEP.AlertDist				= 0;
SWEP.DmgFalloff				= true;
SWEP.MuzzleLight			= true;
//SWEP.UseHands				= true;

//SWEP.Secondary.Automatic    = true;
SWEP.Primary.ClipSize		= 0;
SWEP.Primary.DefaultClip    = 0;

SWEP.IronSightPos			= Vector( 0, 0, 0 );
SWEP.IronSightAng			= Angle( 0, 0, 0 );

SWEP.HolsterPos				= Vector( 0, 0, 0 );
SWEP.HolsterAng				= Angle( 0, 0, 0 );

function SWEP:Initialize()
	self:SetDeploySpeed( 1.0 );
	self:SetWeaponHoldType( self.HoldType );
	if ( CLIENT ) then self.FalseAmmo = self.Primary.ClipSize; end
	
	//if ( self.HoldType == "shotgun" ) then
		self.ReloadShellTime = CurTime();
		self.Reloading = false;
	//end
	self:InitUpgrades();
end

function SWEP:InitUpgrades()
	//BrainStock.WeaponUpgrades[ self:GetClass() ] = {};
	BrainStock.WeaponUpgrades[ self:GetClass() ] = { ["recoil"] = self.Recoil, ["delay"] = self.Delay, ["dmg"] = self.Damage, ["spread"] = self.Spread, ["ironspread"] = self.IronSpread };
end

function SWEP:Precache()
end

function SWEP:TranslateUpgrade( upgrade )
	local tbl = BrainStock.WeaponUpgrades[ self:GetClass() ][ upgrade ];
	if ( !self.Owner.WeaponUpgrades || !self.Owner.WeaponUpgrades[ self:GetClass() ] ) then return tbl; end
	
	local othertbl = self.Owner.WeaponUpgrades[ self:GetClass() ][ upgrade ]; //1, 2, 3
	
	if ( !othertbl || othertbl <= 1 ) then
		return tbl;
	end
	
	if ( upgrade == "recoil" ) then
		amt = .105;
	elseif ( upgrade == "delay" ) then
		amt = .006;
	elseif ( upgrade == "dmg" ) then
		amt = -1;
	elseif ( upgrade == "spread" ) then
		amt = .004;
	elseif ( upgrade == "ironspread" ) then
		amt = .003;
	end
	
	tbl = tbl - (othertbl*amt);
	if ( tbl < 0 ) then return 0; end
	
	return tbl;
end

function SWEP:Equip()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DEPLOY );
end

function SWEP:PrimaryAttack()
	if ( self.Weapon:Clip1() <= 0 && self.Owner:GetAmmoCount( self.Primary.Ammo ) >= 1 ) then
		if ( CLIENT ) then self.Owner:Hint( "You should reload your weapon" ); end
	end
	if ( !self:CanPrimaryAttack() ) then return; end
	
	if ( self.Reloading ) then
		self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
		self.Reloading = false;
		return;
	end
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self:EmitSound( self.ShootSound );
	self:ShootBullet( self.Owner );
	
	self:AlertZomb();
	self:SetNextPrimaryFire( CurTime() + self:TranslateUpgrade( "delay" ) );
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return; end
	
	local pl = self.Owner;
	if ( !pl:InIronsights() ) then
		pl:SetIronsights( true );
	end
end

function SWEP:CanPrimaryAttack()
	local pl = self.Owner;
	
	if ( pl:InSprint() || pl:InSafezone() || self.Weapon:Clip1() <= 0 || pl:LookingAtWall() || pl:IsSliding() || pl:GetMoveType() == MOVETYPE_LADDER ) then
		return false;
	end
	return true;
end

function SWEP:CanSecondaryAttack()
	local pl = self.Owner;
	
	if ( pl:InSprint() || pl:InSafezone() || pl:LookingAtWall() || pl:IsSliding() || pl:GetMoveType() == MOVETYPE_LADDER  ) then
		return false;
	end
	return true;
end

function SWEP:ShootBullet( pl )
	local fSpread = self.Spread;
	fSpread = self:TranslateUpgrade( "spread" );
	if ( pl:InIronsights() ) then
		fSpread = self:TranslateUpgrade( "ironspread" );
		fSpread = math.Clamp(fSpread+(pl:GetStamina()/25), 0.005, 0.042);
	elseif ( pl:GetStamina() > 0 ) then
		fSpread = math.Clamp((pl:GetStamina()/25), 0.018, 0.042);
	end
	
	local dmg = self:TranslateUpgrade( "dmg" );
	if ( self.DmgFalloff ) then 
		local dist = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector() * 10000, self );
		dist = self:GetPos():Distance(dist.HitPos);
		
		if ( dist > 1000 ) then
			dmg = dmg - math.Round((dist-1000)/500);
		end
	end

	//print( "DMG = " .. tostring(dmg) );
	local bullet = {}
		bullet.Num 		  = self.NumShots;
		bullet.Src 		  = self.Owner:GetShootPos();
		bullet.Dir 		  = self.Owner:GetAimVector();
		bullet.Spread 	  = Vector(fSpread, fSpread, 0);
		bullet.Tracer	  = 1;
		bullet.TracerName = TracerName;
		bullet.Force	  = dmg * 0.5;
		bullet.Damage	  = dmg;
		bullet.AmmoType   = self.Primary.Ammo;
		
	pl:FireBullets( bullet );
	pl:ViewPunchReset( 1 );
	
	local recoil = self:TranslateUpgrade( "recoil" );
	if ( pl:InIronsights() ) then
		recoil = recoil - math.Rand( 0, 1 );
	end
	pl:ViewPunch( Angle( -recoil, 0, math.Rand(1,-1) ) );
	
	self.Weapon:MuzzleFlash();
	
	self:TakePrimaryAmmo( 1 );
	
	/*if ( CLIENT ) then
		self:LightUp();
	end*/
	if ( SERVER && self.MuzzleLight ) then
		net.Start( "bs_Shoot" );
			net.WriteVector( self:GetPos() );
		net.Broadcast();
	end
end

function SWEP:Think()
	local pl = self.Owner;
	if ( pl:InIronsights() && !pl:KeyDown( IN_ATTACK2 ) || pl:InSprint() ) then
		pl:SetIronsights( false );
	end
	self:ReloadShotgun();
	
	if ( !CLIENT ) then return; end
	self:ClientThink();
end

function SWEP:Reload()
	if ( CLIENT ) then
		BrainStock.HUD.Fade( "ammo" )
		BrainStock.HUD.Fade( "health" )
	end
	if ( self:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 || self.Owner:InSprint() ) then return; end
	//self.Reloading = true;
	if ( self.HoldType == "shotgun" ) then
		if ( !self.Reloading && !self.Owner:InSprint() ) then
			self.Reloading = true;
			self.ReloadShellTime = CurTime() + 0.7;
			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START );
			self.Owner:SetAnimation( PLAYER_RELOAD );
		end
		return;
	end
	
	//self:DefaultReload( ACT_VM_RELOAD );
	local ammo = self.Owner:GetAmmoCount( self.Primary.Ammo ) + self:Clip1();
	local currentmag = self:Clip1();
	if ( ammo >= self.Primary.ClipSize ) then
		currentmag = self.Primary.ClipSize - currentmag;
		self:SetClip1( self.Primary.ClipSize );
		if ( SERVER ) then self.Owner:RemoveAmmo( currentmag, self.Primary.Ammo ); end
	else
		if ( ammo <= 0 ) then
			return;
		else
			self:SetClip1( ammo );
			if ( SERVER ) then self.Owner:RemoveAmmo( self.Owner:GetAmmoCount( self.Primary.Ammo ), self.Primary.Ammo ); end
		end
	end
	
	local fast = 1.0;
	local override = "reload";
	if ( self.Owner:HasPerk( "perk_fastreload" ) ) then
		fast = 1.35;
	end
	if ( self.ReloadOverride ) then
		override = self.ReloadOverride;
	end
	
	local vm = self.Owner:GetViewModel();
	local seq = vm:LookupSequence( override );
	
	vm:ResetSequence( seq );
	vm:SetPlaybackRate( fast );
	vm:SetCycle( 0 );
	
	local dur = vm:SequenceDuration()/fast;
	self:SetNextPrimaryFire( CurTime() + dur );
	self:SetNextSecondaryFire( CurTime() + dur );
	self.NextReload = CurTime() + dur;
	
	self.Owner:SetAnimation( PLAYER_RELOAD );

	local pl = self.Owner;
	pl:SetIronsights( false );
end

function SWEP:ReloadShotgun()
	if ( !self.Reloading || CurTime() < self.ReloadShellTime ) then return; end
	
	if ( self.Owner:KeyDown( IN_SPEED ) ) then
		self.PlayedEnd = true;
	end
	
	if ( self.PlayedEnd ) then
		self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
		self:SetNextPrimaryFire( CurTime() + self:TranslateUpgrade( "delay" ) );
		self.PlayedEnd = false;
		self.Reloading = false
		return;
	end
	
	self:SendWeaponAnim( ACT_VM_IDLE );
	
	local fast = 1.0;
	local delay = CurTime() + 0.7;
	if ( self.Owner:HasPerk( "perk_fastreload" ) ) then
		fast = 1.30;
		delay = CurTime() + 0.55;
	end
	local vm = self.Owner:GetViewModel();
	/*vm:SetPlaybackRate( 1 );
	vm:ResetSequence( vm:LookupSequence("idle") );
	vm:SetCycle( 0 );*/
	
	vm:ResetSequence( vm:LookupSequence("insert") );
	vm:SetPlaybackRate( fast );
	vm:SetCycle( 0 );
	
	//self:SendWeaponAnim( ACT_VM_RELOAD );
	
	self.ReloadShellTime = delay;
				
	self:SetClip1( self:Clip1() + 1 );
	self.Owner:RemoveAmmo( 1, "Buckshot" );
	
	if ( self:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
		//self:SetClip1( self.Primary.ClipSize );
		self.PlayedEnd = true;
		self.ReloadShellTime = CurTime() + 0.3;
	end
end

function SWEP:Holster()
	local pl = self.Owner;
	pl:SetIronsights( false );
	self.Reloading = false;
	return true;
end

function SWEP:AlertZomb()
	if ( CLIENT || self.AlertDist <= 1 ) then return; end
	local Radius = ents.FindInSphere( self.Owner:GetPos(), (BrainStock.Configuration.SpotStand*self.AlertDist) );
	for k, v in pairs( Radius ) do
		if ( IsValid(v) && string.find( v:GetClass(), "npc_zombie" ) ) then
			local dist = self.Owner:GetPos():Distance( v:GetPos() );
			
			if ( IsValid(v) && self.Owner:Alive() && !v:HasValidEnemy() ) then
				self.Owner:Hint( "Gunshots can alert nearby zombies" );
				v:SetEnemy( self.Owner );
				v:SetMode( MODE_ALERT );
				return;
			end
		end
	end
end

hook.Add( "KeyRelease", "ReleaseDaKeyz", function( pl, key )
	if ( key == IN_SPEED || (pl:KeyDown(IN_SPEED) && key == IN_FORWARD) ) then
		pl.nLastSprint = CurTime();
		local weapon = pl:GetActiveWeapon();
		if ( !IsValid( weapon ) ) then return; end
		weapon:SetNextPrimaryFire( CurTime() + 0.25 );
		weapon:SetNextSecondaryFire( CurTime() + 0.25 );
	end
end );