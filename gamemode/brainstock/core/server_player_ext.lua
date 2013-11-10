local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end
/*=============================================
	Inventory
==============================================*/
function meta:InventorySlots()
	return table.Count( self.Inventory );
end

function meta:FindLowestSlot()
	for i = 1, BrainStock.Configuration.InventorySlots do
		if ( !self.Inventory[i] ) then
			return i;
		end
	end
	return false;
end

function meta:OnItemPickup( item, slot )
	if ( self:InventorySlots() >= BrainStock.Configuration.InventorySlots || !BrainStock.Items[ item.Class ] ) then 
		self:PrintChat( "You have to many items in your inventory" );
		return; 
	end
	
	//table.insert( self.Inventory, item.Class );
	if ( !slot || self.Inventory[ slot ] ) then
		self.Inventory[ self:FindLowestSlot() ] = item.Class;
	else
		self.Inventory[ slot ] = item.Class;
	end
	
	if ( IsValid( item ) && item:GetClass() == "ent_item" ) then
		item:Remove();
	end
	
	net.Start( "bs_Inventory" );
		net.WriteTable( self.Inventory );
	net.Send( self );

	self:Hint( "Hold Q to access your inventory" );
	
	self:Save_Inventory();
	self:Save_Position();
	self:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_GIVE );
end

function meta:OnItemDropped( item, slot )
	if ( !self:HasItem( item ) || !BrainStock.Items[ item ] || !self.Inventory[ slot ] ) then return; end
	
	local tr = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 64, self );
	local pos = tr.HitPos;
	
	local prop = ents.Create( "ent_item" );
	prop:SetPos( pos );
	prop:SetAngles( self:GetAngles() );
	prop:Spawn();
	prop:Activate();
	prop:SetModel( BrainStock.Items[ item ].Model );
	prop:SetDTString( 0, BrainStock.Items[ item ].PrintName );
	prop:SetDTInt( 0, BrainStock.Items[ item ].Rarity );
	//prop:SetOwner( self );
	
	prop.Class = item;
	
	self:OnRemoveItem( item, slot );
	self:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_GESTURE_ITEM_DROP );
	
	if ( BrainStock.Items[ item ].OnDropped ) then
		BrainStock.Items[ item ].OnDropped( self );
	end
end

function meta:OnRemoveItem( item, slot )
	
	/*for k, v in pairs( self.Inventory ) do
		if ( v == item ) then
			table.remove( self.Inventory, k );
			break;
		end
	end*/
	self.Inventory[ slot ] = nil;
	
	net.Start( "bs_Inventory" );
		//net.WriteBit( false );
		//net.WriteString( item );
		net.WriteTable( self.Inventory );
	net.Send( self );
end

function meta:OnItemUse( item, slot )
	if ( !self:HasItem( item ) || !BrainStock.Items[ item ] || !BrainStock.Items[ item ].CanUseItem( self ) || !self.Inventory[ slot ] ) then return; end

	if ( !BrainStock.Items[ item ].DontRemoveOnUse() ) then
		self:OnRemoveItem( item, slot );
	end
	
	if ( string.find( item, "weapon" ) ) then
		local class = string.gsub( item, "item_weapon_", "bs_weapon_" );
		if ( self:HasWeapon( class ) ) then
			local wep = self:GetWeapon( class );
			self:GiveAmmo( math.Round( 10, 30 ), wep.Primary.Ammo );
		else
			for k, v in pairs( self:GetWeapons() ) do
				if ( v.WeaponSlot == BrainStock.Items[ item ].Slot ) then
					class = string.gsub( item, "item_weapon_", "bs_weapon_" );
					
					self:GiveAmmo( v:Clip1(), v.Primary.Ammo );
					self:StripWeapon( v:GetClass() );
					//self:Give( class );
					
					class = string.gsub( v:GetClass(), "bs_weapon_", "item_weapon_" );
					local item_ = { Class = class };
					self:OnItemPickup( item_ );
				end
			end
		end
	end
	
	BrainStock.Items[ item ].OnUse( self );
	
	if ( string.find( item, "weapon" ) ) then
		self:SelectWeapon( string.gsub( item, "item_", "bs_" ) );
	end
	
	self:Save_Weapons();
end

function meta:OpenLootMenu( ent )
	if ( !ent.Inventory ) then return; end
	
	//for k, v in pairs( ent.Inventory ) do
		net.Start( "bs_LootBody" );
			net.WriteEntity( ent );
			net.WriteTable( ent.Inventory );
		net.Broadcast();
	//end
	
	umsg.Start( "Brainstock_Lootmenu", self );
	umsg.End();
