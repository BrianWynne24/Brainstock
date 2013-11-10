net.Receive( "bs_Cells", function()
	local pl = net.ReadEntity();
	local tbl = net.ReadTable();
	//pl.Inventory = tbl;
	
	if ( !IsValid( pl ) || !pl:IsPlayer() || !pl.Inventory ) then return; end
	
	local temp = {};
	for k, v in pairs( tbl ) do
		if ( table.HasValue( pl.Inventory, v ) ) then
			temp[k] = v;
		end
	end
	
	pl.Inventory = temp;
end );