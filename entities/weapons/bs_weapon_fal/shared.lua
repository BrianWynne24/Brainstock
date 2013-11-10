SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "ar2"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_dsa_fall.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_rif_galil.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 60;
SWEP.PrintName				= "FAL-SA58 Carbine";

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "icons/fal";
SWEP.Delay					= 0.10;
SWEP.ShootSound				= Sound( "DSAFAL.Shoot" );
SWEP.Recoil					= 1.3;
SWEP.Damage					= 35;
SWEP.NumShots				= 1;
SWEP.IronSpread				= 0.011;
SWEP.Spread					= 0.035;
SWEP.ReloadOverride			= "reload_unsil";

SWEP.Primary.DefaultClip    = 0;
SWEP.Primary.ClipSize       = 20;
SWEP.Primary.Automatic      = true;
SWEP.Primary.Ammo			= "7.62x51mm";

SWEP.IronSightPos			= Vector( -2.02, -3.6, 0.86 );
SWEP.IronSightAng			= Angle( 0, 0, 0 );

SWEP.HolsterPos				= Vector( 0, 0, 0.3 );
SWEP.HolsterAng				= Angle( -8, -4, 0 );