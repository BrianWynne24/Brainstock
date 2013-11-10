include('shared.lua');

//ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Initialize()
	self:DrawShadow( false );
	self:SetRenderBounds( Vector(-40, -40, -18), Vector(40, 40, 84) );
end
		
function ENT:Draw()
	local owner = self:GetOwner();
	local offsetpos = self:GetDTVector(0);
	local offsetang = self:GetDTAngle(0);
	local click = self:GetDTString(0);
	
	if ( owner == LocalPlayer() ) then
		return;
	end
 
    //if ( owner:GetRagdollEntity() ) then
	//	owner = owner:GetRagdollEntity();
   // end
 
    /*local boneindex = owner:LookupBone( click );
    if (boneindex) then
         local pos, ang = owner:GetBonePosition( boneindex );
         if ( pos && pos != owner:GetPos() ) then
            self:SetPos(pos + offsetpos);
            self:SetAngles(ang + offsetang);
            self:DrawModel();
            return;
		end
	end*/
 
    local attach = owner:GetAttachment( owner:LookupAttachment(click) )
    if ( !attach ) then attach = owner:GetAttachment( owner:LookupAttachment("head") ); end
	
    if (attach) then
         self:SetPos(attach.Pos + (attach.Ang:Forward() * offsetpos[1]) + (attach.Ang:Right() * offsetpos[2]) + (attach.Ang:Up() * offsetpos[3]) );
         self:SetAngles(attach.Ang + offsetang);
         self:DrawModel();
    end
end

//function ENT:DrawTranslucent()
//	self:Draw();
//end