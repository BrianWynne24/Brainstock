//Ammunition = {}; 
/*Casadis: http://puu.sh/3WvSP.png
Casadis: http://puu.sh/3WvTs.png
Casadis: http://puu.sh/3WvTM.png
Casadis: http://puu.sh/3WvU8.png
Casadis: http://puu.sh/3WvUs.png
*/
net.Receive( "bs_Inventory", function( len )
	local tbl = net.ReadTable();
	Inventory = tbl;
	
	surface.PlaySound( "physics/metal/weapon_footstep" .. math.random( 1, 2 ) .. ".wav" );
end );

net.Receive( "bs_Ironsights", function( len )
	local bool = net.ReadBit();
	
	LocalPlayer().bIronsights = tobool( bool );
	
	if ( bool ) then
		surface.PlaySound( "ironsights/iron_in.wav" );
	else
		surface.PlaySound( "ironsights/iron_out.wav" );
	end
end );

net.Receive( "bs_Shoot", function( len )
	local pos = net.ReadVector();
	
	local light = DynamicLight( 0 );
	if ( light ) then
		light.Pos = pos;
		light.r = 255;
		light.b = 125;
		light.g = 255;
		//light.a = 180;
		light.Brightness = 1;
		light.Size = 256;
		light.Decay = 100;
		light.DieTime = CurTime() + 0.02;
	end
end );


net.Receive( "bs_Slide", function( len )
	local bool = net.ReadBit();
	local pl = net.ReadEntity();
	
	if ( !IsValid( pl ) ) then return; end
	pl.bSliding = tobool( bool );
	//pl.fSlideTime = CurTime();
	
	if ( bool ) then
		pl.slide_Angles = pl:EyeAngles();
	end
	
	pl.fSlideTime = CurTime() + 1;
	
	if ( LocalPlayer() != pl ) then return; end
	LocalPlayer().nLastSprint = CurTime();
end );

net.Receive( "bs_Shield", function( len )
	local int = net.ReadInt(8);
	
	BrainStock.HUD.Fade( "health" );
	LocalPlayer()._shieldrecharge = int;
end );

net.Receive( "bs_Hunger", function( len )
	local amt = net.ReadInt( 8 );
	
	LocalPlayer().nHunger = amt;
end );

net.Receive( "bs_Stamina", function( len )
	local amt = net.ReadInt(8);

	LocalPlayer().fStamina = amt;
	
	if ( !sStamSound && IsValid( LocalPlayer() ) ) then
		sStamSound = CreateSound( LocalPlayer(), Sound("player/breathe1.wav") );
	end
	
	if ( !sStamSound ) then return; end
		
	if ( amt <= 10 ) then
		sStamSound:FadeOut( 11 );
	elseif ( amt >= 12 ) then
		sStamSound:Play();
	end
end );

net.Receive( "bs_GoodEvil", function( len )
	local amt = net.ReadInt( 8 );
	
	LocalPlayer().nGoodEvil = amt;
end );

net.Receive( "bs_Squad", function( len )
	local tbl = net.ReadTable();
	
	Squad = tbl;
	if ( table.HasValue( Squad, LocalPlayer() ) ) then
		for k, v in pairs( Squad ) do
			if ( v == LocalPlayer() ) then
				table.remove( Squad, k );
			end
		end
	end
	
	if ( dAvatar ) then
		for k, v in pairs( dAvatar ) do
			v:Remove();
		end
		dAvatar = {};
	end
end );

net.Receive( "bs_ResTime", function( len )
	local amt = net.ReadInt( 8 );
	
	LocalPlayer().nRespawnTime = amt;
end );

net.Receive( "bs_mKillTime", function( len )
	local amt = net.ReadInt( 8 );
	
	LocalPlayer().nKillTime = amt;
end );

net.Receive( "bs_misEnd", function( len )
	local num = net.ReadInt( 4 );
	
	nMissionStatus = num;
	
	if ( (num - 1) > 0 ) then
		surface.PlaySound( "brainstock/mission/obj_complete.wav" );
	else
		surface.PlaySound( "brainstock/mission/obj_failed.wav" );
	end
end );

net.Receive( "bs_AchieveUnlock", function( len )
	local bool = net.ReadBit();
	local str = net.ReadString();
	
	bool = tobool( bool );
	if ( !bool ) then return; end
	
	if ( !Achievements ) then Achievements = {}; end
	
	if ( BrainStock.Achievements[ str ] ) then
		table.insert( Achievements, str );
		//bTrophyEnded = false;
	end
end );

net.Receive( "bs_LootBody", function( len )
	local ent = net.ReadEntity()
	local tbl = net.ReadTable();
	
	ent.Inventory = tbl;
	LootCorpse = tbl;
end );

net.Receive( "bs_Perk", function( len )
	local tbl = net.ReadTable();
	LocalPlayer().Perks = tbl;
end );

function BrainStock.Hint( len )
	local str = net.ReadString() or len;
	
	if ( !Hints ) then Hints = {}; end
	if ( !Popup ) then Popup = {}; end
	if ( table.HasValue( Hints, str ) ) then return; end
	
	table.insert( Hints, str );
	table.insert( Popup, { hint = str, alpha = 720, num = (#Popup+1), time = CurTime() } );
end
net.Receive( "bs_Hint", BrainStock.Hint );

net.Receive( "bs_WepUpgrade", function( len )
	local tbl = net.ReadTable();
	
	LocalPlayer().WeaponUpgrades = tbl;
end );

net.Receive( "bs_Titles", function( len )
	local tbl = net.ReadTable();
	
	LocalPlayer().Titles = tbl;
end );

net.Receive( "bs_SetTitle", function( len )
	local pl = net.ReadEntity();
	local str = net.ReadString();
	
	if ( !IsValid( pl ) || !pl:IsPlayer() ) then return; end
	
	pl.StrTitle = str;
end );

net.Receive( "bs_KillIcon", function( len )
	local name = net.ReadString();
	local attacker = net.ReadString();
	
	if ( !KillIcons ) then KillIcons = {}; end
	table.insert( KillIcons, { killed = name, killer = attacker, alpha = 420 } );
end );

net.Receive( "bs_NVG", function( len )
	local bool = net.ReadBit();
	bool = tobool(bool);
	
	if ( bool ) then
		if ( !NVG ) then
			local light = DynamicLight( 0 );
			light.Pos = LocalPlayer():GetShootPos();
			light.r = 0;
			light.b = 0;
			light.g = 200;
			//light.a = 180;
			light.Brightness = 1;
			light.Size = 2600;
			//light.Decay = 1000;
			light.DieTime = CurTime() + 99999;
			
			NVG = light;
			surface.PlaySound( "nvg_on.wav" );
			return;
		end
	else
		if ( NVG ) then
			NVG.DieTime = CurTime();
			NVG = nil;
			
			surface.PlaySound( "nvg_off.wav" );
		end
	end
end );

function BrainStock.ClearInventory()
	if ( !Inventory ) then return; end
	
	for k, v in pairs( Inventory ) do
		Inventory[k] = nil;
	end
	Inventory = {};
end
usermessage.Hook( "Player_ClearInventory", BrainStock.ClearInventory );

function GM:Think()
	if ( NVG ) then
		NVG.Pos = LocalPlayer():GetShootPos() + Vector( 4, 4, 10 );
	end
end