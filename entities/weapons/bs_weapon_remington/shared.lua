SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "shotgun"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_shot_remington.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_shot_m3super90.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 60;
SWEP.PrintName				= "Remington 870";

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "icons/shotgun";
SWEP.Delay					= 0.8;
SWEP.ShootSound				= Sound( "870.Shoot" );
SWEP.Recoil					= 2.7;
SWEP.Damage					= 20;
SWEP.NumShots				= 8;
SWEP.Spread					= 0.10;
SWEP.IronSpread				= 0.08;
SWEP.AlertDist				= 1.8;

SWEP.Primary.DefaultClip    = 0;
SWEP.Primary.ClipSize       = 7;
SWEP.Primary.Automatic      = false;
SWEP.Primary.Ammo			= "Buckshot";

SWEP.IronSightPos 			= Vector(-1.969, -2.757, 1.159);
SWEP.IronSightAng 			= Angle(0.1, -0.101, 0);

SWEP.HolsterPos 			= Vector(0.119, 0, 0.8);
SWEP.HolsterAng				= Angle(-12.801, 10.699, 0);