
local leanleft = 0;
local leanright = -5;
local slide = 0;

function BrainStock.CalcView( pl, origin, angles, fov )
	local view = { origin = origin, angles = angles, fov = fov };
	local wep = pl:GetActiveWeapon() or nil;
	
	local speed = 0.1;
	if ( pl:InSprint() && !pl:KeyDown( IN_DUCK ) ) then
		speed = 0.6;
	elseif ( pl:InIronsights() ) then
		speed = 0.05;
	end
	
	local peaktime = LastLeftPeek or 0;
	if ( pl:KeyDown( IN_USE ) && pl:LookingAtWall() && !pl:KeyDown( IN_SPEED ) && !pl:InSprint() ) then
		leanleft = leanleft + 0.15;
		if ( leanleft >= 7 ) then
			leanleft = 7;
		end
	elseif ( !pl:KeyDown( IN_USE ) && pl:LookingAtWall() && pl:KeyDown( IN_SPEED ) && !pl:InSprint() ) then
		leanright = leanright + 0.15;
		if ( leanright >= 7 ) then
			leanright = 7;
		end
	else
		if ( leanleft > 0 ) then
			leanleft = leanleft - 0.3;
			//if ( leanleft  0 ) then
			//	leanleft = 0;
			//end
		elseif ( leanright > 0 ) then
			leanright = leanright - 0.3;
			//if ( leanleft > 0 ) then
			//	leanleft = 0;
			//end
		end
	end
	
	local leaning = math.Clamp( leanleft, 0, 8 );
	if ( leaning <= 0 ) then
		leaning = -math.Clamp( leanright, 0, 8 );
	end
	
	view.angles.r = view.angles.r + leaning;
	view.origin = view.origin + view.angles:Right() * (leaning*2.8);
	
	if ( pl:GetVelocity():Length() > 40 ) then
		view.angles.r = view.angles.r + math.sin(CurTime() * 8) * speed;
		view.angles.p = view.angles.p + math.sin(CurTime() * 13) * speed;
	end
	
	if ( IsValid(wep) && wep.bScoped ) then
		view.fov = view.fov - 45;
	end
	
	if ( pl:IsSliding() ) then
		slide = slide + (FrameTime() * 100);
		if ( slide > 20 ) then
			slide = 20;
		end
	else
		if ( slide > 0 ) then
			slide = slide - (FrameTime() * 100);
		end
	end
	
	view.angles.r = view.angles.r + (slide/2.6);
	view.angles.p = view.angles.p - (slide/2.6);
	view.origin.z = view.origin.z - (slide*1.6);
	
	if ( IsValid( wep ) ) then
		local func = wep.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( wep, view.origin*1, view.angles*1 ) 
		end
		
		local func = wep.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov )
		end
	end
	return view;
end
hook.Add( "CalcView", "BrainStock.CalcView", BrainStock.CalcView );