end

function meta:UpdateLoot( ent, item )
	//if ( !ent.Inventory ) then return; end
	
	local class = item;
	
	net.Start( "bs_LootBody" );
		net.WriteEntity( ent );
		net.WriteTable( ent.Inventory );
	net.Broadcast();
	
	umsg.Start( "Brainstock_Lootmenu", self );
	umsg.End();
end
/*==========================================
	PLAYER SETUPS
==========================================*/
function meta:OnPlayerInitSetup()
	self.Inventory		  = {};
	for i = 1, BrainStock.Configuration.InventorySlots do
		self.Inventory [ i ] = nil;
	end
	self.Accessories	  = {};
	self.Perks			  = {};
	self.Achievements     = {};
	self.Leaderboards     = {};
	self.Titles			  = {};
	self.Hints			  = {};
	self.WeaponUpgrades   = {};
	
	self.nWalkSpeed	  	  = BrainStock.Configuration.WalkSpeed;
	self.nRunSpeed		  = BrainStock.Configuration.RunSpeed;
	self.nSprintDelay     = CurTime();
	self.nHungerDelay	  = CurTime();
	self.fRespawnDelay	  = CurTime();
	self.nNextSpawnTime	  = 0;
	//Network Variables
	self.bIronsights	  = false;
	self.bCanSpawn		  = false;
	self.bLoweredWeapon   = false;
	self.nHunger		  = 0;
	self.fStamina		  = 0.00;
	self.nGoodEvil		  = 0;
	
	self:SetGoodEvil( 0 );
	self:SetHealth( 100 );
	self:SetHunger( 100 );
	self:SetStamina( 0.00 );
	self:SetModel( "" );
	self:SetFrags( 0 );
	self:SetDeaths( 0 );
	self:GodEnable();
	
	self:Spectate( OBS_MODE_ROAMING );
	self:SetMoveType( MOVETYPE_OBSERVER );
	self:SetModel( "" );
	
	if ( !BrainStock.Missions.IsServer() ) then
		umsg.Start( "Brainstock_TitleScreen", self );
		umsg.End();
	end
	
	/*net.Start( "bs_WepUpgrade" );
		net.WriteTable( self.WeaponUpgrades );
	net.Broadcast();*/
end

function meta:OnPlayerSetup()
	if ( self:GetObserverMode() != OBS_MODE_NONE ) then return; end
	
	self:SetHealth( 100 );
	self:SetHunger( 100 );
	self:SetStamina( 0.00 );
	self:SetWalkSpeed( self.nWalkSpeed );
	self:SetRunSpeed( self.nRunSpeed );
	self:GodDisable();
	self:UnSpectate();
	self:SetMoveType( MOVETYPE_WALK );
	self:SetModel( "models/player/Group03/male_0" .. math.random( 1, 9 ) .. ".mdl" );
	
	if ( BrainStock.Configuration.InventoryLose ) then
		self.Inventory = nil;
		self.Inventory = {};
		
		umsg.Start( "Player_ClearInventory", self );
		umsg.End();
	end
	
	//self:PickSpawnpoint();
	self:RemoveNightvision();
	
	//self:Give( "bs_weapon_melee_crowbar" );
	//self:Give( "bs_weapon_glock17" );
	//self:GiveAmmo( 40, "9x19mm" );
			
	if ( BrainStock.Configuration.Debug ) then
		self:StripWeapons();
		self:Give( "bs_weapon_melee_crowbar" );
		self:Give( "bs_weapon_usp40" );
		self:Give( "bs_weapon_ak47" );
		self:GiveAmmo( 60, "9x19mm" );
		self:GiveAmmo( 120, "5.56x45mm" );
		self:SetArmor( 100 );
		self:AddPerk( "perk_regeneration" );
		self:AddPerk( "perk_slide" );
	else
		self:LoadMySQL();
	end
	
	self:Hint( "Hello, and welcome to Brainstock" );
end

