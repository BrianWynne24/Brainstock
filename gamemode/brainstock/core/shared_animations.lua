local IdleActivityTranslate = { }
IdleActivityTranslate[ ACT_MP_STAND_IDLE ] 					= ACT_HL2MP_IDLE;
IdleActivityTranslate[ ACT_MP_WALK ] 						= ACT_HL2MP_WALK;
IdleActivityTranslate[ ACT_MP_RUN ] 						= ACT_HL2MP_RUN;
IdleActivityTranslate[ ACT_MP_CROUCH_IDLE ] 				= ACT_HL2MP_IDLE_CROUCH;
IdleActivityTranslate[ ACT_MP_CROUCHWALK ] 					= ACT_HL2MP_WALK_CROUCH;
IdleActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= ACT_HL2MP_GESTURE_RANGE_ATTACK;
IdleActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_HL2MP_GESTURE_RANGE_ATTACK;
IdleActivityTranslate[ ACT_MP_RELOAD_STAND ]		 		= ACT_HL2MP_GESTURE_RELOAD;
IdleActivityTranslate[ ACT_MP_RELOAD_CROUCH ]		 		= ACT_HL2MP_GESTURE_RELOAD;
IdleActivityTranslate[ ACT_MP_JUMP ] 						= ACT_HL2MP_JUMP_SLAM;
IdleActivityTranslate[ ACT_MP_SWIM_IDLE ] 					= ACT_HL2MP_SWIM;
IdleActivityTranslate[ ACT_MP_SWIM ] 						= ACT_HL2MP_SWIM;

function GM:TranslateActivity( ply, act )
	local act = act;
	local newact = ply:TranslateWeaponActivity( act );
	
	if( act == newact ) then
		return IdleActivityTranslate[ act ];
	end
	
	return newact;
end

function GM:CalcMainActivity( ply, velocity )
	ply.CalcIdeal = ACT_MP_STAND_IDLE;
	ply.CalcSeqOverride = -1;
	
	local spd = velocity:Length2D();
	
	if( GAMEMODE:HandlePlayerJumping( ply, velocity ) ) then
	elseif( ply:Crouching() ) then
		
		if( spd > 0.5 ) then
			ply.CalcIdeal = ACT_MP_CROUCHWALK;
		else
			ply.CalcIdeal = ACT_MP_CROUCH_IDLE;
		end
		
	else
		
		if( spd > 150 ) then
			ply.CalcIdeal = ACT_MP_RUN;
		elseif( spd > 0.5 ) then
			ply.CalcIdeal = ACT_MP_WALK;
		end
		
	end
	
	if ( ply:WaterLevel() == 2 || ply:WaterLevel() == 3 || ply:GetMoveType() == 8 ) then
		ply.CalcIdeal = ACT_MP_SWIM;
	end
	-- a bit of a hack because we're missing ACTs for a couple holdtypes
	if ( ply:IsSliding() && string.find( ply:GetModel(), "human" ) ) then
		ply.CalcSeqOverride = ply:LookupSequence( "laycouch1" ); //laycouch1 //injured1postidle //headcrabbedpost
	elseif ( !ply:IsSliding() ) then
		if ( ply.fSlideTime && CurTime() <= ply.fSlideTime ) then
			ply.CalcSeqOverride = ply:LookupSequence( "laycouch1_exit" );
		elseif ( ply.fSlideTime && CurTime() > ply.fSlideTime ) then
			if ( SERVER ) then ply:TranslateModel( "player" ); /*ply:UnLock()*/ end
			ply.fSlideTime = nil;
		end
	end
	
	if ( ply:GetSequence() != ply.CalcSeqOverride && ply.CalcSeqOverride != -1 ) then
		ply:ResetSequence( ply.CalcSeqOverride );
		ply:SetPlaybackRate( 1.0 );
		ply:SetCycle( 0 );
		//return ply.CalcIdeal, ply.CalcSeqOverride;
	end
	
	return ply.CalcIdeal, ply.CalcSeqOverride;
end

function GM:UpdateAnimation( ply, vel, maxspeed )
	
	local len = vel:Length2D();
	local movefactor = len / 600;
	ply:SetPoseParameter( "move_factor", movefactor );
	
	if ( ply:IsSliding() ) then
		if ( CLIENT ) then
			ply:SetPos( ply:GetPos() - Vector( 0, 0, 16 ) );
		end
		ply:SetRenderAngles( ply.slide_Angles + Angle( 0, 90, 0 ) );
	else
		if ( ply.fSlideTime && CurTime() <= ply.fSlideTime ) then
			if ( CLIENT ) then
				local pos = 16;
				pos = pos - (CurTime() - ply.fSlideTime)*40;
				pos = pos - 23;
				pos = math.Clamp( pos, 0, 16 );
				
				ply:SetPos( ply:GetPos() - Vector( 0, 0, pos ) );
			end
			local yaw = 90;
			yaw = yaw - (CurTime() - ply.fSlideTime)*160;
			yaw = yaw - 160;
			yaw = math.Clamp( yaw, 0, 90 );
			
			ply:SetRenderAngles( ply.slide_Angles + Angle( 0, yaw, 0 ) );
		end
	end
	self.BaseClass:UpdateAnimation( ply, vel, maxspeed );
end