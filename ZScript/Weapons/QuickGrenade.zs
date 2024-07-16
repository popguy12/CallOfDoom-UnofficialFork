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