function meta:PickSpawnpoint()
	if ( #ents.FindByClass( "ent_player_spawner" ) <= 0 ) then return; end
	
	for k, v in pairs( ents.FindByClass("ent_player_spawner") ) do
		if ( v:CanRespawn() ) then
			timer.Simple( 0.1, function() self:SetPos( v:GetPos() ); end );
			v:SpawnPlayer();
			return;
		end
	end
end

function meta:SetIronsights( bool )
	if ( bool == self:InIronsights() ) then return; end
	
	self.bIronsights = bool;
	net.Start( "bs_Ironsights" );
		net.WriteBit( bool );
	net.Send( self );
	if ( bool ) then
		self:SetWalkSpeed( BrainStock.Configuration.WalkSpeed - 40 );
		self:SetFOV( self:GetFOV() - 10, 0.32 );
	else
		self:SetWalkSpeed( BrainStock.Configuration.WalkSpeed );
		self:SetFOV( 0, 0.2 );
	end
	if ( self:KeyDown( IN_BACK ) ) then
		self:SetWalkSpeed( BrainStock.Configuration.WalkSpeed / 2.2 );
	end
end

function meta:SetHunger( int )
	if ( self.nHunger == int ) then return; end
	
	self.nHunger = int;
	self:SaveMySQL();
	
	if ( self.nHunger > 100 ) then
		self.nHunger = 100;
	end
	net.Start( "bs_Hunger" );
		net.WriteInt( self.nHunger, 8 );
	net.Send( self );
end

function meta:AddHunger( int )
	self:SetHunger( self:GetHunger() + int );
end

function meta:SetStamina( int )
	if ( self.fStamina == int ) then return; end
	
	self.fStamina = int;
	net.Start( "bs_Stamina" );
		net.WriteInt( int, 8 );
	net.Send( self );
end

function meta:AddStamina( int )
	self:SetStamina( self:GetStamina() + int );
	if ( self:GetStamina() >= BrainStock.Configuration.MaxStamina ) then 
		self:Hint( "Running will decrease accuracy" );
		self:SetStamina( BrainStock.Configuration.MaxStamina )
	end
end

function meta:SetGoodEvil( int )
	if ( self.nGoodEvil == int ) then return; end
	//self:SetNetworkedInt( "GOODEVIL", float );
	self.nGoodEvil = int;
	net.Start( "bs_GoodEvil" );
		net.WriteInt( int, 8 );
	net.Send( self );
end

function meta:AddGoodEvil( int )
	self:SetGoodEvil( self:GetGoodEvil() + int );
	if ( self:GetGoodEvil() > BrainStock.Configuration.MaxGoodEvil ) then
		self:SetGoodEvil( BrainStock.Configuration.MaxGoodEvil );
	elseif ( self:GetGoodEvil() < -BrainStock.Configuration.MaxGoodEvil ) then
		self:SetGoodEvil( -BrainStock.Configuration.MaxGoodEvil );
	end
end

function meta:AddPlayerToSquad( pl )
	if ( self == pl || self:InMySquad( pl ) || (BrainStock.Squads[ pl:InSquad() ] && #BrainStock.Squads[ pl:InSquad() ] >= 4) ) then return; end
	local i = pl:InSquad();
	if ( !self:InSquad() && i ) then
		if ( #BrainStock.Squads[i] <= 3 ) then
			table.insert( BrainStock.Squads[i], self );
			self:SetTeam( i )
		end
	elseif ( self:InSquad() && !i ) then
		i = self:InSquad()
		if ( #BrainStock.Squads[i] <= 3 ) then
			table.insert( BrainStock.Squads[i], pl );
			pl:SetTeam( i )
		end
	elseif ( !self:InSquad() && !i ) then
		i = table.Count( BrainStock.Squads ) + 1;
		
		BrainStock.Squads[i] = {};
		table.insert( BrainStock.Squads[i], self );
		table.insert( BrainStock.Squads[i], pl );
		pl:SetTeam( i );
	else
		return;
	end
	
	for k, v in pairs( BrainStock.Squads[i] ) do
		//if ( v != self ) then
			net.Start( "bs_Squad" );
				net.WriteTable( BrainStock.Squads[i] );
			net.Send( v );
		//end
	end
end

function meta:LeaveSquad()
	if ( !self:InSquad() ) then return; end
	local i = self:InSquad();
	for k, v in pairs( BrainStock.Squads[i] ) do
		if ( v == self ) then
			table.remove( BrainStock.Squads[i], k );
			net.Start( "bs_Squad" );
				net.WriteTable( {} );
			net.Send( self );
			break;
		end
	end
	
	for k, v in pairs( BrainStock.Squads[i] ) do
		if ( #BrainStock.Squads[i] <= 1 ) then
			net.Start( "bs_Squad" );
				net.WriteTable( {} );
			net.Send( v );
			BrainStock.Squads[i] = {};
			return;
		end
		net.Start( "bs_Squad" );
			net.WriteTable( BrainStock.Squads[i] );
		net.Send( v );
	end
	self:SetTeam( 0 );
end	

function meta:InSquad()
	for i = 1, #BrainStock.Squads do
		if ( BrainStock.Squads[i] && table.HasValue( BrainStock.Squads[i], self ) ) then
			return i;
		end
	end
	return false;
end

function meta:InMySquad( pl )
	for i = 1, #BrainStock.Squads do
		if ( BrainStock.Squads[i] && table.HasValue( BrainStock.Squads[i], self ) && table.HasValue( BrainStock.Squads[i], pl ) ) then
			return true;
		end
	end
	return false;
end

function meta:IsZombie()
	return false;
end

function meta:IsLooting()
	local tr = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 64, self );
	if ( IsValid( tr.Entity ) && tr.Entity.Inventory && !tr.Entity:IsPlayer() ) then
		return tr.Entity;
	end
	return nil;
end

function meta:FlashlightToggle()
	if ( self.FlashLight || !self:Alive() ) then
		self:RemoveFlashlight();
	elseif ( !self.FlashLight && self:HasItem( "item_flashlight" ) ) then
		local flashlight = ents.Create( "env_projectedtexture" );
		local vm = self:GetViewModel();
		
		if ( vm ) then
			local attach = self:GetAttachment( self:LookupAttachment( "eyes" ) );
		end
		
		flashlight:SetPos( self:GetShootPos() );
		flashlight:SetAngles( self:GetAngles() );
		flashlight:Spawn();
		flashlight:SetParent( self );
		
		local vm = self:GetViewModel();
		if ( vm ) then
			local attach = self:GetAttachment( self:LookupAttachment( "chest" ) );
			flashlight:SetAttachment( attach );
		end
		
		self.FlashLight = flashlight;
	end
end

function meta:RemoveFlashlight()
	if ( !self.FlashLight ) then return; end
	self.FlashLight:Remove();
	self.FlashLight = nil;
end

function meta:CreateRagdead()
	if ( self.RagdollEnt ) then 
		self.RagdollEnt:Remove();
		self.RagdollEnt = nil;
	end
	
	if ( self:GetModel() == "models/player.mdl" ) then return; end
	local rag = ents.Create( "prop_ragdoll" );
	
	rag:SetPos( self:GetPos() + Vector( 0, 0, 3 ) );
	rag:SetAngles( self:GetAngles() );
	rag:SetModel( self:GetModel() );
	rag:Spawn();
	rag:Activate();
	rag:SetOwner( self );
	rag:SetCollisionGroup( COLLISION_GROUP_WORLD );
	rag:SetDTString(0, self:GetName());
	
	rag.Inventory = self.Inventory;
	for k, v in pairs( self:GetWeapons() ) do
		local class = string.gsub( v:GetClass(), "bs_weapon_", "item_weapon_" );
		table.insert( rag.Inventory, class );
	end
	
	self.RagdollEnt = rag;
end
/*==========================================
	Chat
===========================================*/
function meta:PrintChat( msg )
	if ( BrainStock.Configuration.Debug ) then //Won't continue if 0, < 0, or false.
		print( "To " .. self:Nick() );
		print( "	[DEBUG]: " .. msg  );
	end
	self:PrintMessage( HUD_PRINTTALK, msg );
end

/*==================================
	Saving & Loading
===================================*/
function meta:SaveID()
	local id = self:SteamID();
	id = string.gsub( id, "STEAM_", "" );
	id = string.gsub( id, ":", "" );
	
	return id;
end

//PERKS
function meta:AddPerk( perk )
	if ( !BrainStock.Perks[ perk ] ) then return; end
	self.Perks[ BrainStock.Perks[ perk ].Slot ] = perk;
	net.Start( "bs_Perk" );
		net.WriteTable( self.Perks );
	net.Send( self );
	
	BrainStock.Perks[ perk ].OnEquip( self );
	self:Save_Perks();
	self:Save_Inventory();
	//self:PrintChat( "Perk " .. BrainStock.Perks[ perk ].PrintName .. " added" );
end

function meta:PerkThink()
	if ( #self.Perks <= 0 ) then return; end
	
	for k, v in pairs( self.Perks ) do
		if ( BrainStock.Perks[ v ] ) then
			BrainStock.Perks[ v ].OnThink( self );
		end
	end
end

function meta:PerkHurt( perk, attacker, hpremain, dmgtaken )
	if ( !BrainStock.Perks[ perk ] || #self.Perks <= 0 || !self:Alive() ) then return; end
	
	for k, v in pairs( self.Perks ) do
		BrainStock.Perks[ v ].OnHurt( self, attacker, hpremain, dmgtaken );
	end
end

function meta:RemovePerks()
	if ( #self.Perks <= 0 ) then return; end
	
	for k, v in pairs( self.Perks ) do
		BrainStock.Perks[ v ].OnRemove( self );
	end
	
	self.Perks = {};
	net.Start( "bs_Perk" );
		net.WriteTable( {} );
	net.Send( self );
	
	//self:Save_Perks();
end

//Titles
function meta:AddTitle( title )
	if ( table.HasValue( self.Titles, title ) ) then return; end
	
	table.insert( self.Titles, title );
	//self:PrintChat( title .. " title rewarded" );
	self:Hint( "Hey congratulations! You just won a title" );
	if ( !self.StrTitle || self.StrTitle == "" ) then
		self:SetTitle( title );
	end
	net.Start( "bs_Titles" );
		net.WriteTable( self.Titles );
	net.Send( self );
	
	self:Save_Titles();
end

function meta:SetTitle( title )
	if ( !table.HasValue( self.Titles, title ) ) then return; end
	self.StrTitle = title;
	net.Start( "bs_SetTitle" );
		net.WriteEntity( self );
		net.WriteString( title );
	net.Broadcast();
end

//Achievements
function meta:RewardAchievement( name )
	if ( !BrainStock.Achievements[ name ] || table.HasValue( self.Achievements, name ) ) then return; end
	
	timer.Simple( 7, function()
		if ( IsValid(self) ) then
			self:Hint( "Hey! You earned an Achievement. These grant various rewards" );
		end
	end);
	
	table.insert( self.Achievements, name );
	BrainStock.Achievements[ name ].OnReward( self );
	
	net.Start( "bs_AchieveUnlock" );
		net.WriteBit( true ); //Not loaded, earned
		net.WriteString( name );
	net.Send( self );
	
	self:Save_Achievements();
end

function meta:Slide()
	if ( !table.HasValue( self.Perks, "perk_slide" ) ) then return; end
	self:ConCommand( "-speed" );
	self:ConCommand( "-forward" );
		
	self.bSliding = true;
	self.fSlideTime = CurTime(); 
	self.nSlideTock = 1;
	self.slide_Forward = self:GetForward();
	self.slide_Angles = self:GetAngles();
	self.slide_Min, self.slide_Max = self:GetCollisionBounds();
	
	//local min, max = Vector( 0, 0, 0 ), Vector( 1, 1, 1 );
	
	self:TranslateModel( "humans" );
	//self:SetCollisionBounds( min, max );
	//self:PhysicsInitBox( min, max )
	//self:EmitSound( "brainstock/slide.mp3" );
	
	net.Start( "bs_Slide" );
		net.WriteBit( self.bSliding );
		net.WriteEntity( self );
	net.Broadcast();
end

function meta:DoSlide()
	if ( !self.bSliding || CurTime() < self.fSlideTime ) then return; end
	
	local force = 120 - (self.nSlideTock*4.5);
	force = math.Clamp( force, 0, 200 );
	
	if ( self.nSlideTock >= 25 || self:LookingAtWall() || !self:OnGround() ) then
		self.bSliding = false;
		self.nSlideTock = nil;
		self:SetVelocity( (self.slide_Forward * force) * -1 ); //Cat-jump fix
		//self:SetCollisionBounds( self.slide_Min, self.slide_Max );
		//self:PhysicsInitBox( self.slide_Min, self.slide_Max );
		//self:Lock();
		self.fSlideTime = CurTime() + 1;
		//self:ResetSequence( self:LookupSequence( "laycouch1_exit" ) );
		//self:TranslateModel( "player" );
		net.Start( "bs_Slide" );
			net.WriteBit( self.bSliding );
			net.WriteEntity( self );
		net.Broadcast();
		return;
	end
	
	//local physobj = self:GetPhysicsObject();
	
	self:ConCommand( "-jump" );
	self:DropToFloor();
	
	if ( !self:KeyDown( IN_JUMP ) ) then
		self:SetVelocity( (self.slide_Forward * force) );
	end
	
	self.nSlideTock = self.nSlideTock + 1;
	self.fSlideTime = CurTime() + 0.05;
end

function meta:TranslateModel( str )
	local mdl = self:GetModel();
	
	if ( str == "player" ) then
		mdl = string.gsub( mdl, "models/humans", "models/player" );
	elseif ( str == "humans" ) then
		mdl = string.gsub( mdl, "models/player", "models/humans" );
	end
	
	if ( self:GetModel() == mdl ) then return; end
	self:SetModel( mdl );
end

function meta:UpgradeWeapon( weapon, type )
	local tr = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 84, self );
	if ( !IsValid( tr.Entity ) || tr.Entity:GetClass() != "ent_workbench" || !self:HasItem( "item_part_upgrade" ) ) then return; end
	
	if ( !self.WeaponUpgrades[ weapon ] ) then self.WeaponUpgrades[ weapon ] = {}; end
	if ( !self.WeaponUpgrades[ weapon ][ type ] ) then self.WeaponUpgrades[ weapon ][ type ] = 0; end
	
	self.WeaponUpgrades[ weapon ][ type ] = self.WeaponUpgrades[ weapon ][ type ] + 1;
	if ( self.WeaponUpgrades[ weapon ][ type ] > BrainStock.Configuration.MaxWepUpgrade ) then
		self.WeaponUpgrades[ weapon ][ type ] = BrainStock.Configuration.MaxWepUpgrade;
	end
	
	net.Start( "bs_WepUpgrade" );
		net.WriteTable( self.WeaponUpgrades );
	net.Send( self );
	
	self:OnRemoveItem( "item_part_upgrade" );
end

function meta:UseNightvision()
	if ( !self:HasItem( "item_nvg" ) || !self:Alive() ) then
		self:RemoveNightvision();
		return;
	end
	
	local bool = self.NVGOn;
	if ( bool ) then
		self.NVGOn = false;
	else
		self.NVGOn = true;
	end
	
	net.Start( "bs_NVG" );
		net.WriteBit( self.NVGOn );
	net.Send( self );
end

function meta:RemoveNightvision()
	self.NVGOn = false;
	net.Start( "bs_NVG" );
		net.WriteBit( self.NVGOn );
	net.Send( self );
end


/////////////////////////////
//SAVING +LOADING////////////
/////////////////////////////

function meta:Save_Inventory()
	if ( self:Health() <= 0 || self:InventorySlots() <= 0  ) then
		BrainStock.db.query( "UPDATE playerdata SET Inventory = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Inventory = '";
	for k, v in pairs( self.Inventory ) do
		values = values .. k .. "=" .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_Achievements()
	if ( #self.Achievements <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Achievements = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Achievements = '";
	for k, v in pairs( self.Achievements ) do
		values = values .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_Perks()
	if ( table.Count(self.Perks) <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Perks = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Perks = '";
	for k, v in pairs( self.Perks ) do
		values = values .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_Position()
	local values = "UPDATE playerdata SET Position = '";
	if ( self:Health() <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Position = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local pos = tostring( self:GetPos() );
	pos = string.Explode( " ", pos );
	for k, v in pairs( pos ) do
		values = values .. v .. ",";
	end
	
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_Weapons()
	if ( #self:GetWeapons() <= 0 || self:Health() <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Weapons = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Weapons = '";
	for k, v in pairs( self:GetWeapons() ) do
		values = values .. v:GetClass() .. "=" .. (self:GetAmmoCount( v.Primary.Ammo )+v:Clip1()) .. "=" .. v.Primary.Ammo .. ",";
	end
	
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_Titles()
	if ( #self.Titles <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Titles = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Titles = '";
	for k, v in pairs( self.Titles ) do
		values = values .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_Hints()
	if ( #self.Hints <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Hints = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Hints = '";
	for k, v in pairs( self.Hints ) do
		values = values .. v .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:Save_WeaponUpgrades()
	if ( #self.WeaponUpgrades <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Upgrades = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Upgrades = '";
	for k, v in pairs( self.WeaponUpgrades ) do
		values = values .. v .. ",";
	end
	//values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	//BrainStock.db.query( values );
end

function meta:Save_Accessories()
	if ( !self.Accessories || table.Count(self.Accessories) <= 0 ) then
		BrainStock.db.query( "UPDATE playerdata SET Accessories = NULL WHERE User = " .. self:SaveID() );
		return;
	end
	
	local values = "UPDATE playerdata SET Accessories = '";
	for k, v in pairs( self.Accessories ) do
		values = values .. v.class .. ",";
	end
	values = string.sub( values, 1, -2 ) .. "' WHERE User = " .. self:SaveID();
	BrainStock.db.query( values );
end

function meta:SaveMySQL()
	local mdl = self:GetModel();
	local hunger = self:GetHunger();
	local hp = self:Health();
	local ar = self:Armor();
	
	if ( self:Health() <= 0 ) then
		mdl = "models/player/Group03/male_0" .. math.random( 1, 9 ) .. ".mdl";
		hunger = 100;
		hp = 100;
		ar = 0;
	end
	
	/*BrainStock.db.query( "INSERT INTO playerdata (User,Model,Inventory,Bank,Hunger,GoodEvil,Health,Armor,Perks,Achievements,Position,Weapons,Titles,Map,Hints,Upgrades) VALUES('" .. self:SaveID() .. "','" .. self:GetModel() .. "',NULL,NULL," .. self:GetHunger() .. ",NULL," .. self:Health() .. "," .. self:Armor() .. ",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)" );
	BrainStock.db.query( "UPDATE playerdata SET Model = '" .. mdl .. "' WHERE User = " .. self:SaveID() );
	BrainStock.db.query( "UPDATE playerdata SET Hunger = " .. hunger .. " WHERE User = " .. self:SaveID() );
	BrainStock.db.query( "UPDATE playerdata SET Health = " .. hp .. " WHERE User = " .. self:SaveID() );
	BrainStock.db.query( "UPDATE playerdata SET Armor = " .. ar .. " WHERE User = " .. self:SaveID() );
	BrainStock.db.query( "UPDATE playerdata SET Map = '" .. game.GetMap() .. "' WHERE User = " .. self:SaveID() );*/

	BrainStock.db.query( "INSERT INTO playerdata (User,Model,Inventory,Bank,Hunger,GoodEvil,Health,Armor,Perks,Achievements,Position,Weapons,Titles,Map,Hints,Upgrades) VALUES('" .. self:SaveID() .. "','" .. self:GetModel() .. "',NULL,NULL," .. self:GetHunger() .. ",NULL," .. self:Health() .. "," .. self:Armor() .. ",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) ON DUPLICATE KEY UPDATE Model = '" .. mdl .. "',Health = " .. hp .. ",Armor = " .. ar .. ",Hunger = " .. hunger .. ",Map = '" .. game.GetMap() .. "'" );
	
	/*self:Save_Inventory();
	self:Save_Achievements();
	self:Save_Perks();
	self:Save_Position();
	self:Save_Weapons();
	self:Save_Titles();
	self:Save_Hints();
	self:Save_Weaponupgrades();*/
	
	print( self:Name(), "saved" );
end

function meta:SaveAll()
	self:SaveMySQL();
	self:Save_Inventory();
	self:Save_Achievements();
	self:Save_Perks();
	self:Save_Weapons();
	self:Save_Titles();
	self:Save_Hints();
	self:Save_WeaponUpgrades();
	self:Save_Position();
	self:Save_Accessories();
end

function meta:Load_Weapons( str )
	str = string.Explode( "=", str );
	
	self:Give( str[1] );
	self:GiveAmmo( tonumber( str[2] ), str[3] );
end

function meta:Load_Inventory( str )
	str = string.Explode( "=", str );
	self.Inventory[ tonumber(str[1]) ] = tostring( str[2] );
end

function meta:LoadMySQL()
	local function query( data )
		if ( !data[1] ) then return; end
		local inv  = data[1].Inventory;
		local mdl = data[1].Model;
		local hunger = data[1].Hunger;
		local health = data[1].Health;
		local armor = data[1].Armor;
		local perks = data[1].Perks;
		local weapons = data[1].Weapons;
		local achievements = data[1].Achievements;
		local titles = data[1].Titles;
		local pos = data[1].Position;
		local map = data[1].Map;
		local hint = data[1].Hints;
		local accessories = data[1].Accessories;
		
		if ( weapons ) then
			weapons = string.Explode( ",", weapons );
			self:StripWeapons();
			for k, v in pairs( weapons ) do
				self:Load_Weapons( v );
			end
		else
			self:Give( "bs_weapon_melee_crowbar" );
			self:Give( "bs_weapon_glock17" );
			self:GiveAmmo( 40, "9x19mm" );
		end
		
		if ( inv ) then
			inv = string.Explode( ",", inv );
			for k, v in pairs( inv ) do
				self:Load_Inventory( v );
				//local i = { Class = v };
				//self:OnItemPickup( i );
			end
			net.Start( "bs_Inventory" );
				net.WriteTable( self.Inventory );
			net.Send( self );
		end
		
		
		if ( perks ) then
			perks = string.Explode( ",", perks );
			for k, v in pairs( perks ) do
				self:AddPerk( v );
			end
		end
		
		if ( accessories ) then
			accessories = string.Explode( ",", accessories );
			for k, v in pairs( accessories ) do
				self:AddAccessory( v );
			end
		end
		
		if ( achievements ) then
			achievements = string.Explode( ",", achievements );
			for k, v in pairs( achievements ) do
				if ( !table.HasValue( self.Achievements, name ) ) then
					table.insert( self.Achievements, v );
					net.Start( "bs_AchieveUnlock" );
						net.WriteBit( false );
						net.WriteString( v );
					net.Send( self );
				end
			end
		end
		
		if ( titles ) then
			titles = string.Explode( ",", titles );
			for k, v in pairs( titles ) do
				self:AddTitle( v );
			end
		end
		
		/*if ( hint ) then
			hint = string.Explode( ",", hint );
			for k, v in pairs( titles ) do
				self:AddTitle( v );
			end
		end*/
		
		//self:PickSpawnpoint();
		if ( pos && tostring(map) == tostring(game.GetMap()) ) then
			pos = string.Explode( ",", pos );
			for i = 1, #pos do
				pos[i] = tonumber( pos[i] );
			end
			timer.Simple( 0.1, function()
				self:SetPos( Vector( pos[1], pos[2], pos[3] ) )
			end );
		else
			self:PickSpawnpoint();
		end
		
		if ( health ) then
			self:SetHealth( health );
			if ( self:Health() <= 0 ) then
				self:SetHealth( 100 );
			end
		else
			self:SetHealth( 100 );
		end
		if ( armor ) then
			self:SetArmor( armor );
		end
		if ( hunger ) then
			self:SetHunger( hunger );
			if ( self:GetHunger() <= 0 ) then
				self:SetHunger( 100 );
			end
		else
			self:SetHunger( 100 );
		end
		if ( mdl ) then
			self:SetModel( mdl );
			if ( mdl == "models/player.mdl" ) then
				self:SetModel( "models/player/Group03/male_0" .. math.random( 1, 9 ) .. ".mdl" );
			end
		else
			self:SetModel( "models/player/Group03/male_0" .. math.random( 1, 9 ) .. ".mdl" );
		end
	end

	BrainStock.db.query( "SELECT * FROM playerdata WHERE User = " .. self:SaveID(), query );
end

function meta:AddAccessory( accessory )
	if ( !BrainStock.Accessories[ accessory ] ) then return; end
	
	accessory = BrainStock.Accessories[ accessory ];
	if ( self.Accessories[ accessory.Attachment ] && self.Accessories[ accessory.Attachment ].attachment ) then
		self.Accessories[ accessory.Attachment ].attachment:Remove();
		self.Accessories[ accessory.Attachment ] = nil;
	end
	
	local attachment = ents.Create( "ent_ply_attachment" );
	attachment:SetPos( self:GetPos() );
	attachment:SetAngles( self:GetAngles() );
	attachment:Spawn();
	attachment:SetModel( accessory.Model );
	attachment:SetOwner( self );
	attachment:SetModelScale( accessory.Scale, 0 );
	attachment:SetDTVector( 0, Vector( accessory.OffsetPos[1], accessory.OffsetPos[2], accessory.OffsetPos[3] ) );
	attachment:SetDTAngle( 0, Angle( accessory.OffsetAng[1], accessory.OffsetAng[2], accessory.OffsetAng[3] ) );
	attachment:SetDTString( 0, accessory.Attachment );
	
	self.Accessories[ accessory.Attachment ] = { attachment = attachment, class = accessory.Class };
	
	self:Save_Accessories();
	self:Save_Position();
end

function meta:RemoveAccessory( accessory )
	if ( !BrainStock.Accessories[ accessory ] ) then return; end
	
	accessory = BrainStock.Accessories[ accessory ];
	if ( self.Accessories[ accessory.Attachment ] && self.Accessories[ accessory.Attachment ].attachment ) then
		self.Accessories[ accessory.Attachment ].attachment:Remove();
		self.Accessories[ accessory.Attachment ] = nil;
	end
	
	local translate = string.gsub( accessory.Class, "object_", "item_accessory_" );
	translate = { Class = translate };
	
	if ( self:InventorySlots() >= BrainStock.Configuration.InventorySlots ) then
		pl:OnItemPickup( translate );
	else
		return;
	end
end

function meta:GetAccessory( accessory )
	accessory = BrainStock.Accessories[ accessory ];
	if ( accessory || !self.Accessories[ accessory.Attachment ] ) then return false; end
	return true;
end