ENT.Base 		= "npc_zombie_base";

ENT.HP     		 = 150;
ENT.Model		= "models/zombie/fast.mdl";
ENT.Speed       = 30;
ENT.Damage      = 2;
ENT.RunSpeed	= 260;
ENT.HitDist		= 76;

/*ENT.Sequences = {
	[ MODE_SLEEP ] = { "slump_a", "slump_b" },
	[ MODE_IDLE ] = { "slumprise_a", "slumprise_b", "idle" },
	[ MODE_ALERT ] = { "idle_angry" }
};*/
ENT.Sounds = {
	[ MODE_SLEEP ] = "npc/fast_zombie/fz_alert_close1.wav",
	[ MODE_IDLE ] = {},
	[ MODE_ALERT ] = { "npc/zombie_poison/pz_pain3.wav", "npc/zombie_poison/pz_pain2.wav", "npc/zombie_poison/pz_pain1.wav" };
	[ "FOOTSTEPS" ] = { "npc/fast_zombie/foot1.wav", "npc/fast_zombie/foot2.wav", "npc/fast_zombie/foot3.wav", "npc/fast_zombie/foot4.wav" }
};