
include('shared.lua');

//SWEP.PrintName			= "#WEAPONBASE";
SWEP.Slot				= 0;
SWEP.SlotPos			= 0;
SWEP.DrawAmmo			= false;
SWEP.DrawCrosshair		= false;
SWEP.DrawWeaponInfoBox	= false;
SWEP.BounceWeaponIcon   = false;
SWEP.SwayScale			= 0.2;
SWEP.BobScale			= 0.2;
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE;
SWEP.ViewModelFOV		= 80;

function SWEP:GetViewModelPosition( pos, ang )
	local Right 		= ang:Right();
	local Up 			= ang:Up();
	local Forward 		= ang:Forward();
	
	ang = ang * 1;
	ang:RotateAroundAxis(ang:Right(), 	self.VMAng.p);
	ang:RotateAroundAxis(ang:Up(), 	self.VMAng.y);
	ang:RotateAroundAxis(ang:Forward(), self.VMAng.r);
		
	pos = pos + self.VMPos.x * Right;
	pos = pos + self.VMPos.y * Forward;
	pos = pos + self.VMPos.z * Up;
	
	return pos, ang;
end

function SWEP:TranslateFOV( current_fov )
	return current_fov;
end

function SWEP:DrawWorldModel()
	self.Weapon:DrawModel();
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel();
end

function SWEP:AdjustMouseSensitivity()
	return nil;
end

function SWEP:GetTracerOrigin()
/*
	local ply = self:GetOwner()
	local pos = ply:EyePos() + ply:EyeAngles():Right() * -5
	return pos
*/
end 