SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "ar2"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_bs_ak47k.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_rif_ak47.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 65;
SWEP.PrintName				= "AK-47 Klashnikov";

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "icons/ak47";
SWEP.Delay					= 0.10;
SWEP.ShootSound				= Sound( "Weapon_BS47.Shoot" );
SWEP.Recoil					= 1.2;
SWEP.Damage					= 22;
SWEP.NumShots				= 1;
SWEP.Spread					= 0.04;
SWEP.IronSpread				= 0.02;
SWEP.AlertDist				= 1.6;
SWEP.ReloadOverride			= "reload_empty";

SWEP.Primary.DefaultClip    = 0;
SWEP.Primary.ClipSize       = 30;
SWEP.Primary.Automatic      = true;
SWEP.Primary.Ammo			= "7.62x51mm";

SWEP.IronSightPos 			= Vector(-1.8, -3.241, 0.6);
SWEP.IronSightAng 			= Angle(0, 0, 0);

SWEP.HolsterPos 			= Vector(-0.08, 0, 0.28);
SWEP.HolsterAng 			= Angle(-10.5, -1.3, 0);