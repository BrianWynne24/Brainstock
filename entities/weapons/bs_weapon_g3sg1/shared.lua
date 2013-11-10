SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "ar2"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_rif_g3s.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_rif_galil.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 64;
SWEP.PrintName				= "G3SG-1";

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "";
SWEP.Delay					= 0.085;
SWEP.ShootSound				= Sound( "g3sg1.Shoot" );
SWEP.Recoil					= 1.0;
SWEP.Damage					= 30;
SWEP.NumShots				= 1;
SWEP.IronSpread				= 0.009;
SWEP.Spread					= 0.043;

SWEP.Primary.DefaultClip    = 0;
SWEP.Primary.ClipSize       = 20;
SWEP.Primary.Automatic      = true;
SWEP.Primary.Ammo			= "7.62x51mm";

SWEP.IronSightPos 			= Vector(-1.93, -4.016, 0.759);
SWEP.IronSightAng 			= Angle(-0.101, 0, 0);

SWEP.HolsterPos 			= Vector(0.2, 0, 0.56);
SWEP.HolsterAng 			= Angle(-12.701, -1, 0);