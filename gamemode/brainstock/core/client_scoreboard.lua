
function GM:ScoreboardShow()
	_DrawScoreboard();
end

function GM:ScoreboardHide()
	if ( BrainStock.Scoreboard ) then
		BrainStock.Scoreboard:SetVisible( false );
		BrainStock.Scoreboard = nil;
	end
end

function _DrawScoreboard()
	local x = ScrW() / 2;
	local y = ScrH() / 2;
	
	BrainStock.Scoreboard = vgui.Create( "DFrame" );
	BrainStock.Scoreboard:SetPos( x * 0.63, y * 0 );
	BrainStock.Scoreboard:SetSize( x * 0.80, y * 2 );
	BrainStock.Scoreboard:SetTitle( "" );
	BrainStock.Scoreboard:SetDraggable( false );
	BrainStock.Scoreboard:ShowCloseButton( false );
	BrainStock.Scoreboard:SetVisible( true );
	BrainStock.Scoreboard:MakePopup();
	
	BrainStock.Scoreboard.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 160 ) );
		//draw.RoundedBox( 0, 0, 0, x * 2, y * 0.15, Color( 0, 0, 0, 200 ) );
		//draw.RoundedBox( 0, 0, y * 1.85, x * 2, y * 0.15, Color( 0, 0, 0, 200 ) );
		//draw.DrawText( "scoreboard", "Shaun_64", x * 0.10, y * 0.035, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		for k, v in pairs( player.GetAll() ) do
			local down = k*42;
			draw.RoundedBox( 0, 5, (y* 0.0) + down, self:GetWide() / 1.015, (y*0.08), Color( 60, 60, 60, 180 ) );
			draw.DrawText( v:Name(), "American_24", self:GetWide() / 14, (y * 0.015) + down, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
			local title = "NO TITLE";
			if ( v.StrTitle ) then title = v.StrTitle; end
			title = string.upper( title );
			
			draw.DrawText( "<" .. title .. ">", "American_24", self:GetWide() / 2, (y * 0.015) + down, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		end
	end
	
	/*for k, v in pairs( player.GetAll() ) do
		local fakePanel = vgui.Create( "DPanelList", BrainStock.Scoreboard );
		fakePanel:SetPos( 0, 0 );
		fakePanel:SetSize( Panel[ count ]:GetWide(), Panel[ count ]:GetTall() );
		fakePanel.Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 30, 30, 30, 100 ) )
			draw.DrawText( point.PrintName .. "\nAmount: " .. v .. "/" .. point.AmountMax, "American_24", self:GetTall() + 5, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
		end
	end*/
	for k, v in pairs( player.GetAll() ) do
		local down = k*42;
		local size = x * 0.04;
		local Icon = vgui.Create( "AvatarImage", BrainStock.Scoreboard );
		Icon:SetSize( size, size );
		Icon:SetPos( BrainStock.Scoreboard:GetWide() / 70, down + 2 );
		Icon:SetPlayer( v, 64 );
		if ( v != LocalPlayer() ) then
			local invite = vgui.Create( "DButton", BrainStock.Scoreboard );
			invite:SetPos( BrainStock.Scoreboard:GetWide()/1.06, (y * 0.015) + down );
			invite:SetSize( x * 0.03, (x * 0.03) );
			invite:SetText( "" );
			invite.Paint	= function( self )
				draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 30, 30, 30, 120 ) );
				if ( !Squad || (#Squad < 4 && !table.HasValue( Squad, v )) ) then
					draw.DrawText( "+", "American_24", self:GetWide()/2, -3, Color( 20, 200, 20, 255 ), TEXT_ALIGN_CENTER );
				else
					draw.DrawText( "X", "American_24", self:GetWide()/2, -3, Color( 200, 20, 20, 255 ), TEXT_ALIGN_CENTER );
				end
			end
			invite.DoClick = function( self )
				if ( !Squad || (#Squad < 4 && !table.HasValue( Squad, v )) ) then
					RunConsoleCommand( "bs_squad_invite", v:Name() );
				else
					RunConsoleCommand( "bs_squad_leave" );
				end
			end
		end
	end
end

//_DrawScoreboard();