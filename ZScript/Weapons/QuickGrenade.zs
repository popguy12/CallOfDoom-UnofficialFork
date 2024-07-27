Class ThrowableGrenade : CustomInventory
{
	int CooldownTimerGrenade;
	
	override void DoEffect()
	{
		super.DoEffect();
		if (CooldownTimerGrenade < 38 && !CountInv("ThrowGrenade"))
		{
			CooldownTimerGrenade++;
		}
		if (CooldownTimerGrenade == 38)
		{
			CooldownTimerGrenade = 39;
		}
	}
	
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
	}
	
	States 
	{
		Use:
			TNT1 A 0 
			{
				if (invoker.CooldownTimerGrenade >= 39)
				{
					invoker.CooldownTimerGrenade = invoker.CooldownTimerGrenade - 39;
				}
			}
			TNT1 A 0 A_JumpIf(CountInv("GrenadeAmmo") < 1, "NoAmmo");
			TNT1 A 0 A_GiveInventory("ThrowGrenade", 1);
			TNT1 A 39;
			fail;
		NoAmmo:
			TNT1 A 0
			{
				A_Print("OUT OF GRENADES", 0.5);
				A_StartSound("throwable/empty", 0, CHANF_OVERLAP, 0.5);
			}
			TNT1 A 10;
			fail;
	}
}

Class ThrowableBang : CustomInventory
{
	int CooldownTimerGrenade;
	
	override void DoEffect()
	{
		super.DoEffect();
		if (CooldownTimerGrenade < 9 && !CountInv("ThrowBang"))
		{
			CooldownTimerGrenade++;
		}
		if (CooldownTimerGrenade == 9)
		{
			CooldownTimerGrenade = 10;
		}
	}
	
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
	}
	
	States 
	{
		Use:
			TNT1 A 0 
			{
				if (invoker.CooldownTimerGrenade >= 10)
				{
					invoker.CooldownTimerGrenade = invoker.CooldownTimerGrenade - 10;
				}
			}
			TNT1 A 0 A_JumpIf(CountInv("BangAmmo") < 1, "NoAmmo");
			TNT1 A 0 A_GiveInventory("ThrowBang", 1);
			TNT1 A 39;
			fail;
		NoAmmo:
			TNT1 A 0
			{
				A_Print("OUT OF 9BANGS", 0.5);
				A_StartSound("throwable/empty", 0, CHANF_OVERLAP, 0.5);
			}
			TNT1 A 10;
			fail;
	}
}

Class GrenadeAmmo : Ammo
{
	Default
	{
		Inventory.PickupMessage "+4 Grenades";
		Inventory.Amount 4;
		Inventory.MaxAmount 4;
		Ammo.BackpackAmount 2;
		Ammo.BackpackMaxAmount 8;
	}
	
	States
	{
		Spawn:
			AMMR S -1;
			Stop;
	}
}

Class BangAmmo : Ammo
{
	Default
	{
		Inventory.PickupMessage "+4 Flashbangs";
		Inventory.Amount 4;
		Inventory.MaxAmount 4;
		Ammo.BackpackAmount 2;
		Ammo.BackpackMaxAmount 8;
	}
	
	States
	{
		Spawn:
			AMMR K -1;
			Stop;
	}
}

Class ThrownGrenade : Actor
{
	Default
	{
		Radius 2;
		Height 4;
		Speed 30;
		Gravity 1.0;
		Scale 0.2;
		BounceType "Hexen";
		BounceCount 5;
		Projectile
		+BOUNCEONACTORS;
		+BOUNCEONWALLS;
		-NOGRAVITY;
		-EXTREMEDEATH;
		+EXPLODEONWATER;
		-FLOORCLIP;
		+DOOMBOUNCE;
		+ROLLSPRITE;
		+ROLLCENTER;
		BounceFactor 0.6;
		WallBounceFactor 0.8;
		SeeSound "grenade/tumble";
		BounceSound "grenade/tumble";
		WallBounceSound "grenade/tumble";
		DeathSound "none";
		Obituary "%o ate %k grenade.";
	}
	
	int Timer;
	
	override void PostBeginPlay()
	{
		Timer = 0;
		Super.PostBeginPlay();
	}
	
	override void Tick()
	{
		Timer++;
		Super.Tick();
	}
	
	States
	{
		Death:
		XDeath:
		Spawn:
			TNT1 A 0;
			FRGX ABCDEFGH 2
			{
				A_SetRoll(roll-10, SPF_INTERPOLATE);
				if(Timer >= 175)
				{
					setstatelabel("Explode");
				}
			}
			Loop;
		Explode:
			TNT1 A 0
			{
				A_Explode(300, 256, XF_HURTSOURCE, false);
				Spawn('COD_Explosion', pos);
				A_AlertMonsters(4096);
				A_StartSound("effect/explosion", 0, CHANF_OVERLAP);
				for(int i=4;i>0;i--)
				{
					Spawn("COD_ExplosionSmoke", Level.Vec3Offset(pos, (frandom(10,-10),frandom(10,-10),frandom(10,-10))));
				}
			}
			Stop;
	}
}

Class ThrownBang : ThrownGrenade
{
	States
	{
		Death:
		XDeath:
		Spawn:
			TNT1 A 0;
			GRNX ABCDEFGHIJKLMN 2
			{
				if(Timer >= 105)
				{
					setstatelabel("Explode");
				}
			}
			Loop;
		Explode:
			TNT1 A 0
			{
				A_RadiusGive("Stunner", 256, RGF_MONSTERS | RGF_PLAYERS);
				//A_Explode(1000, int(24 * 6), XF_HURTSOURCE, true);
				Spawn('COD_Explosion', pos);
				A_AlertMonsters(512);
				A_StartSound("effect/explosion", 0, CHANF_OVERLAP);
				for(int i=4;i>0;i--)
				{
					Spawn("COD_ExplosionSmoke", Level.Vec3Offset(pos, (frandom(10,-10),frandom(10,-10),frandom(10,-10))));
				}
			}
			Stop;
	}
}

Class Stunner : Powerup
{
	Default
	{
		Powerup.Duration 350;
	}
	
	int Ticker;
	double normspeed;
	
	Override Void InitEffect()
	{
		Owner.SetStateLabel("Pain");
		normspeed = Owner.Speed;
		Owner.Speed = 2;
		Ticker = 0;
		Super.InitEffect();
	}
	Override Void DoEffect()
	{
		If(Owner.Health>0)
		{
			Ticker++;
			if(Ticker >= random(4,12))
			{
				Owner.SetStateLabel("Pain");
				Ticker = 0;
			}
		}
		Super.DoEffect();
	}
	override void EndEffect()
	{
		Owner.Speed = normspeed;
		Owner.A_ClearTarget();
		Super.EndEffect();
	}
}

Class HolsterYourShitPrivate : CustomInventory
{
	int CooldownTimer;
	
	override void DoEffect()
	{
		super.DoEffect();
		if (CooldownTimer < 19)
		{
			CooldownTimer++;
		}
		if (CooldownTimer == 19)
		{
			CooldownTimer = 20;
		}
	}
	
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE;
	}
	
	States 
	{
		Use:
			TNT1 A 0 
			{
				if (invoker.CooldownTimer >= 20)
				{
					invoker.CooldownTimer = invoker.CooldownTimer - 20;
					invoker.Owner.A_SelectWeapon("COD_Holster");
				}
			}
			TNT1 A 20;
			fail;
	}
}