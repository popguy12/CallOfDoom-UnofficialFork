Class PistolSpawner : RandomSpawner replaces Pistol
{
	Default
	{
		DropItem "COD_Makarov",255,1;
		DropItem "COD_USP45",255,1;
	}
}

Class ShotgunSpawner : RandomSpawner replaces Shotgun
{
	Default
	{
		DropItem "COD_M1897", 255, 1;
		DropItem "COD_MosinNagant", 255, 1;
	}
}

Class SuperShotgunSpawner : RandomSpawner replaces SuperShotgun
{
	Default
	{
		DropItem "COD_Model30", 255, 1;
	}
}

Class ChaingunSpawner : RandomSpawner replaces chaingun
{
	Default
	{
		DropItem "COD_M4A1GL", 255, 1;
		DropItem "COD_S1100CB", 255, 1;
		DropItem "COD_MG338", 255, 1;
	}
}

Class PlasmaSpawner : RandomSpawner replaces PlasmaRifle
{
	Default
	{
		DropItem "COD_SKS", 255, 1;
		DropItem "COD_Auto88", 255, 1;
	}
}