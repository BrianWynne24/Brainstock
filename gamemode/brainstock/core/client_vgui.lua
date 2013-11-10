local x = ScrW() / 2;
local y = ScrH() / 2;

BrainStock.MousePos = {};
	BrainStock.MousePos.x = x;
	BrainStock.MousePos.y = y;

function BrainStock.VGUI.TitleScreen()
	local TitleMenu = vgui.Create( "DFrame" );
	TitleMenu:SetPos( x * 0, y * 0 );
	TitleMenu:SetSize( x * 2, y * 2 );
	TitleMenu:SetVisible( true );
	TitleMenu:SetTitle( "" );
	TitleMenu:SetDraggable( false );
	TitleMenu:ShowCloseButton( false );
	TitleMenu:MakePopup();
	
	TitleMenu.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 160 ) );
		draw.DrawText( "BraInstock", "Shaun_76", x * 0.10, y * 0.10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
		draw.DrawText( "welcome to hell comrade", "Shaun_26", x * 0.10, y * 0.21, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT );
	end
	
	local Panel = vgui.Create( "DPanelList", TitleMenu );
	Panel:SetPos( x * 0.50, y * 0.50 );
	Panel:SetSize( x * 1.10, y * 1.10 );
//	Panel:EnableVerticalScrollbar( true );
//	Panel:SetSpacing( 0 );
//	Panel:SetPadding( 3 );
	Panel.Paint = function( self ) -- Paint function
		//draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 10, 10, 10, 80 ) )
		//surface.SetDrawColor( 60, 60, 60, 255 );
		//surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() );
		//self:DrawOutlinedRect();
		
		//local changelog = file.Read( "gamemodes/brainstock/changelog.txt", true );
		//draw.DrawText( changelog, "Default", 5, 1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
	end
	
	local HTML = vgui.Create( "HTML", Panel );
	HTML:Dock( FILL );
	HTML:OpenURL( "http://hitmengaming.com/viewforum.php?f=77" );
	/*local ScrollBar = vgui.Create( "DVScrollBar", Panel );
	ScrollBar:SetSize( 16, 227 );
	ScrollBar:SetPos( Panel:GetWide() - 16, 23 );
	ScrollBar:SetUp( 1, 200 );
	ScrollBar:SetEnabled( true );*/
	
	//local changelog = file.Read( "gamemodes/brainstock/changelog.txt", true );
	
	local Label = vgui.Create( "DLabel" );
	Label:SetPos( 5, 0 );
	Label:SetColor( Color( 255, 255, 255, 255 ) );
	Label:SetFont( "Default" );
	Label:SetText( "" );
	//Label:SetWrap( true );
	Label:SizeToContents();
	
	local col = Color( 255, 255, 255, 255 );
	local Button = vgui.Create( "DButton", TitleMenu );
	Button:SetPos( x * 1.60, y * 1.80 );
	Button:SetSize( x * 0.36, y * 0.10 );
	Button:SetText( "" );
	Button.Think = function( self )
		local mx, my = gui.MouseX(), gui.MouseY();
		local bx, by = x * 1.60, y * 1.80;
		local wide, tall = self:GetWide(), self:GetTall();
		
		if ( mx >= bx && mx <= (bx + wide) && my >= by && my <= (by + tall) ) then
			col = Color( 180, 0, 0, 255 );
		else
			col = Color( 255, 255, 255, 255 );
		end
	end
	Button.Paint = function( self )
		draw.DrawText( "play game", "Shaun_64", 0, 0, col, TEXT_ALIGN_LEFT );
	end
	Button.DoClick = function()
		TitleMenu:SetVisible( false );
		//surface.PlaySound( "brainstock/play_game.wav" );
		RunConsoleCommand( "bs_joingame" );
	end
	
	Panel:AddItem( Label );
end
usermessage.Hook( "Brainstock_TitleScreen", BrainStock.VGUI.TitleScreen );
	
local drag = {};
	drag.cell = nil;
	drag.img  = nil;

function BrainStock.VGUI.Inventory()
	if ( BrainStock.VGUI.InventoryUp ) then return; end
	gui.EnableScreenClicker( true );
	timer.Simple( 0.01, function() 
		gui.SetMousePos( BrainStock.MousePos.x, BrainStock.MousePos.y );
	end );
	
	local frame = vgui.Create( "DFrame" );
	frame:SetPos( x * 0, y * 0 );
	frame:SetSize( x * 2, y * 2 );
	frame:SetVisible( true );
	frame:SetTitle( "" );
	frame:SetDraggable( false );
	frame:ShowCloseButton( false );
	frame:MakePopup();
	frame.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 160 ) );
		
		if ( !drag.cell ) then return; end
		local img = drag.img;
		local len = x * 0.085;
		
		img = Material( img .. ".png" );
		
		surface.SetDrawColor( 255, 255, 255, 255 );
		surface.SetMaterial( img );
		surface.DrawTexturedRect( gui.MouseX()-(len/2), gui.MouseY()-(len/2), len, len );
	end
	
	local butt = {};
		butt.vgui = {};
		butt.img = {};
		
	local closebutt = vgui.Create( "DButton", frame );
	closebutt:SetPos( 0, 0 );
	closebutt:SetSize( x * 2, y * 2 );
	closebutt:SetText( "" );
	closebutt.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 0 ) );
	end
	closebutt.DoClick	= function( self )
		if ( drag && drag.cell ) then
			if ( Inventory && #Inventory > 0 && Inventory[ drag.cell ] ) then
				item = BrainStock.Items[ Inventory[ drag.cell ] ];
				RunConsoleCommand( "bs_invdrop", item.Class, drag.cell );
				
				Inventory[drag.cell] = nil;
				butt.img[drag.cell] = "";
				
				drag.cell = nil;
			end
		end
		//BrainStock.VGUI.SaveMousePos( x, y );
		//frame:SetVisible( false );
	end
	closebutt.DoRightClick	= function( self )
		if ( drag && drag.cell ) then
			if ( Inventory && #Inventory > 0 && Inventory[ drag.cell ] ) then
				item = BrainStock.Items[ Inventory[ drag.cell ] ];
				RunConsoleCommand( "bs_invdrop", item.Class, drag.cell );
				
				Inventory[drag.cell] = nil;
				butt.img[drag.cell] = "";
				
				drag.cell = nil;
			end
		end
		//BrainStock.VGUI.SaveMousePos( x, y );
		//frame:SetVisible( false );
	end
	
	local panel = vgui.Create( "DPanelList", frame );
	panel:SetPos( x * 0.55, y * 1.69 );
	panel:SetSize( x * 0.878, y * 0.32 );
	panel:EnableHorizontal( true );
	panel:EnableVerticalScrollbar( false );
	panel:SetPadding( 1 );
	panel:SetSpacing( 2 );
	panel.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) );
	end
		
	for i = 1, BrainStock.Configuration.InventorySlots do //Draw Grid
		local txt = "Empty";
		local item = nil;
		butt.img[i] = nil;
		if ( Inventory && Inventory[i] ) then
			item = BrainStock.Items[ Inventory[i] ];
			txt = item.PrintName;
			butt.img[i] = item.Icon;
			
			//drag.img = img;
		end
		
		butt.vgui[i] = vgui.Create( "DButton" );
		butt.vgui[i]:SetPos( 0, 0 );
		butt.vgui[i]:SetSize( (x * 0.085), (x * 0.085) );
		butt.vgui[i]:SetText( "" );
		butt.vgui[i].Paint	= function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 60, 60, 60, 100 ) );
			if ( butt.img[i] && butt.img[i] != "" ) then
			
				local mat = Material( tostring(butt.img[i]) .. ".png" );
				surface.SetDrawColor( 255, 255, 255, 255 );
				surface.SetMaterial( mat );
				surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() );
			end
		end
		butt.vgui[i].PaintOver	= function( self )
			if ( butt.img[i] == "icons/no_icon" ) then
				local name = string.gsub( txt, " ", "#" );
				name = string.Explode( "#", name );
				
				local str = "";
				for i = 1, #name do
					str = str .. name[i] .. "\n";
				end
				draw.DrawText( str, "HudHintTextSmall", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
			end
			
			if ( drag.cell && butt.vgui[ drag.cell ] == butt.vgui[i] ) then
				draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 255, 0, 5 ) );
			end
		end
		butt.vgui[i].DoRightClick = function( self )
			if ( !drag.cell ) then
				if ( Inventory[i] ) then
					drag.cell = i; // a
					drag.img = butt.img[i];
				end
			else
				//self:SetText( drag.cell ); // a
				//butt[ drag._i ]:SetText( cell[drag._i] );
				
				//we have to set the cell that has now been clicked on the the one that
				//has previosuly been clicked on
				//cell[ drag._i ] = cell[i];
				//cell[ i ] = drag.cell;
				local store = butt.vgui[i];
				local img = butt.img[i];
				
				butt.vgui[i] = butt.vgui[drag.cell];
				butt.vgui[drag.cell] = store;
				
				butt.img[i] = butt.img[drag.cell];
				butt.img[drag.cell] = img;
				
				BrainStock.VGUI.UpdateCells( i );
				BrainStock.VGUI.SaveMousePos( x, y );
				
				//BrainStock.VGUI.InventoryUp:SetVisible( false );
				//BrainStock.VGUI.InventoryUp = nil;
				//timer.Simple( 0.0001, function() BrainStock.VGUI.Inventory() end );
				drag.cell = nil;
			end
		end
		butt.vgui[i].DoClick	= function( self )
			if ( drag.cell ) then
				local store = butt.vgui[i];
				local img = butt.img[i];
				
				butt.vgui[i] = butt.vgui[drag.cell];
				butt.vgui[drag.cell] = store;
				
				butt.img[i] = butt.img[drag.cell];
				butt.img[drag.cell] = img;
				
				BrainStock.VGUI.UpdateCells( i );
				BrainStock.VGUI.SaveMousePos( x, y );
				
				//BrainStock.VGUI.InventoryUp:SetVisible( false );
				//BrainStock.VGUI.InventoryUp = nil;
				//timer.Simple( 0.0001, function() BrainStock.VGUI.Inventory() end );
				drag.cell = nil;
				return;
			end
			
			if ( !item ) then return; end
			
			local class = item.Class;
			RunConsoleCommand( "bs_invuse", class, i );
			
			gui.EnableScreenClicker( false );
			
			drag.cell = nil;
			
			if ( Inventory[i] && !BrainStock.Items[ Inventory[i] ].DontRemoveOnUse() ) then
				//butt.vgui.vgui:Remove();
				butt.img[i] = "";
			end
			//BrainStock.VGUI.SaveMousePos( x, y );
			//frame:SetVisible( false );
			//BrainStock.VGUI.InventoryUp:SetVisible( false );
			//timer.Simple( 0.1, function() BrainStock.VGUI.InventoryUp = nil; end );
			return;
		end
		panel:AddItem( butt.vgui[i] );
	end
	
	BrainStock.VGUI.InventoryUp = frame;
	if ( !LocalPlayer().Titles ) then return; end
	
	/*local title_panel = vgui.Create( "DPanelList", frame );
	title_panel:SetPos( x * 0.55, y * 0.00 );
	title_panel:SetSize( x * 0.878, y * 0.32 );
	title_panel:EnableHorizontal( true );
	title_panel:EnableVerticalScrollbar( false );
	title_panel:SetPadding( 1 );
	title_panel:SetSpacing( 2 );
	title_panel.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) );
	end
	
	for k, v in pairs( LocalPlayer().Titles ) do
		local butt = vgui.Create( "DButton" );
		butt:SetPos( 0, 0 );
		butt:SetSize( title_panel:GetWide(), (x * 0.085) );
		butt:SetText( "" );
		butt.Paint	= function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 20, 20, 20, 60 ) );
			draw.DrawText( v, "American_24", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		end
		butt.DoClick	= function( self )
			RunConsoleCommand( "bs_settitle", v );
		end
		title_panel:AddItem( butt );
	end*/
	//BrainStock.VGUI.InventoryUp = frame;
