include('shared.lua');

ENT.RenderGroup = RENDERGROUP_BOTH;

function ENT:Draw()
	local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
	if ( GetGlobalInt( "Mission_OBJ" ) > (mission.TimeLimit()*60)/2 ) then 
		return; 
	end
	self.Entity:DrawModel();
end

function ENT:DrawTranslucent()
	self:Draw();
end