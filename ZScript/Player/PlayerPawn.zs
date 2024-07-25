class CODPlayer : DoomPlayer
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
		
		Player.StartItem "COD_Medkit", 1;
		Player.StartItem "COD_Medkit_Ammo", 50;
		Player.StartItem "COD_C4Thrower", 1;
		
		Player.StartItem "ThrowableGrenade", 1;
		Player.StartItem "GrenadeAmmo", 2;
		Player.StartItem "ThrowableBang", 1;
		Player.StartItem "BangAmmo", 2;
		
		Player.AttackZOffset 16;
		Player.ViewBobSpeed 15;
		Scale 0.55;
		Player.SoundClass "CODPlayer";
	}
	
	States
	{
		Spawn:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Spawn2");
			RANG A 10;
			Loop;
		Spawn2:
			TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 0, "Spawn");
			RANG E 10;
			Loop;
		See:
			RANG ABCD 3;
			Loop;
		Missile:
			RANG E 6;
			Goto Spawn;
		Melee:
			RANG F 4 BRIGHT;
			Goto Missile;
		Pain:
			RANG G 2 A_Pain;
			Goto Spawn;
		Death:
		XDeath:
			RANG H 2;
			RANG I 2 A_PlayerScream;
			RANG J 2 A_NoBlocking;
			RANG KL 2;
			RANG L -1;
			Stop;
		
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

class Z_NashMove : CustomInventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
	}

	// How much to reduce the slippery movement.
	// Lower number = less slippery.
	const DECEL_MULT = 0.8; //0.8

	//===========================================================================
	//
	//
	//
	//===========================================================================

	bool bIsOnFloor(void)
	{
		return (Owner.Pos.Z == Owner.FloorZ) || (Owner.bOnMObj);
	}

	bool bIsInPain(void)
	{
		State PainState = Owner.FindState('Pain');
		if (PainState != NULL && Owner.InStateSequence(Owner.CurState, PainState))
		{
			return true;
		}
		return false;
	}

	double GetVelocity (void)
	{
		return Owner.Vel.Length();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		if (Owner && Owner is "PlayerPawn")
		{
			if (bIsOnFloor())
			{
				// bump up the player's speed to compensate for the deceleration
				// TO DO: math here is shit and wrong, please fix
				double s = 0.7 + (1.1 - DECEL_MULT); //1.0
				Owner.A_SetSpeed(s * 2);

				// decelerate the player, if not in pain
				if (!bIsInPain())
				{
					Owner.vel.x *= DECEL_MULT;
					Owner.vel.y *= DECEL_MULT;
				}
				else
				{
					Owner.vel.x *= DECEL_MULT;
					Owner.vel.y *= DECEL_MULT;
				}
				// make the view bobbing match the player's movement
				PlayerPawn(Owner).ViewBob = DECEL_MULT / 2;
			}
		}

		Super.Tick();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================
	States
	{
	Use:
		TNT1 A 0;
		Fail;
	Pickup:
		TNT1 A 0
		{
			return true;
		}
		Stop;
	}
}