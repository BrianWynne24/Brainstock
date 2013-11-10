local meta = FindMetaTable( "Entity" );
if ( !meta ) then return; end

function meta:IsMeleeWeapon()
	if ( string.find( self:GetClass(), "melee" ) ) then
		return true;
	end
	return false;
end

function meta:IsZombie()
	local zombies = { "npc_zombie_fast",
					  "npc_zombie_brute" };
	if ( table.HasValue( zombies, self:GetClass() ) ) then
		return true;
	end
end

if ( CLIENT ) then
	function meta:GetName()
		if ( self:GetClass() != "prop_ragdoll" ) then return ""; end
		return self:GetDTString(0);
	end
	
end