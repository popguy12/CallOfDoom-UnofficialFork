class MO_PlayerBase : DoomPlayer
{
	override Void Tick()
	{
		Super.Tick();
		//Destroy the night vision shader if a new level is started or if player dies.
		If(!FindInventory("MO_NightVision"))
		{
			Shader.SetEnabled(Player,"NiteVis",false);
		}
	}

	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		PlayerInfo plyr = Self.Player;
		if(!plyr || plyr.mo != Self) return 0;
		if(plyr.mo.CountInv("MO_PowerInvul") == 1)
		{
			A_StartSound("powerup/invul_damage",3);
		}
		return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}

	int grenadecooktimer;

	Default
	{
		Player.WeaponSlot 1, "MO_Flamethrower", "Katana";
		Player.WeaponSlot 2, "EnforcerPistol", "MO_Submachinegun";
		Player.WeaponSlot 3, "LeverShotgun", "PumpShotgun", "JM_SSG";
		Player.WeaponSlot 4, "AssaultRifle", /*"MO_HeavyRifle", */ "MO_MiniGun";
		Player.WeaponSlot 5, "MO_RocketLauncher";
		Player.WeaponSlot 6, "JM_PlasmaRifle";
		Player.WeaponSlot 7, "MO_BFG9000", "MO_Unmaker";
	}
}