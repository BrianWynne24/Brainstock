AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( 'shared.lua' );

function ENT:Initialize()
	self.bEnabled = true;
	self.nCount	  = 1;
	self.nNextThink = CurTime() + math.Rand( 0.01, 10 );
end

function ENT:PlayerAround()
	/*for k, v in pairs( ents.FindInSphere( self:GetPos(), 1024 ) ) do
		if ( v:IsPlayer() && v:Alive() ) then
			return true;
		end
	end
	return false;*/
	if ( #player.GetAll() < 1 ) then return; end
	
	for k, pl in pairs( player.GetAll() ) do
		/*local tr = {};
	
		tr.start = self:GetPos();
		tr.endpos = pl:GetPos();
		tr.filter = { self.Entity };
		tr = util.TraceLine( tr );
		
		if ( tr.Hit ) then
			return false;
		end*/
		if ( self:Visible( pl ) ) then
			return true;
		end
	end
	//return true;
	return false;
end

function ENT:Think()
	if ( !self.bEnabled || #ents.FindByClass( "ent_item" ) >= BrainStock.Configuration.ItemLimit || IsValid( self:GetOwner() ) || self:PlayerAround() || CurTime() < self.nNextThink ) then return; end
	
	local random = math.random( 1, #BrainStock.Items.Classes );
	local class = BrainStock.Items.Classes[ random ];
	
	self.nNextThink = CurTime() + 5;
	self:SpawnItem( BrainStock.Items[ class ] );
end

function ENT:SpawnItem( item )
	if ( !BrainStock.Items.Spawned[ item.Rarity ] ) then BrainStock.Items.Spawned[ item.Rarity ] = 0; end
	
	local rareness = BrainStock.Items.Spawned[ item.Rarity ];
	
	if ( rareness >= math.Round(item.Rarity*2.4) ) then
		self.nNextThink = CurTime() + 1;
		return;
	end
	
	local mdl = ents.Create( "ent_item" );
	
	mdl:SetPos( self:GetPos() );
	mdl:SetAngles( self:GetAngles() );
	mdl:Spawn();
	mdl:Activate();
	
	mdl:SetModel( item.Model );
	self:SetOwner( mdl );
	
	mdl:SetDTString( 0, item.PrintName );
	mdl:SetDTInt( 0, item.Rarity );
	
	mdl.OtherOwner = self;
	
	mdl.Class = item.Class;
	mdl.Amount = item.Amount;
	mdl.Rarity = item.Rarity;
	
	self.Rarity = item.Rarity;
	
	BrainStock.Items.Spawned[ item.Rarity ] = rareness + 1;
end

function ENT:SetMeFree( item )
	if ( !IsValid( item ) ) then return; end
	BrainStock.Items.Spawned[ item.Rarity ] = BrainStock.Items.Spawned[ item.Rarity ] - 1;
	self:SetOwner( nil );
end

/*function ENT:OnRemove()
	BrainStock.Items.Spawned[ self.Rarity ] = BrainStock.Items.Spawned[ self.Rarity ] - 1;
	self:SetOwner( nil );
end*/