SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "ar2"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_bs_m4col.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 70;
SWEP.PrintName				= "M4 Carbine";

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "icons/m4a1";
SWEP.Delay					= 0.13;
SWEP.ShootSound				= Sound( "Weapon_BSM4.Shoot" );
SWEP.Recoil					= 1.0;
SWEP.Damage					= 19;
SWEP.NumShots				= 1;
SWEP.Spread					= 0.035;
SWEP.IronSpread				= 0.013;
SWEP.AlertDist				= 1.6;
SWEP.ReloadOverride			= "reload_unsil";

SWEP.Primary.DefaultClip    = 0;
SWEP.Primary.ClipSize       = 30;
SWEP.Primary.Automatic      = true;
SWEP.Primary.Ammo			= "5.56x45mm";

SWEP.IronSightPos 			= Vector(-1.92, -4.961, -0.12);
SWEP.IronSightAng 			= Angle(1.1, -0.201, 0);

SWEP.HolsterPos 			= Vector(0, 0, 0);
SWEP.HolsterAng 			= Angle(-9.801, -2.8, 0);