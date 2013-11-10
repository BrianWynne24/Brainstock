SWEP.Base					= "weapon_base";
SWEP.HoldType 				= ""; //How the weapon should be held
SWEP.ViewModel				= "models/props_lab/dogobject_wood_crate001a_damagedmax.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/items/item_item_crate.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFOV			= 0;
SWEP.ViewModelFlip			= true;
SWEP.PrintName				= "Supply Crate";

SWEP.WeaponSlot				= ITEM_SLOT_CRATE;
SWEP.Icon					= "";

SWEP.VMPos					= Vector( -1, 4, -24 );
SWEP.VMAng					= Angle( 0, 0, 90 );

SWEP.Primary.DefaultClip	= 0

function SWEP:Initialize()
	self.Weapon:SetClip1( 0 );
	self.Weapon.AmmoType = "None";
	self.Weapon.HoldType = "crate";
end

function SWEP:Precache()
end

function SWEP:Equip()
end

function SWEP:Deploy()
	if ( SERVER ) then
		self.Owner:SetWalkSpeed( 80 );
		self.Owner:SetIronsights( false );
	end
	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
end

function SWEP:Holster()
	if ( SERVER ) then
		self.Owner:SetWalkSpeed( self.Owner.nWalkSpeed );
		
		local pos = self.Owner:GetPos() + Vector( 0, 0, 15 );
		pos = pos + (self.Owner:GetForward() * 32)
		
		local crate = ents.Create( "ent_supplycrate" );
		crate:SetPos( pos );
		crate:SetAngles( self.Owner:GetAngles() );
		crate:Spawn();
		//crate:Activate();
		
		self.Owner:StripWeapon( "bs_weapon_crate" );
	end
	return true;
end