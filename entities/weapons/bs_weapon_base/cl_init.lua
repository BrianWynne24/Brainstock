
include('shared.lua');

SWEP.Slot				= 0;
SWEP.SlotPos			= 0;
SWEP.DrawAmmo			= false;
SWEP.DrawCrosshair		= false;
SWEP.DrawWeaponInfoBox	= false;
SWEP.BounceWeaponIcon   = false;
SWEP.SwayScale			= 0.0;
SWEP.BobScale			= 0.3;
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE;
SWEP.ViewModelFOV		= 80;
/*SWEP.AttachmentOnWep    = nil;

SWEP.AttachmentBone     = "DSAFAL_Body";

SWEP.Attachments        = { "eotech" };*/

local IRONSIGHT_TIME = 0.25;

local MODE_NONE = 0;
local MODE_IRON = 1;
local MODE_HOL  = 2;

local JumpVar	= 0;

local function ViewModelSway( pl, pos, ang, Mode )
	local speed = pl:GetVelocity():Length()/10;
	speed = math.Clamp( speed, 0.1, 2 );
	
	local yaw = math.sin(CurTime() * 4) * (speed/8);
	local roll = math.cos(CurTime() * 5) * (speed/2.4);
	
	if ( Mode == MODE_HOL ) then
		yaw = yaw / 50;
		roll = roll / 50;
	end
	
	ang.y = ang.y + yaw;
	ang.r = ang.r + roll;
	
	return pos, ang;
end

function SWEP:GetViewModelPosition( pos, ang )
	
	local Mode = MODE_NONE;
	if ( self.Owner:InIronsights() ) then
		Mode = MODE_IRON;
	elseif ( self:WeaponLowered() ) then
		Mode = MODE_HOL;
	end
	
	if ( self.nMode != Mode ) then
		self.nMode = Mode;
		self.fIronTime = CurTime();
		
		if ( Mode == MODE_NONE ) then
			//self.SwayScale = 1.0;
			//self.BobScale = 0.3;
			//self:UpdateViewModelSway( pos, ang );
		else
			//self.SwayScale = 0.1;
			//self.BobScale = 0.1;
			//self:UpdateViewModelSway( 0.1, 0.1 );
		end
	end
	
	//Gun moves up a little when player is in the air
	if ( !self.Owner:OnGround() && JumpVar < 20 && self.Owner:GetMoveType() == MOVETYPE_WALK ) then
		JumpVar = JumpVar + 0.6;
		if ( JumpVar > 20 ) then
			JumpVar = 20;
		end
	elseif ( self.Owner:OnGround() && JumpVar > 0 ) then
		JumpVar = JumpVar - 1.2;
	end
		
	pos.z = pos.z + (JumpVar/80);
	ang.p = ang.p - (JumpVar/5);
	
	local fIronTime = self.fIronTime or 0;
	if ( Mode == MODE_NONE && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		//pos, ang = ViewModelSway( self.Owner, pos, ang );
		return pos, ang;
	end
	
	local Mul = 1.0;
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 );
		if ( Mode == MODE_NONE ) then Mul = 1 - Mul; end
	end

	if ( self.Scoped && Mul >= 1 && Mode == MODE_IRON ) then
		self.Owner:DrawViewModel( false );
		self.bScoped = true;
		return;
	else
		self.Owner:DrawViewModel( true );
		self.bScoped = false;
	end
	
	local view = { pos = pos, ang = ang };
	if ( Mode == MODE_IRON || self:EndIron() ) then
		view.pos = self.IronSightPos;
		view.ang = self.IronSightAng;
	elseif ( Mode == MODE_HOL || self:EndSprint() ) then
		view.pos = self.HolsterPos;
		view.ang = self.HolsterAng;
		
		//local extra_pos, extra_ang = ViewModelSway( self.Owner, view.pos, view.ang, Mode );
		//view.ang = view.ang + extra_ang;
		//view.pos = view.pos + extra_pos;
	else
		//return view.pos, view.ang
	end
	
	if (self.Owner:GetStamina() > 0 && self.Owner:InIronsights()) then
		local stam = self.Owner:GetStamina() * 1.3;
		local up = math.sin(CurTime() * 6) * stam;
		local ri = math.cos(CurTime() * 8) * stam;
		
		view.ang.p = (up/17);
		view.ang.y = (ri/22);
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

local mat = Material( "models/weapons/v_toolgun/screen" );
local txt = GetRenderTarget( "GMODToolgunScreen", 256, 256 );

