
include('shared.lua');

SWEP.Slot				= 0;
SWEP.SlotPos			= 0;
SWEP.DrawAmmo			= false;
SWEP.DrawCrosshair		= false;
SWEP.DrawWeaponInfoBox	= false;
SWEP.BounceWeaponIcon   = false;
SWEP.SwayScale			= 1.0;
SWEP.BobScale			= 0.3;
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE;
SWEP.ViewModelFOV		= 80;

local IRONSIGHT_TIME = 0.50;

local MODE_NONE = 0;
local MODE_CHAR = 1;
local MODE_HOL  = 2;

function SWEP:GetViewModelPosition( pos, ang )
	
	local Mode = MODE_NONE;
	
	local NEW_IRONSIGHTTIME = 0.15;
	if ( self.nCharge > 0 ) then
		Mode = MODE_CHAR;
		NEW_IRONSIGHTTIME = 1.00;
	elseif ( self:WeaponLowered() ) then
		Mode = MODE_HOL;
	end
	
	if ( self.nMode != Mode ) then
		self.nMode = Mode;
		self.fIronTime = CurTime();
		
		if ( Mode == MODE_NONE ) then
			self.SwayScale = 1.0;
			self.BobScale = 0.3;
		else
			self.SwayScale = 0.1;
			self.BobScale = 0.1;
		end
	end
	
	local fIronTime = self.fIronTime or 0;
	if ( Mode == MODE_NONE && fIronTime < CurTime() - NEW_IRONSIGHTTIME ) then 
		return pos, ang;
	end
	
	local Mul = 1.0;
	
	if ( fIronTime > CurTime() - NEW_IRONSIGHTTIME ) then
		Mul = math.Clamp( (CurTime() - fIronTime) / NEW_IRONSIGHTTIME, 0, 1 );
		if ( Mode == MODE_NONE ) then Mul = 1 - Mul; end
	end

	local view = { pos = pos, ang = ang };
	view.pos = self.HolsterPos;
	view.ang = self.HolsterAng;
	if ( Mode == MODE_CHAR || CurTime() < (self.fNextCharge-0.8) ) then
		view.pos = self.ChargePos;
		view.ang = self.ChargeAng;
	end
	
	if (self.nCharge > 0 && MODE == MODE_CHAR) then
		local char = math.Clamp( (self.nCharge/25), 0, 20 );
		local up = math.sin(CurTime() * 12) * char;
		local ri = math.cos(CurTime() * 10) * char;
		
		ang:RotateAroundAxis(ang:Right(), 		view.ang.p * up);
		ang:RotateAroundAxis(ang:Up(), 		view.ang.y * ri);
	end
		
	ang = ang * 1
	ang:RotateAroundAxis(ang:Right(), 		view.ang.p * Mul)
	ang:RotateAroundAxis(ang:Up(), 		view.ang.y * Mul)
	ang:RotateAroundAxis(ang:Forward(), 	view.ang.r * Mul)

	pos = pos + view.pos.x * ang:Right() * Mul;
	pos = pos + view.pos.y * ang:Forward() * Mul;
	pos = pos + view.pos.z * ang:Up() * Mul;

	return pos, ang;
end

function SWEP:EndSprint()
	local pl = self.Owner;
	
	if ( !pl.nLastSprint ) then pl.nLastSprint = 0; end
	if ( CurTime() < (pl.nLastSprint + IRONSIGHT_TIME) ) then
		return true;
	end
	return false;
end

function SWEP:WeaponLowered()
	local pl = self.Owner;
	if ( pl:InSafezone() || pl:InSprint() || pl:LookingAtWall() || pl:IsSliding() || pl:GetMoveType() == MOVETYPE_LADDER ) then
		return true;
	end
	return false;
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
end