function BrainStock.InvNext( pl )
	iWeaponSelection = iWeaponSelection + 1;
	
	if ( iWeaponSelection > #pl:GetWeapons() ) then
		iWeaponSelection = 1;
	end
	
	fWeaponDelay = CurTime() + 0.15;
	fWeaponPrintTime = CurTime() + 3.0;
end

function BrainStock.InvPrev( pl )
	iWeaponSelection = iWeaponSelection - 1;
	
	if ( iWeaponSelection < 1 ) then
		iWeaponSelection = #pl:GetWeapons();
	end
	
	fWeaponDelay = CurTime() + 0.15;
	fWeaponPrintTime = CurTime() + 3.0;
end

function BrainStock.SelectWeapon( pl )
	for k, v in pairs( pl:GetWeapons() ) do
	
		if ( k == iWeaponSelection ) then
			RunConsoleCommand( "bs_selectweapon", v:GetClass() );
			iWeaponSelection = k;
		end
		
	end
	
	fWeaponPrintTime = 0;
	fWeaponDelay     = 0;
end

function BrainStock.PickSlot( pl, bind )
	local selection = string.gsub( bind, "slot", "" );
	selection = tonumber( selection );
	
	iWeaponSelection = selection;
	
	if ( iWeaponSelection > #pl:GetWeapons() ) then
		iWeaponSelection = #pl:GetWeapons();
	end
	
	fWeaponPrintTime = CurTime() + 3.0;
end

function GM:PlayerBindPress( pl, bind, pressed )
	if ( !IsValid( pl:GetActiveWeapon() ) ) then return; end
	if ( bind == "invnext" && fWeaponDelay < CurTime() ) then
		BrainStock.InvNext( pl );
		return true; 
	elseif ( bind == "invprev" && fWeaponDelay < CurTime() ) then
		BrainStock.InvPrev( pl );
		return true;
	elseif ( string.find( bind, "+attack" ) && (fWeaponPrintTime > CurTime() || RadialMenuEnabled) ) then
		BrainStock.SelectWeapon( pl )
		return true;
	elseif ( string.find( bind, "slot" ) ) then
		BrainStock.PickSlot( pl, bind );
		return true;
	elseif ( bind == "+speed" || bind == "+duck" ) then
		if ( bind == "+speed" && pl:InIronsights() ) then
			return true;
		end
		if ( IsValid( pl:GetActiveWeapon() ) && pl:GetActiveWeapon():GetClass() == "bs_weapon_crate" ) then
			return true;
		end
		if ( pl:IsSliding() ) then
			return true;
		end
	elseif( bind == "impulse 100" ) then
		if ( pl:HasItem( "item_nvg" ) ) then
			RunConsoleCommand( "bs_nightvision" );
			return;
		end
		RunConsoleCommand( "bs_flashlight" );
	elseif ( bind == "+attack2" && (pl:InSprint() || pl:LookingAtWall() || pl:IsSliding()) ) then
		return true;
	elseif ( bind == "+moveleft" || bind == "+moveright" || bind == "+back" || bind == "+forward" || bind == "+jump" || bind == "+duck" ) then
		if ( pl:IsSliding() || (pl.fSlideTime && pl.fSlideTime <= CurTime()) ) then
			return true;
		end
	elseif ( bind == "+zoom" ) then
		return true;
	end
end

function GM:AdjustMouseSensitivity( sensitivity )
	local weapon = LocalPlayer():GetActiveWeapon();
	if ( !IsValid( weapon ) ) then return; end
	
	if ( LocalPlayer():InIronsights() ) then
		if ( !weapon.bScoped ) then
			return 0.6;
		else
			return 0.1;
		end
	end
	return -1;
end