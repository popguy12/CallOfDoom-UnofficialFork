class CODPlayerBase : DoomPlayer
{
	override Void Tick()
	{
		Super.Tick();
		/*//Destroy the night vision shader if a new level is started or if player dies.
		If(!FindInventory("MO_NightVision"))
		{
			Shader.SetEnabled(Player,"NiteVis",false);
		}*/
	}

	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		PlayerInfo plyr = Self.Player;
		if(!plyr || plyr.mo != Self) return 0;
		/*if(plyr.mo.CountInv("MO_PowerInvul") == 1)
		{
			A_StartSound("powerup/invul_damage",3);
		}*/
		return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}

	int grenadecooktimer;

	Default
	{
		Player.StartItem "COD_Makarov", 1;
		Player.StartItem "Clip", 16;
	}
}