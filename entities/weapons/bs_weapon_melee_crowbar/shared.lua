SWEP.Base		 		    = "bs_weapon_base_melee";
SWEP.HoldType 				= "melee"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_crowbar.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_crowbar.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFlip 			= false;
SWEP.ViewModelFOV 			= 50;
SWEP.PrintName				= "Crowbar";

SWEP.Icon					= "icons/crowbar";
SWEP.Delay 					= 0.5;
SWEP.MaxCharge				= 40;
SWEP.Damage 				= 30;
SWEP.HitSound				= Sound( "Weapon_Crowbar.Melee_Hit" );
SWEP.MissSound				= Sound( "Weapon_Crowbar.Single" );
SWEP.StartHealth 			= 100;

SWEP.ChargePos 				= Vector(-5.321, -19.08, 4.28);
SWEP.ChargeAng 				= Angle(35.5, -9.9, 0);

SWEP.HolsterPos				= Vector(0.959, 0, 2.2);
SWEP.HolsterAng             = Angle(-17.201, 4.4, 0);