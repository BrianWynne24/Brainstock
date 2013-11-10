//local PixVis = util.GetPixelVisibleHandle();

iWeaponSelection = 1;
fWeaponDelay     = 0;
fWeaponPrintTime = 0;

//Achievements
nAchievementSwipe = 2000;

//GoodEvil
nGoodEvil_Approach = 0;

//function GM:Initialize()
	surface.CreateFont( "Shaun_76", {
	font 		= "Shaun of the Dead",
	size 		= 76,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Shaun_64", {
	font 		= "Shaun of the Dead",
	size 		= 64,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Shaun_26", {
	font 		= "Shaun of the Dead",
	size 		= 26,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "CStrike_100", {
	font 		= "Counter-Strike",
	size 		= 100,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "CStrike_42", {
	font 		= "Counter-Strike",
	size 		= 42,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "CStrike_26", {
	font 		= "Counter-Strike",
	size 		= 26,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "BloodyImpact_46", {
	font 		= "BloodyImpact",
	size 		= 46,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "BloodyImpact_22", {
	font 		= "BloodyImpact",
	size 		= 22,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Square_24", {
	font 		= "SquareFont",
	size 		= 24,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Square_12", {
	font 		= "SquareFont",
	size 		= 12,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Rugged_64", {
	font 		= "Rugged Ride",
	size 		= 64,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Rugged_42", {
	font 		= "Rugged Ride",
	size 		= 42,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Rugged_54", {
	font 		= "Rugged Ride",
	size 		= 54,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Conv_24", {
	font 		= "Conviction",
	size 		= 24,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "American_18", {
	font 		= "American Captain",
	size 		= 18,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "American_24", {
	font 		= "American Captain",
	size 		= 24,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "American_42", {
	font 		= "American Captain",
	size 		= 42,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "American_72", {
	font 		= "American Captain",
	size 		= 72,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Amaz_54", {
	font 		= "AmazMegaGrungeOne",
	size 		= 54,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
	surface.CreateFont( "Rock_22", {
	font 		= "Rock's Death",
	size 		= 22,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
	} 	);
//end
	
/*========================
	HEADS UP DISPLAY
=========================*/
BrainStock.HUD.Fade_Health = 255;
BrainStock.HUD.Fade_Ammo = 255;

FakeHP = 0;
FakeArmor = 0;

function BrainStock.HUD.Main( pl, x, y )
	if ( !pl:Alive() || pl:GetObserverMode() != OBS_MODE_NONE ) then return; end
	
	if ( FakeHP != pl:Health() || FakeArmor != pl:Armor() ) then
		FakeHP = pl:Health();
		FakeArmor = pl:Armor();
		BrainStock.HUD.Fade( "health" );
	end
	
	local alpha = BrainStock.HUD.Fade_Health;
	if ( alpha > 0 ) then
		BrainStock.HUD.Fade_Health = alpha - (FrameTime()*80);
	end
	alpha = math.Clamp( BrainStock.HUD.Fade_Health, 0, 255 );
	
	draw.DrawText( "b", "CStrike_100", x * 0.03, y * 1.79, Color( 255, 255, 255, alpha ), TEXT_ALIGN_LEFT );
	draw.DrawText( pl:Health(), "American_42", x * 0.065, y * 1.76, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER );
	if ( pl:Armor() > 0 ) then
		draw.DrawText( "u", "CStrike_100", x * 0.15, y * 1.80, Color( 255, 255, 255, alpha ), TEXT_ALIGN_LEFT );
		draw.DrawText( pl:Armor(), "American_42", x * 0.18, y * 1.76, Color( 255, 255, 255, alpha ), TEXT_ALIGN_CENTER );
	end
end

function BrainStock.HUD.Ammo( pl, x, y )
	if ( !IsValid( pl:GetActiveWeapon() ) || !pl:Alive() ) then return; end
	local weapon = pl:GetActiveWeapon();

	local alpha = BrainStock.HUD.Fade_Ammo;
	if ( alpha > 0 ) then
		BrainStock.HUD.Fade_Ammo = alpha - (FrameTime()*80);
	end
	
	alpha = math.Clamp( alpha, 0, 255 );
	
	if ( weapon:IsMeleeWeapon() ) then
		local i = 2.25 * weapon:Health();
		draw.DrawText( weapon:Health(), "American_42", x * 1.90, y * 1.90, Color( math.Clamp(i,180,255), i, i, 255 ), TEXT_ALIGN_CENTER );
		return;
	end
	
	local ammo = pl:GetAmmoCount( weapon:GetPrimaryAmmoType() );
	local i = (weapon:Clip1() / weapon.Primary.ClipSize) * 100;
	i = i * 2.25
	i = math.Clamp( i, 140, 255 );
	
	draw.DrawText( weapon:Clip1(), "American_72", x * 1.88, y * 1.86, Color( i, i, i, alpha ), TEXT_ALIGN_CENTER );
	draw.DrawText( "/" .. ammo, "American_42", x * 1.98, y * 1.915, Color( 160, 160, 160, alpha ), TEXT_ALIGN_RIGHT );
end

function BrainStock.HUD.WeaponSelection( pl, x, y )
	if ( fWeaponPrintTime < CurTime() || !pl:Alive() ) then return; end
	
	for k, v in pairs( pl:GetWeapons() ) do
		v.col = Color( 0, 0, 0, 255 );
		v.pos = { y = 0 };
		if ( iWeaponSelection == k ) then
			v.col = Color( 255, 255, 255, 255 );
			v.pos.y = 10;
			
			draw.DrawText( "p", "CStrike_26", (x * 0.75) + (k * 128), y * 1.78, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		end
		//draw.DrawText( k .. ". " .. v.PrintName, "Rock_22", (x * 1.82) - v.pos.y, (y * 0.90) + (k * 36), v.col, TEXT_ALIGN_LEFT );
		//draw.RoundedBox( 0, (x * 0.70) + (k * 128), (y * 1.82) - v.pos.y, x * 0.10, x * 0.10, Color( 0, 0, 0, 60 ) );
		
		local img = v.Icon;
		local mat = Material( img .. ".png" );
		
		//surface.SetDrawColor( 255, 255, 255, 255 );
		//surface.SetMaterial( mat );
		//surface.DrawTexturedRect( ((x * 0.70) + (k * 128)) - 2, ((y * 1.82) - v.pos.y) - 2, (x * 0.10) + 4, (x * 0.10) + 4 );
		
		surface.SetDrawColor( 60, 60, 60, 255 );
		surface.SetMaterial( mat );
		surface.DrawTexturedRect( (x * 0.70) + (k * 128), (y * 1.82) - v.pos.y, x * 0.10, x * 0.10 );
	end
end

function BrainStock.HUD.Debug( pl, x, y )
	if ( !BrainStock.Configuration.Debug || !pl:Alive() ) then return; end
	
	draw.DrawText( BrainStock.Configuration.VerStatus, "Square_24", x, y * 1.94, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
	draw.DrawText( "Zombies: " .. #ents.FindByClass( "npc_zombie*" ) .. "\nItems: " .. #ents.FindByClass( "ent_item" ), "Square_24", x, y * 1.83, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
	//draw.DrawText( ".", "Square_24", x, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );		
end

function BrainStock.HUD.Death( pl, x, y )
	if ( !pl.nRespawnTime || pl:Alive() ) then return; end
	
	draw.DrawText( "Respawn In: " .. pl.nRespawnTime, "Default", x, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
end

function BrainStock.HUD.Achievement( pl, x, y )
	if ( !Achievements || #Achievements < 1 ) then return; end
	
	local Achievement_Name = BrainStock.Achievements[ Achievements[ 1 ] ].PrintName;
	local Achievement_Desc = BrainStock.Achievements[ Achievements[ 1 ] ].Description;
	
	if ( #Achievements > 0 ) then
		if ( nAchievementSwipe >= 2000 ) then
			pl:EmitSound( "brainstock/achievement.wav" );
		end
		
		//nAchievementSwipe = nAchievementSwipe - 10;
		if ( nAchievementSwipe >= -150 && nAchievementSwipe <= 150 ) then
			nAchievementSwipe = nAchievementSwipe - (FrameTime() * 80);
		else
			nAchievementSwipe = nAchievementSwipe - (FrameTime() * 1600);
		end
		
		draw.DrawText( Achievement_Name, "Square_24", x - nAchievementSwipe, y * 0.70, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER );
		draw.DrawText( Achievement_Desc, "Square_24", x + nAchievementSwipe, y * 0.76, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		
		if ( nAchievementSwipe <= -2000 ) then
			nAchievementSwipe = 2000;
			table.remove( Achievements, 1 );
		end
	end
end

function BrainStock.HUD.GoodEvil( pl, x, y )
end

function BrainStock.HUD.Mission( pl, x, y )
	if ( !BrainStock.Missions.IsServer() ) then return; end
	
	local text = "NULL";
	local mission = BrainStock.Missions[ BrainStock.Missions.Current ];
	
	if ( !nMissionStatus || nMissionStatus < 1 ) then
		if ( mission.Category == MISSION_CATEGORY_SUPPLIES ) then
			draw.DrawText( "Supply Crates: " .. GetGlobalInt( "Mission_OBJ" ) .. "/4", "Square_24", x, y * 0.03, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		elseif ( mission.Category == MISSION_CATEGORY_DEFEND ) then
			draw.DrawText( string.ToMinutesSeconds( GetGlobalInt( "Mission_OBJ" ) ), "Square_24", x * 1.015, y * 0.03, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
			draw.DrawText( "e", "CStrike_42", x * 0.975, y * 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
			if ( pl.nKillTime && pl.nKillTime > 0 ) then
				draw.DrawText( "Return to your team!\n" .. pl.nKillTime, "Square_24", x + math.Rand( -1.5, 1.5 ), y + math.Rand( -1.5, 1.5 ), Color( 200, 0, 0, 255 ), TEXT_ALIGN_CENTER );
			end
		end
		
		for i = 1, #mission.Objective() do
			for k, v in pairs( ents.FindByClass( mission.Objective()[ i ] ) ) do
				local pos = v:LocalToWorld( v:OBBCenter() );
				pos = pos:ToScreen();
						
				draw.DrawText( "p", "CStrike_26", pos.x, pos.y - 56, Color( 200, 10, 10, 255 ), TEXT_ALIGN_CENTER );
			end
		end
	
	else
		local bWin = tobool(nMissionStatus - 1);
		
		draw.DrawText( "Mission", "Base_64", x * 0.99, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
		if ( bWin ) then
			draw.DrawText( "Complete", "Skyfall 36", x, y * 1.04, Color( 0, 255, 0, 255 ), TEXT_ALIGN_LEFT );
		else
			draw.DrawText( "Failed", "Trashco_64", x * 1.01, y, Color( 200, 0, 0, 255 ), TEXT_ALIGN_LEFT );
		end
	end
end

function BrainStock.HUD.Squad( pl, x, y )
	if ( !Squad || #Squad < 1 ) then return; end
	
	//surface.SetTexture( surface.GetTextureID("gui/gradient") );
	//surface.SetDrawColor( 0, 0, 0, 180 );
	//surface.DrawTexturedRect( x * 0, y * 0.79, x * 0.25, (y * 0.125) + (#Squad * 28) );
	
	for k, v in pairs( Squad ) do
		if ( v != pl && IsValid(v) ) then
			surface.SetTexture( surface.GetTextureID("gui/gradient") );
			surface.SetDrawColor( 0, 0, 0, 180 );
			surface.DrawTexturedRect( x * 0, (y * 0.678) + (k * 52.5), x * 0.25, y * 0.115 );
		
			draw.DrawText( v:Name(), "Conv_24", x * 0.065, y * 0.71 + (k * 48), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
			if ( v:Alive() ) then
				//draw.RoundedBox( 0, x * 0.065, y * 0.76 + (k * 48), (x * 0.10), y * 0.02, Color( 20, 20, 20, 180 ) );
				//draw.RoundedBox( 0, x * 0.065, y * 0.76 + (k * 48), (x * 0.10) * (v:Health()/100), y * 0.02, Color( 255, 0, 0, 255 ) );
				draw.DrawText( "b", "CStrike_26", x * 0.065, y * 0.73 + (k * 54), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
				draw.DrawText( "t", "CStrike_26", x * 0.12, y * 0.73 + (k * 54), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
				draw.DrawText( v:Health(), "BloodyImpact_22", x * 0.085, y * 0.737 + (k * 54), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
				draw.DrawText( v:Armor(), "BloodyImpact_22", x * 0.138, y * 0.737 + (k * 54), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
			else
				draw.DrawText( "Deceased", "BudgetLabel", x * 0.065, y * 0.76 + (k * 48), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT );
			end
			
			if ( !dAvatar ) then dAvatar = {}; end
			
			if ( !dAvatar[ v ] ) then
				local size = x * 0.05;
				local Icon = vgui.Create( "AvatarImage" );
				Icon:SetSize( size, size );
				//Icon:SetModel( v:GetModel() );
				//Icon:SetCamPos( Vector( 18, -8, 65 ) );
				//Icon:SetLookAt( Vector( 0, 0, 65 ) );
				Icon:SetPos( x * 0.005, (y * 0.692) + (k * 52) );
				Icon:SetPlayer( v, 64 );
				//function Icon:LayoutEntity( Entity ) return; end
				
				dAvatar[ v ] = Icon;
			else
				dAvatar[ v ]:SetPos( x * 0.005, (y * 0.692) + (k * 52) );
			end
		end
	end
end

local hud_lastang = hud_lastang or Angle(0,0,0)
local function CalculateLastAng()
	local hl = {}
	hl.la = hud_lastang
	hl.ca = LocalPlayer():EyeAngles()
	
	if hl.la.y < -90 and hl.ca.y > 90 then
		hl.la.y = hl.la.y + 360
	elseif hl.la.y > 90 and hl.ca.y < -90 then
		hl.la.y = hl.la.y - 360
	end
	
	hl.x = (hl.ca.y - hl.la.y)*3
	hl.y = (hl.la.p - hl.ca.p)*3
	hl.nm = .1
	hl.na = Angle((hl.ca.p * hl.nm + hl.la.p)/(hl.nm + 1),(hl.ca.y * hl.nm + hl.la.y)/(hl.nm + 1), (hl.ca.r * hl.nm + hl.la.r)/(hl.nm + 1))
	hud_lastang = hl.na
	
	return hl.x, hl.y
	
end

function BrainStock.HUD.Safezone( pl, x, y )
	if ( !pl:InSafezone() ) then return; end
	
	draw.DrawText( "In Safe-Zone", "American_42", x, y * 1.80, Color( 180, 40, 40, 255 ), TEXT_ALIGN_CENTER );
end

function BrainStock.HUD.Pickup( pl, x , y )
	if ( !BrainStock.PickupItem || #BrainStock.PickupItem < 1 ) then return; end

	for k, v in pairs( BrainStock.PickupItem ) do
		local item = BrainStock.Items[ v.class ];
		local clamp = math.Clamp(v.fade, 0, 180);
		local y_move = (v.fade * -1);

		if ( v.fade > (255+(v.tblnum*20)) ) then
			y_move = 0;
		else
			y_move = y_move + (255+(v.tblnum*20));
		end
		
		v.fade = v.fade - (FrameTime()*100);
		if ( v.fade < 1 ) then
			table.remove( BrainStock.PickupItem, k );
		end
		
		local str = item.PrintName;
		str = string.len( str );
		
		str = ((x * str)/(x*0.68))*8;
		
		local col = Color( 180, 255, 180, clamp );
		if ( tonumber(v.number) <= 0 ) then
			col = Color( 255, 60, 60, clamp );
			y_move = y_move * -1;
		end
		
		local w, h = surface.GetTextSize( "Amaz_54" );
		
		//draw.RoundedBox( 0, x * 1.645, (y*1.22) - y_move, str, (h/2), Color( 0, 0, 0, clamp ) );
		draw.DrawText( item.PrintName, "Amaz_54", x * 1.66, ((y*1.20) - y_move) - (v.tblnum*20), col, TEXT_ALIGN_LEFT );
		draw.DrawText( item.PrintName, "Amaz_54", x * 1.66, ((y*1.20) - y_move) - (v.tblnum*20), col, TEXT_ALIGN_LEFT );
		
		//draw.RoundedBox( 0, x * 1.605, (y*1.22) - y_move, x * 0.035, (h/2), Color( 0, 0, 0, clamp ) );
		draw.DrawText( tostring(v.number), "Amaz_54", (x * 1.61), ((y*1.20) - y_move) - (v.tblnum*20), col, TEXT_ALIGN_LEFT );
	end
end

local rare = {};
rare[ ITEM_VERYCOMMON ] = Color( 200, 200, 200, 140 );
rare[ ITEM_COMMON ] = Color( 200, 200, 200, 140 );
rare[ ITEM_UNCOMMON ] = Color( 255, 255, 255, 140 );
rare[ ITEM_RARE ] = Color( 20, 160, 0, 140 );
rare[ ITEM_VERYRARE ] = Color( 98, 109, 255, 140 );
rare[ ITEM_MAXRARE ] = Color( 188, 128, 255, 140 );

function BrainStock.HUD.LookPlayer( pl, x, y )
	local tr = util.QuickTrace( pl:GetShootPos(), pl:GetAimVector()* 240, pl )
	if ( IsValid( tr.Entity ) && tr.Entity:IsPlayer() ) then
		tr.Entity.__faddee = 255;
	end
	
	for k, v in pairs( player.GetAll() ) do
		local dist = v:GetPos():Distance( pl:GetPos() )/10;
		if ( !v.__faddee ) then v.__faddee = 0; end
		if ( Squad && table.HasValue( Squad, v ) && dist <= 30 ) then
				v.__faddee = 255;
		end
		
		if ( v.__faddee > 0 ) then
			v.__faddee = v.__faddee - (FrameTime()*800);
			
			local pos = v:EyePos() + Vector( 0, 0, 15 );
			pos = pos:ToScreen();
			
			pos.y = pos.y - dist;
			
			pos.x = math.Clamp( pos.x, 50, ScrW()-50 );
			pos.y = math.Clamp( pos.y, 30, ScrH()-50 );
			
			local col = Color(200, 200, 200, v.__faddee);
			if ( Squad && #Squad > 0 && table.HasValue( Squad, v ) ) then
				col = Color(255, 255, 255, v.__faddee);
			end
			
			local title = "<NO TITLE>";
			if ( v.StrTitle ) then
				title = "<" .. v.StrTitle .. ">";
			end
			
			draw.DrawText( v:Name(), "American_24", pos.x, pos.y, col, TEXT_ALIGN_CENTER );
			draw.DrawText( title, "ChatFont", pos.x, pos.y + 19, Color( 0, 140, 255, v.__faddee ), TEXT_ALIGN_CENTER );
			draw.DrawText( "p", "CStrike_42", pos.x, pos.y + 15, col, TEXT_ALIGN_CENTER );
		end
	end
	
	for k, v in pairs( ents.FindInSphere( pl:GetPos(), 60 ) ) do
		if ( v:GetClass() == "ent_item"  ) then
			local dist = v:GetPos():Distance( pl:GetPos() )/10;
			local name = v:GetDTString(0);
			local rarer = v:GetDTInt(0);
			
			local pos = v:GetPos() + Vector( 0, 0, 20 );
			pos = pos:ToScreen();
			
			pos.y = pos.y - dist;
			
			//pos.x = math.Clamp( pos.x, 50, ScrW()-50 );
			//pos.y = math.Clamp( pos.y, 30, ScrH()-50 );
			
			local col = rare[ rarer ];
			
			draw.DrawText( name, "American_24", pos.x, pos.y, Color( 200, 200, 200, 160 ), TEXT_ALIGN_CENTER );
			draw.DrawText( "p", "CStrike_42", pos.x, pos.y, col, TEXT_ALIGN_CENTER );
		end
	end
end

function BrainStock.HUD.Hint( pl, x, y )
	if ( !Popup || #Popup <= 0 ) then return; end
	
	//local hint = string.lower(Popup[ 1 ].hint);
	//local alpha = Popup[ 1 ].alpha;
	
	/*if ( Hints && #Hints <= 2 && !playhintanim ) then //Draw their attention toward the hints
		playhintanim = CurTime() + 7;
	end
	
	if ( playhintanim && CurTime() < playhintanim ) then
		local time = playhintanim - CurTime();
		local col = (time * 20);
		col = math.Clamp( col, 0, 255 );
		
		//draw.RoundedBox( 0, x * 0, y * 0, x * 0.80, y * 0.16, Color( 0, 0, 0, col ) );
		surface.SetDrawColor( 255, 255, 255, col );
		surface.DrawOutlinedRect( x * 0, y * 0, (x * 0.80) - time*14, y * 0.16 );
	end*/
	
	for k, v in pairs( Popup ) do
		if ( k >= 3 ) then break; end
		local hint = v.hint;
		local alpha = v.alpha;
		local num = v.num * (y*0.05);
		local time = v.time;
		
		time = (CurTime() - time) * 100;
		time = math.Clamp( time, 0, x*0.03 );
		
		draw.DrawText( hint, "Rock_22", (x * 0.03) + time, (y * 0.01) + num, Color( 255, 255, 255, alpha ), TEXT_ALIGN_LEFT );
		draw.DrawText( "g", "CStrike_26", (x * 0) + time, (y * 0.0) + num, Color( 255, 255, 255, alpha ), TEXT_ALIGN_LEFT );
		
		v.alpha = alpha - (FrameTime()*100);
		if ( v.alpha <= 0 ) then
			table.remove( Popup, k );
		end
	end
end

RadialMenu = {};
	RadialMenu[ "Open Inventory" ] = { x = 1, y = 0.5, doclick = function() BrainStock.VGUI.Inventory() end };
	RadialMenu[ "Extra Test #1" ] = { x = 1, y = 1.5 };
	
function BrainStock.HUD.RadialMenu( pl, x, y )
	if ( !RadialMenuEnabled ) then return; end
	
	for k, v in pairs( RadialMenu ) do
		local mx, my = gui.MouseX(), gui.MouseY();
		local col = Color( 180, 180, 180, 255 );
		local wide, tall = surface.GetTextSize( k )/2,  x * 0.02;
		
		local posx, posy = v.x * x, v.y * y;
		
		if ( mx >= (posx - wide) && mx <= (posx + wide) && my <= (posy + tall) && my >= (posy - tall) ) then
			col = Color( 255, 0, 0, 255 );
			RadialCommandSelected = k;
		//else
			//RadialCommandSelected = nil;
		end
		
		draw.DrawText( k, "TargetID", posx, posy, col, TEXT_ALIGN_CENTER );
	end
end

function BrainStock.HUD.KillIcons( pl, x, y )
	if ( !KillIcons || #KillIcons <= 0 ) then return; end
	
	for k, v in pairs( KillIcons ) do
		v.alpha = v.alpha - (FrameTime()*100);
		
		local clamp = math.Clamp( v.alpha, 0, 255 );
		draw.DrawText( v.killer, "ChatFont", x * 1.70, (y * 0.02) + (k*16), Color( 255, 0, 0, clamp ), TEXT_ALIGN_RIGHT );
		draw.DrawText( "killed", "ChatFont", x * 1.73, (y * 0.02) + (k*16), Color( 180, 180, 180, clamp ), TEXT_ALIGN_CENTER );
		draw.DrawText( v.killed, "ChatFont", x * 1.76, (y * 0.02) + (k*16), Color( 0, 120, 200, clamp ), TEXT_ALIGN_LEFT );
		
		if ( v.alpha <= 0 ) then
			table.remove( KillIcons, k );
		end
	end
end

function BrainStock.HUD.Nightvision( pl, x, y )
	if ( !NVG ) then return; end
	/*local mat = surface.GetTextureID( "filmgrain/filmgrain" );
	surface.SetTexture( mat );
	surface.SetDrawColor( 0, 0, 0, math.Rand( 40, 60 ) );
	surface.DrawTexturedRect( x * 0, y * 0, x * 2, y * 2 )*/
	
	local mat2 = surface.GetTextureID( "nvg/nightvision" );
	surface.SetTexture( mat2 );
	surface.SetDrawColor( 0, 0, 0, math.Rand( 40, 60 ) );
	surface.DrawTexturedRect( x * 0, y * 0.095, x * 2, y * 1.82 );
	
	draw.RoundedBox( 0, x * 0, y * 0, x * 2, y * 0.095, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 0, x * 0, y * 1.91, x * 2, y * 0.095, Color( 0, 0, 0, 255 ) );
end

function BrainStock.HUD.DrawPerks( pl, x, y )
	if ( !pl.Perks || #pl.Perks <= 0 ) then return; end
	
	for k, v in pairs( pl.Perks ) do
		if ( BrainStock.Perks[ v ].Draw ) then
			BrainStock.Perks[ v ].Draw( pl, x, y );
		end
	end
end
//Put functions in here
function GM:HUDPaint()
	local pl = LocalPlayer();
	
	//local mod_x, mod_y = CalculateLastAng();
	
	local x = ScrW() / 2;
	local y = ScrH() / 2;
	
	//x = x + mod_x
	//y = y + mod_y
	
	BrainStock.HUD.Safezone( pl, x, y );
	
	//if ( pl.bInMenu ) then return; end
	
	draw.DrawText( BrainStock.Configuration.VerStatus, "Square_12", x, y * 0.01, Color( 255, 255, 255, 120 ), TEXT_ALIGN_LEFT );
	
	BrainStock.HUD.Nightvision( pl, x, y );
	BrainStock.HUD.Main( pl, x, y );
	BrainStock.HUD.Ammo( pl, x, y );
	BrainStock.HUD.Debug( pl, x, y );
	BrainStock.HUD.WeaponSelection( pl, x, y );
	BrainStock.HUD.LookPlayer( pl, x, y );
	BrainStock.HUD.Death( pl, x, y );
	BrainStock.HUD.Achievement( pl, x, y );
	//BrainStock.HUD.Mission( pl, x, y );
	//BrainStock.HUD.HitPoints( pl, x, y );
	BrainStock.HUD.Squad( pl, x, y );
	//BrainStock.HUD.GoodEvil( pl, x, y );
	BrainStock.HUD.Pickup( pl, x, y );
	BrainStock.HUD.Hint( pl, x, y );
	BrainStock.HUD.KillIcons( pl, x, y );
	BrainStock.HUD.DrawPerks( pl, x, y );
	//BrainStock.HUD.RadialMenu( pl, x, y );
	
	if ( input.IsKeyDown(KEY_Q) ) then
		if ( !BrainStock.VGUI.InventoryUp ) then
			BrainStock.VGUI.Inventory();
		end
	else
		if ( BrainStock.VGUI.InventoryUp ) then
			BrainStock.VGUI.SaveMousePos( x, y, true );
			gui.EnableScreenClicker( false );
			BrainStock.VGUI.InventoryUp:SetVisible( false );
			BrainStock.VGUI.InventoryUp = nil;
		end
	end
end

function BrainStock.HUD.Fade( str )
	if ( str == "ammo" ) then
		BrainStock.HUD.Fade_Ammo = 450;
	elseif ( str == "health" ) then
		BrainStock.HUD.Fade_Health = 450;
	end
end

function BrainStock.HUD.Hide( name )
	local Tbl = { 
	[ "CHudHealth" ] = true, 
	[ "CHudAmmo" ]   = true, 
	[ "CHudAmmoSecondary" ] = true, 
	[ "CHudBattery" ] = true,
	[ "CHudWeaponSelection" ] = true
	}; 
	
	if ( Tbl[ name ] ) then
		return false;
	end
end
hook.Add( "HUDShouldDraw", "BrainStock.HUD.Hide", BrainStock.HUD.Hide );

local tab =
{
 [ "$pp_colour_addr" ] = 0,
 [ "$pp_colour_addg" ] = 0,
 [ "$pp_colour_addb" ] = 0,
 [ "$pp_colour_brightness" ] = 0.2,
 [ "$pp_colour_contrast" ] = 0.6,
 [ "$pp_colour_colour" ] = 0.8,
 [ "$pp_colour_mulr" ] = 0,
 [ "$pp_colour_mulg" ] = 0,
 [ "$pp_colour_mulb" ] = 0
};

function GM:RenderScreenspaceEffects()
	if ( NVG ) then
		DrawColorModify( tab );
		DrawMaterialOverlay( "models/props_c17/fisheyelens", -0.04 )
		DrawMotionBlur( 0.5, 0.8, 0.01 );
	end
end

function GM:PlayerStartVoice( pl )
	if ( pl == LocalPlayer() ) then return; end
	
	if ( Squad && table.HasValue( Squad, pl ) ) then
		//LocalPlayer():EmitSound( "" );
		LocalPlayer():SetDSP( 38, false );
	end
end

function GM:PlayerEndVoice( pl )
	if ( Squad && table.HasValue( Squad, pl ) ) then
		//LocalPlayer():EmitSound( "" );
	end
	//LocalPlayer():GetDSP();
	LocalPlayer():SetDSP( 0, false );
end