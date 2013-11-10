SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "revolver"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_rex_revolve.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_357.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 70;
SWEP.PrintName				= "MP412 Rex Revolver";

SWEP.WeaponSlot				= ITEM_SLOT_SECONDARY;
SWEP.Icon					= "icons/rexrevolver";
SWEP.Delay					= 0.45;
SWEP.ShootSound				= Sound( "Weapon_MP412.Shoot" );
SWEP.Recoil					= 1.6;
SWEP.Damage					= 50;
SWEP.NumShots				= 1;
SWEP.Spread					= 0.032;
SWEP.IronSpread				= 0.0096;
SWEP.AlertDist				= 1.9;

SWEP.Primary.Ammo			= ".357 Magnum";
SWEP.Primary.ClipSize       = 6;
SWEP.Primary.DefaultClip    = 0;

SWEP.IronSightPos 			= Vector(-2.32, -4, 0.56)
SWEP.IronSightAng 			= Angle(0.3, 0.2, 0)

SWEP.HolsterPos 			= Vector(-0.16, 0, 1.12)
SWEP.HolsterAng 			= Angle(-18.5, -0.201, 2.2)

//SWEP.HolsterPos				= Vector( -1, 5, -14 );
//SWEP.HolsterAng				= Angle( 90, 0, 0 );