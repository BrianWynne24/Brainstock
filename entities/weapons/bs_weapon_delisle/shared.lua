SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "ar2"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_snip_delsi.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_snip_scout.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= true;
SWEP.ViewModelFOV 			= 67;
SWEP.PrintName				= "Delisle Carbine";

SWEP.Scoped					= true;

SWEP.WeaponSlot				= ITEM_SLOT_PRIMARY;
SWEP.Icon					= "icons/vss";
SWEP.Delay					= 0.80;
SWEP.ShootSound				= Sound( "Delis.Single" );
SWEP.Recoil					= 2.0;
SWEP.Damage					= 80;
SWEP.NumShots				= 1;
SWEP.Spread					= 0.04;
SWEP.IronSpread				= 0;
SWEP.AlertDist				= 2;
SWEP.DmgFalloff				= false;

SWEP.Primary.DefaultClip    = 0;
SWEP.Primary.ClipSize       = 8;
SWEP.Primary.Automatic      = false;
SWEP.Primary.Ammo			= ".45 ACP";

SWEP.IronSightPos 			= Vector(3.16, -5.12, 0.439);
SWEP.IronSightAng 			= Angle(0, 0, 0);

SWEP.HolsterPos 			= Vector(-1.241, 0, 1.36);
SWEP.HolsterAng 			= Angle(-16.601, -16.4, 0);