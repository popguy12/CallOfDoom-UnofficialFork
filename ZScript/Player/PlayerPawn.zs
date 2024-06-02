class CODPlayerBase : DoomPlayer
{
	override Void Tick()
	{
		Super.Tick();
		//Destroy the night vision shader if a new level is started or if player dies.
		If(!FindInventory("CODNightVision"))
		{
			Shader.SetEnabled(Player,"NiteVis",false);
			Shader.SetEnabled(Player,"Pixelize_Scene",false);
		}
		if(CountInv("CODNightVision"))
		{
			A_Overlay(100, "NVView", false);
		}
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
		
		Player.AttackZOffset 16;
	}
	
	States
	{
		NVView:
			TNT1 A 0
			{
				A_OverlayScale(100, 1.2, 1.0);
				A_OverlayOffset(100, -36, 0);
				A_OverlayFlags(100, PSPF_ADDWEAPON, false);
				A_OverlayFlags(100, PSPF_ADDBOB, false);
			}
			NVOV A 35;
			Loop;
	}
}