SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "revolver"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_pist_usp4.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 62;
SWEP.PrintName				= "USP .40";

SWEP.WeaponSlot				= ITEM_SLOT_SECONDARY;
SWEP.Icon					= "icons/usp";
SWEP.Delay					= 0.2;
SWEP.ShootSound				= Sound( "usp4.Shoot" );
SWEP.Recoil					= 0.4;
SWEP.Damage					= 22;
SWEP.NumShots				= 1;
SWEP.Spread					= 0.032;
SWEP.IronSpread				= 0.012;
SWEP.AlertDist				= 1;
SWEP.MuzzleLight			= false;

SWEP.Primary.Ammo			= "9x19mm";
SWEP.Primary.ClipSize       = 12;
SWEP.Primary.DefaultClip    = 0;

SWEP.IronSightPos		 	= Vector(-1.961, -5.52, 0.239)
SWEP.IronSightAng 			= Angle(0.3, 0.1, 0)

SWEP.HolsterPos 			= Vector(0.2, 0, 1.159)
SWEP.HolsterAng 			= Angle(-14.4, -1.201, 0)

//SWEP.HolsterPos				= Vector( -1, 5, -14 );
//SWEP.HolsterAng				= Angle( 90, 0, 0 );