end
//usermessage.Hook( "Brainstock_Inventory", BrainStock.VGUI.Inventory );

function BrainStock.VGUI.LootMenu()
	if ( !Inventory ) then Inventory = {}; end
	if ( !LootCorpse ) then return; end
	
	gui.SetMousePos( BrainStock.MousePos.x, BrainStock.MousePos.y );
		
	local frame = vgui.Create( "DFrame" );
	frame:SetPos( x * 0, y * 0 );
	frame:SetSize( x * 2, y * 2 );
	frame:SetVisible( true );
	frame:SetTitle( "" );
	frame:SetDraggable( false );
	frame:ShowCloseButton( false );
	frame:MakePopup();
	frame.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 160 ) );
	end
	
	local closebutt = vgui.Create( "DButton", frame );
	closebutt:SetPos( x * 0, y * 0 );
	closebutt:SetSize( x * 2, y * 2 );
	closebutt:SetText( "" );
	closebutt.Paint	= function()
	end
	closebutt.DoClick = function( self )
		BrainStock.VGUI.SaveMousePos();
		frame:SetVisible( false );
		
		gui.EnableScreenClicker( false );
	end

	local inventory_panel = vgui.Create( "DPanelList", frame );
	inventory_panel:SetPos( x * 0.55, y * 1.69 );
	inventory_panel:SetSize( x * 0.878, y * 0.32 );
	inventory_panel:EnableHorizontal( true );
	inventory_panel:EnableVerticalScrollbar( false );
	inventory_panel:SetPadding( 1 );
	inventory_panel:SetSpacing( 2 );
	inventory_panel.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) );
	end
	
	local loot_panel = vgui.Create( "DPanelList", frame );
	loot_panel:SetPos( x * 0.55, y * 1.30 );
	loot_panel:SetSize( x * 0.878, y * 0.315 );
	loot_panel:EnableHorizontal( true );
	loot_panel:EnableVerticalScrollbar( false );
	loot_panel:SetPadding( 1 );
	loot_panel:SetSpacing( 2 );
	loot_panel.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) );
	end
	
	local loot_butt = {};
	local inv_butt = {};
	for i = 1, BrainStock.Configuration.InventorySlots do
		loot_butt[i] = vgui.Create( "DButton" );
		loot_butt[i]:SetPos( 0, 0 );
		loot_butt[i]:SetSize( (x * 0.085), (x * 0.085) );
		loot_butt[i]:SetText( "" );
		loot_butt[i].Paint	= function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 60, 60, 60, 100 ) );
			if ( LootCorpse[i] ) then
				local img = BrainStock.Items[ LootCorpse[i] ].Icon;
				local mat = Material( img .. ".png" );
				
				surface.SetDrawColor( 255, 255, 255, 255 );
				surface.SetMaterial( mat );
				surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() );
			
				if ( img == "icons/no_icon" ) then
					local name = string.gsub( BrainStock.Items[ LootCorpse[i] ].PrintName, " ", "#" );
					name = string.Explode( "#", name );
					
					local str = "";
					for i = 1, #name do
						str = str .. name[i] .. "\n";
					end
					draw.DrawText( str, "HudHintTextSmall", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
				end
			end
		end
		loot_butt[i].DoClick = function( self )
			if ( LootCorpse[i] ) then
				BrainStock.VGUI.SaveMousePos();
				RunConsoleCommand( "bs_lootadd", BrainStock.Items[ LootCorpse[i] ].Class, i );
				frame:SetVisible( false );
			end
		end
		
		loot_panel:AddItem( loot_butt[i] );
		
		inv_butt[i] = vgui.Create( "DButton" );
		inv_butt[i]:SetPos( 0, 0 );
		inv_butt[i]:SetSize( (x * 0.085), (x * 0.085) );
		inv_butt[i]:SetText( "" );
		inv_butt[i].Paint	= function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 60, 60, 60, 100 ) );
			if ( Inventory[i] ) then
				local img = BrainStock.Items[ Inventory[i] ].Icon;
				local mat = Material( img .. ".png" );
				
				surface.SetDrawColor( 255, 255, 255, 255 );
				surface.SetMaterial( mat );
				surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() );
				
				if ( img == "icons/no_icon" ) then
					local name = string.gsub( BrainStock.Items[ Inventory[i] ].PrintName, " ", "#" );
					name = string.Explode( "#", name );
					
					local str = "";
					for i = 1, #name do
						str = str .. name[i] .. "\n";
					end
					draw.DrawText( str, "HudHintTextSmall", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
				end
			end
		end
		inv_butt[i].DoClick = function( self )
			if ( Inventory[i] ) then
				BrainStock.VGUI.SaveMousePos();
				RunConsoleCommand( "bs_lootrem", BrainStock.Items[ Inventory[i] ].Class, i );
				frame:SetVisible( false );
			end
		end
		
		inventory_panel:AddItem( inv_butt[i] );
	end
end
usermessage.Hook( "Brainstock_Lootmenu", BrainStock.VGUI.LootMenu );

function BrainStock.VGUI.Workbench()
	local weapon = LocalPlayer():GetActiveWeapon();
	if ( !IsValid( weapon ) || !BrainStock.WeaponUpgrades[ weapon:GetClass() ] ) then return; end
	
	local Workbench = vgui.Create( "DFrame" );
	Workbench:SetPos( x * 0, y * 0 );
	Workbench:SetSize( x * 2, y * 2 );
	Workbench:SetVisible( true );
	Workbench:SetTitle( "" );
	Workbench:SetDraggable( false );
	Workbench:ShowCloseButton( true );
	Workbench:MakePopup();
	
	Workbench.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 160 ) );
		draw.RoundedBox( 0, 0, 0, x * 2, y * 0.15, Color( 0, 0, 0, 200 ) );
		draw.RoundedBox( 0, 0, y * 1.85, x * 2, y * 0.15, Color( 0, 0, 0, 200 ) );
		draw.DrawText( "workbench", "Shaun_64", x * 0.10, y * 0.035, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
		
		//Actual Upgrades
		local i = 1;
		for k, v in pairs( BrainStock.WeaponUpgrades[ weapon:GetClass() ] ) do
			if ( k != "ironspread" ) then
				i = i + 1;
				//local Upgrade = LocalPlayer().WeaponUpgrades[ weapon:GetClass() ][k] or 1;
				local Upgrade = 0;
				if ( LocalPlayer().WeaponUpgrades && LocalPlayer().WeaponUpgrades[ weapon:GetClass() ] && LocalPlayer().WeaponUpgrades[ weapon:GetClass() ][k] ) then
					Upgrade = LocalPlayer().WeaponUpgrades[ weapon:GetClass() ][k];
				end
				draw.RoundedBox( 0, x * 0.58, (y * 1.63) + (i*16), x * 1, y * 0.02, Color( 0, 0, 0, 120 ) );
				draw.RoundedBox( 0, x * 0.58, (y * 1.63) + (i*16), (x * 1) * (Upgrade/3), y * 0.02, Color( 0, 255, 0, 120 ) );
				draw.DrawText( string.upper(k), "default", x * 0.50, (y * 1.63) + (i*16), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
			end
		end
	end
	
	i = 1;
	for k, v in pairs( BrainStock.WeaponUpgrades[ weapon:GetClass() ] ) do
		if ( k != "ironspread" ) then
			i = i + 1;
			local upgrade_button = vgui.Create( "DButton", Workbench );
			upgrade_button:SetPos( x * 1.612, (y*1.63) + (i*16) );
			upgrade_button:SetSize( x * 0.02, x * 0.015 );
			upgrade_button:SetText( "" );
			upgrade_button.Paint = function( self )
				draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 30, 30, 30, 120 ) );
				draw.DrawText( ">", "American_18", self:GetWide()/2, -3, Color( 200, 20, 20, 255 ), TEXT_ALIGN_CENTER );
			end
			upgrade_button.DoClick = function()
				RunConsoleCommand( "bs_weapon_upgrade", k );
				Workbench:SetVisible( false );
			end
		end
	end
	
end
usermessage.Hook( "Brainstock_Workbench", BrainStock.VGUI.Workbench );

function BrainStock.VGUI.SaveMousePos( x, y, bool )
	if ( bool ) then
		drag.cell = nil;
	end
	BrainStock.MousePos.x = gui.MouseX();
	BrainStock.MousePos.y = gui.MouseY();
end

function BrainStock.VGUI.UpdateCells(i)
	if ( !drag.cell ) then return; end
	
	local inv = Inventory[i];
	Inventory[i] = Inventory[drag.cell];
	Inventory[drag.cell] = inv;
	
	BrainStock.VGUI.UpdateServerInv();
end

function BrainStock.VGUI.UpdateServerInv()
	net.Start( "bs_Cells" );
		net.WriteEntity( LocalPlayer() );
		net.WriteTable( Inventory );
	net.SendToServer();
end