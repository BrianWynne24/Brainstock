local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:InIronsights()
	//return self:GetNetworkedBool( "bIronSights" );
	return self.bIronsights or false;
end

function meta:GetHunger()
	//return self:GetNetworkedInt( "HUNGER" );
	return self.nHunger or 0;
end

function meta:GetStamina()
	//return self:GetNetworkedFloat( "STAMINA" );
	return self.fStamina or 0;
end

function meta:GetGoodEvil()
	//return self:GetNetworkedInt( "GOODEVIL" );
	return self.nGoodEvil or 0;
end

function meta:InSprint()
	if ( self:KeyDown( IN_SPEED ) && self:KeyDown( IN_FORWARD ) ) then
		return true;
	end
	return false;
end

function meta:InSafezone()
	return self.bInSafezone;
end

function meta:LookingAtWall()
	local tr = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 20, self );
	if ( tr.Hit && !string.find( tr.Entity:GetClass(), "npc_zombie" ) ) then
		if ( CLIENT ) then
			self.nLastSprint = CurTime();
		end
		return true;
	end
	return false;
end

function meta:Hint( str )
	if ( SERVER ) then
		if ( table.HasValue( self.Hints, str ) ) then return; end
		table.insert( self.Hints, str );
		net.Start( "bs_Hint" );
			net.WriteString( str );
		net.Send( self );
	else
		BrainStock.Hint( str );
	end
end

function meta:IsSliding()
	if ( self.bSliding ) then
		return true;
	end
	return false;
end

function meta:HasItem( item )
	if ( CLIENT ) then
		if ( Inventory && table.HasValue( Inventory, item ) ) then
			return true;
		end
		return false;
	else
		if ( self.Inventory && table.HasValue( self.Inventory, item ) ) then
			return true;
		end
		return false;
	end
end

function meta:HasPerk( perk )
	if ( !self.Perks || #self.Perks <= 0 ) then return false; end
	for k, v in pairs( self.Perks ) do
		if ( v == perk ) then
			return true;
		end
	end
	return false;
end

if ( CLIENT ) then
	
	function meta:PickupItem( class, amt )
		if ( !BrainStock.PickupItem ) then BrainStock.PickupItem = {}; end

		table.insert( BrainStock.PickupItem, { class = class, fade = 350, number = amt, tblnum = #BrainStock.PickupItem+1 } );
		surface.PlaySound( "physics/metal/weapon_footstep" .. math.random( 1, 2 ) .. ".wav" );
	end
	
	function meta:SetIronsights()
		return;
	end
end

//GAMEMODE HOOKS
//function GM:PlayerStepSoundTime( pl, num, bWalking )
	//if ( pl:IsSliding() ) then
	//	return -1;
	//end
	//return 0.5;
//end
	
function GM:PlayerFootstep( pl, pos, foot, sound )
	if ( pl:Crouching() || pl:InIronsights() ) then
		return true;
	end
	
	local volume = 40;
	if ( pl:InSprint() ) then
		volume = 100;
	end
	
	if ( CLIENT ) then
		pl:EmitSound( sound, volume );
	end
	return true;
end