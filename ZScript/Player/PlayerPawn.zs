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
		if(CountInv("RadToggleToken"))
		{
			A_Overlay(101, "RadView", true);
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
	
	bool alternateGMSound;
	
	Default
	{
		Player.StartItem "COD_Makarov", 1;
		Player.StartItem "Clip", 16;
		
		Player.StartItem "COD_Medkit", 1;
		Player.StartItem "COD_Medkit_Ammo", 50;
		Player.StartItem "COD_C4Thrower", 1;
		Player.StartItem "COD_Holster", 1;
		
		Player.StartItem "ThrowableGrenade", 1;
		Player.StartItem "GrenadeAmmo", 2;
		Player.StartItem "ThrowableBang", 1;
		Player.StartItem "BangAmmo", 2;
		
		Player.StartItem "HolsterYourShitPrivate", 1;
		
		Player.AttackZOffset 16;
		Player.ViewBobSpeed 15;
		Scale 0.55;
		Player.SoundClass "CODPlayer";
	}
	
	States
	{
		Spawn:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Spawn2");
			TNT1 A 0 A_Overlay(-50, "StunnerCheck", true);
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
			NVOV A 35 BRIGHT;
			Loop;
			
		RadView:
			TNT1 A 0
			{
				A_OverlayScale(101, 1.2, 1.0);
				A_OverlayOffset(101, -50, 32);
				A_OverlayFlags(101, PSPF_ADDWEAPON, false);
				A_OverlayFlags(101, PSPF_ADDBOB, false);
			}
			RADN A 35;
			TNT1 A 0
			{
				if(CountInv("COD_RadAmount") <= 0)
				{
					A_TakeInventory("COD_SuitGiver", 2);
					A_TakeInventory("COD_PowerIronFeet", 2);
					if(!CountInv("RadBreakSound"))
					{
						A_StartSound("items/GM/Break", 0, CHANF_OVERLAP, 1);
						A_GiveInventory("RadBreakSound");
					}
				}
				if(CountInv("COD_PowerIronFeet") <= 0 && CountInv("COD_RadAmount") > 1)
				{
					A_GiveInventory("COD_PowerIronFeet", 2);
					A_SetBlend("00 99 00", 1, 3, "99 99 99", 0.0);
					A_StartSound("items/GM/Engage", 0, CHANF_OVERLAP, 1);
				}
				if(alternateGMSound)
				{
					A_StartSound("CODPlayer/GMBreath", 0, CHANF_OVERLAP, 1);
					alternategmsound = false;
				}
				else
				{
					alternategmsound = true;
				}
				A_TakeInventory("COD_RadAmount", 1);
			}
			Loop;
		
		StunnerCheck:
			TNT1 A 0;
			TNT1 A 1 A_JumpIfInventory("Stunner", 1, "StunBangMeFuckAss");
			Loop;
		StunBangMeFuckAss:
			TNT1 A 0;
			TNT1 A 0 A_StartSound("CODPlayer/Flashbanged", 0, CHANF_OVERLAP);
			TNT1 A 3 A_SetBlend("99 99 99", 0.0, 3, "99 99 99", 1.0);
			TNT1 A 0 A_SetBlend("99 99 99", 1.0, 325, "99 99 99", 0.0);
			TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 5
			{
				A_SetPitch(pitch+frandom(-1,1), SPF_INTERPOLATE);
				A_SetAngle(angle+frandom(-1,1), SPF_INTERPOLATE);
			}
			TNT1 A 20;
			Goto StunnerCheck;
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
				
				s *= 2;
				
				//[Pop] TODO, implement dynamic adjustments to this based on held weapon.
				Owner.A_SetSpeed(s * 1);
				//[Pop] Handle movement boosts here. IE Stims, holsters gun, etc.
				if(Owner.CountInv("HolsterToken"))
				{
					Owner.A_SetSpeed(s * 1.5);
				}
				//[Pop] Handle movement reductions here. IE Stuns or heavy damage.
				if(Owner.CountInv("Stunner"))
				{
					Owner.A_SetSpeed(s * 0.4);
				}
				
				Owner.vel.x *= DECEL_MULT;
				Owner.vel.y *= DECEL_MULT;
				// make the view bobbing match the player's movement
				PlayerPawn(Owner).ViewBob = Owner.vel.length() / 16;//DECEL_MULT / 2;
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