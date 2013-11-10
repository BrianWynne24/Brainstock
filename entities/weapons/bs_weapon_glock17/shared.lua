SWEP.Base		 		    = "bs_weapon_base";
SWEP.HoldType 				= "revolver"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_glock18_weap.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_pist_glock18.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= true;
SWEP.ViewModelFOV 			= 60;
SWEP.PrintName				= "Glock 17";

SWEP.WeaponSlot				= ITEM_SLOT_SECONDARY;
SWEP.Icon					= "icons/glock";
SWEP.Delay					= 0.22;
SWEP.ShootSound				= Sound( "Glock18_Weap.Shoot" );
SWEP.Recoil					= 0.6;
SWEP.Damage					= 27;
SWEP.NumShots				= 1;
SWEP.Spread					= 0.032;
SWEP.IronSpread				= 0.01;
SWEP.AlertDist				= 1.4;
SWEP.ReloadOverride			= "glock_reload";
//SWEP.UseHands				= true;

SWEP.Primary.Ammo			= "9x19mm";
SWEP.Primary.ClipSize       = 10;
SWEP.Primary.DefaultClip    = 0;

SWEP.IronSightPos 			= Vector(2, -5, 1.12);
SWEP.IronSightAng			= Angle(0.2, -0.101, -0.276);

SWEP.HolsterPos				= Vector(0.959, 0, 2.2);
SWEP.HolsterAng             = Angle(-17.201, 4.4, 0);

//SWEP.HolsterPos				= Vector( -1, 5, -14 );
//SWEP.HolsterAng				= Angle( 90, 0, 0 );