function SWEP:DrawHUD()
	if ( !self.bScoped ) then return; end
	
	local x, y = ScrW()/2, ScrH()/2;
	
	local stamx = math.sin(CurTime() * 4) * (self.Owner:GetStamina()*1.4);
	local stamy = math.cos(CurTime() * 2) * (self.Owner:GetStamina()*1.4);
	local mat = surface.GetTextureID( "gmod/scope-refract" );
	
	surface.SetTexture( mat );
	surface.SetDrawColor( 0, 0, 0, 255 );
	surface.DrawTexturedRect( (x * 0.10) + (stamx), (y * -0.15) + (stamy), x * 1.80, y * 2.30 );
	
	local mat = surface.GetTextureID( "scope/scope_lens" );
	
	draw.RoundedBox( 0, 0, 0, x * 0.15, y * 2, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 0, x * 1.80, 0, x * 0.20, y * 2, Color( 0, 0, 0, 255 ) );
	
	surface.SetTexture( mat );
	surface.SetDrawColor( 0, 0, 0, 255 );
	surface.DrawTexturedRect( (x * 0.10) + (stamx), (y * -0.15) + (stamy), x * 1.80, y * 2.30 );
end

function SWEP:UpdateAttachments()
	if ( !self.AttachmentOnWep ) then return; end
	
	local vm = self.Owner:GetViewModel();
	local bone = vm:LookupBone( self.AttachmentBone );
	
	local pos, ang = vm:GetBoneMatrix( bone ):GetTranslation();
	
	print( "Bone -> " .. tostring( bone ) );
	for k, v in pairs( self.AttachmentOnWep ) do
		//v:SetPos( pos );
		//v:SetAngle( ang );
		v:SetParent( bone );
	end
end

function SWEP:CreateAttachments()
	print( "CreateAttachment -> Called" );
	if ( !self.Attachments ) then return; end
	
	for k, v in pairs( self.Attachments ) do
		if ( BrainStock.WeaponAttachments[ v ] ) then
			local mdl = BrainStock.WeaponAttachments[ v ].Model;
			local scale = BrainStock.WeaponAttachments[ v ].Scale;
			
			local vm = self.Owner:GetViewModel();
			
			local bone = vm:LookupBone( self.AttachmentBone );
	
			if ( !bone ) then return; end
			local pos, ang = vm:GetBoneMatrix( bone ):GetTranslation();
	
			local attach = ClientsideModel( mdl );
			attach:SetPos( pos );
			attach:SetAngles( vm:GetAngles() + Angle( 0, 90, 0 ) );
			attach:Spawn();
			//attach:SetModelScale( scale, 0 );
			attach:SetParent( vm );
			attach:SetAttachment( vm:GetAttachment("2") );
			
			table.insert( self.AttachmentOnWep, attach );
		end
	end
end

function SWEP:ClientThink()
	if ( self.FalseAmmo != self:Clip1() ) then
		BrainStock.HUD.Fade( "ammo" );
		self.FalseAmmo = self:Clip1();
	end
	if ( self.Owner:GetMoveType() == MOVETYPE_LADDER ) then
		if ( !self.Owner.nLastSprint ) then self.Owner.nLastSprint = 0; end
		self.Owner.nLastSprint = CurTime();
	end
end

function SWEP:Holster()
	if ( !self.AttachmentOnWep ) then return true; end
	for k, v in pairs( self.AttachmentOnWep ) do
		v:Remove();
	end
	self.AttachmentOnWep = nil;
	return true;
end

function SWEP:WeaponLowered()
	local pl = self.Owner;
	if ( pl:InSafezone() || pl:InSprint() || pl:LookingAtWall() || pl:IsSliding() || pl:GetMoveType() == MOVETYPE_LADDER ) then
		return true;
	end
	return false;
end

function SWEP:EndSprint()
	local pl = self.Owner;
	
	if ( !pl.nLastSprint ) then pl.nLastSprint = 0; end
	if ( CurTime() < (pl.nLastSprint + IRONSIGHT_TIME) ) then
		return true;
	end
	return false;
end

function SWEP:EndIron()
	local pl = self.Owner;
	
	if ( !pl.nLastIron ) then pl.nLastIron = 0; end
	if ( CurTime() < (pl.nLastIron + IRONSIGHT_TIME) ) then
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

function BrainStock.KeyRelease( pl, key )
	if ( key == IN_SPEED ) then
		pl.nLastSprint = CurTime();
	end
	
	if ( key == IN_FORWARD && pl:KeyDown( IN_SPEED ) && (pl:KeyDown( IN_MOVELEFT ) || pl:KeyDown( IN_MOVERIGHT )) ) then
		pl.nLastSprint = CurTime();
	end
	
	if ( key == IN_ATTACK2 ) then
		pl.nLastIron = CurTime();
	end
end
hook.Add( "KeyRelease", "Brainstock.KeyRelease", BrainStock.KeyRelease );