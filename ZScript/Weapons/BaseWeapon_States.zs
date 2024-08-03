class CODWeapon : Weapon
{ 
	States
	{
		//Select and Ready states will be shared across all weapons
		Deselect:
			TNT1 A 1 COD_LowerWeapon;
			Loop;
			
		Select:
			TNT1 A 1 COD_RaiseWeapon;
			Wait;
		Ready:
			TNT1 A 1;
			Goto WeaponReady;
		/*[Pop] Note on extra timings per weapon type
		Pistols have no delay
		SMG and Shotgun class weapons have 6 tic delay
		Rifle, DMR, and Sniper weapons have 12 tic delay
		Assault Rifle and Battle Rifle class weapons have 10 tic delay
		LMGs and above have 16 tic delay.
		*/
		
		//Dummy state for loading alternative sprites into virtual memory
		LoadAlternativeSprites:
			TNT1 A 1;
			Stop;
		WeaponReady:
			TNT1 A 1 COD_WeaponReady();
			Loop;
		Fire:
			TNT1 A 1;
			Goto WeaponReady;
			
		//Special Handling States
		User4: //Fake Deselect and GoTo NVToggle
			TNT1 A 0;
			Goto NVToggle;
		NVToggle:
			TNT1 A 0 A_JumpIfInventory("NVToggleToken", 1, "NightVisionOff");
		NightVisionON:
			TNT1 A 0;
			TNT1 A 0 A_GiveInventory("NVToggleToken", 1);
			TNT1 A 0 A_SetCrosshair(0);
			TNT1 A 0 A_StartSound("items/NV/PutOn", 0, CHANF_OVERLAP, 1);
			BONV ABCDEF 1;
			BONV GIK 4;
			BONV LNPR 1;
			TNT1 A 0 A_SetBlend("00 00 00", 0.0, 7, "00 00 00", 1.0);
			BONV TVX 2;
			TNT1 A 0 A_StartSound("items/NV/TurnOn", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_SetBlend("00 00 00", 1.0, 8, "39 74 18", 1.0);
			TNT1 A 7;
			TNT1 A 0
			{
				A_GiveInventory("CODGoggles");
				A_Overlay(100, "NVView", false);
				A_OverlayFlags(100, PSPF_ADDWEAPON, false);
				A_OverlayFlags(100, PSPF_ADDBOB, false);
			}
			TNT1 A 0 A_SetBlend("39 74 18", 1.0, 35, "39 74 18", 0.0);
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		NightVisionOFF:
			TNT1 A 0;
			TNT1 A 0 A_TakeInventory("NVToggleToken", 1);
			TNT1 A 0 A_SetCrosshair(0);
			TNT1 A 0 A_StartSound("items/NV/TurnOff", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_SetBlend("39 74 18", 0.0, 10, "00 00 00", 1.0);
			TNT1 A 0 A_StartSound("items/NV/TakeOff", 0, CHANF_OVERLAP, 1);
			TNT1 A 6;
			BONV ACE 1;
			TNT1 A 0
			{
				A_TakeInventory("CODGoggles");
				A_TakeInventory("CODNightVision");
				A_ClearOverlays(100,100);
			}
			TNT1 A 0 A_SetBlend("00 00 00", 1.0, 6, "00 00 00", 0.0);
			BONV XVT 2;
			BONV RPNL 1;
			BONV K 4;
			BONV IGFEDCBA 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		User2:
			TNT1 A 0;
			Goto RadToggle;
		RadToggle:
			TNT1 A 0 A_JumpIfInventory("RadToggleToken", 1, "RadOff");
		RadON:
			TNT1 A 0;
			TNT1 A 0 A_SetCrosshair(0);
			TNT1 A 1;
			TNT1 A 0 A_StartSound("items/GM/Equip", 0, CHANF_OVERLAP, 1);
			RADM ABCDEFGHIJKLMNO 2;
			RADN A 2;
			TNT1 A 0
			{
				if(CountInv("COD_RadAmount") >= 1)
				{
					A_GiveInventory("COD_PowerIronFeet", 2);
					A_SetBlend("00 99 00", 1, 3, "99 99 99", 0.0);
					A_StartSound("items/GM/Engage", 0, CHANF_OVERLAP, 1);
				}
				A_GiveInventory("RadToggleToken", 1);
				A_Overlay(101, "RadView", false);
				A_OverlayFlags(101, PSPF_ADDWEAPON, false);
				A_OverlayFlags(101, PSPF_ADDBOB, false);
			}
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		RadOFF:
			TNT1 A 0;
			TNT1 A 0 A_TakeInventory("RadToggleToken", 1);
			TNT1 A 0 A_SetCrosshair(0);
			TNT1 A 0
			{
				A_TakeInventory("RadBreakSound", 1);
				A_TakeInventory("COD_PowerIronFeet", 2);
				A_StartSound("items/GM/Break", 0, CHANF_OVERLAP, 1);
				A_ClearOverlays(101,101);
			}
			RADN A 2 A_StartSound("items/GM/Remove", 0, CHANF_OVERLAP, 1);
			RADO ABCDEFGHIJKL 2;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		User3:
		KnifeAttack:
			TNT1 A 0 A_StartSound("melee/knife/slash", 0, CHANF_OVERLAP, 1);
			KNI9 AB 1;
			KNI9 CDEF 1 A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			KNI9 GHI 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		FragGrenade:
			TNT1 A 0 A_ZoomFactor(1);
			TNT1 A 0 A_TakeInventory("AimingToken");
			FRGA ABCDEFGHI 1;
			FRGA JK 2;
			TNT1 A 0 A_StartSound("grenade/pinpull", 0, CHANF_OVERLAP, 1);
			FRGA LMN 2;
			FRGA O 4;
			TNT1 A 0 A_StartSound("grenade/throw", 0, CHANF_OVERLAP, 1);
			FRGA PQR 2;
			TNT1 A 0
			{
				A_FireCustomMissile("ThrownGrenade");
				A_TakeInventory("ThrowGrenade", 1);
				A_TakeInventory("GrenadeAmmo", 1);
			}
			FRGA STUV 1;
			FRGA WX 2;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		StunGrenade:
			TNT1 A 0 A_ZoomFactor(1);
			TNT1 A 0 A_TakeInventory("AimingToken");
			FRGA ABCDEFGHI 1;
			FRGA JK 2;
			TNT1 A 0 A_StartSound("flash/pinpull", 0, CHANF_OVERLAP, 1);
			FRGA LMN 2;
			FRGA O 4;
			TNT1 A 0 A_StartSound("flash/throw", 0, CHANF_OVERLAP, 1);
			FRGA PQR 2;
			TNT1 A 0
			{
				A_FireCustomMissile("ThrownBang");
				A_TakeInventory("ThrowBang", 1);
				A_TakeInventory("BangAmmo", 1);
			}
			FRGA STUV 1;
			FRGA WX 2;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
			
		MuzzleSmall:
			TNT1 A 0 A_Jump(256, "S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8");
		S1:
			MUZC AA 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S2:
			MUZC BB 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S3:
			MUZC CC 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S4:
			MUZC DD 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S5:
			MUZC EE 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S6:
			MUZC FF 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S7:
			MUZC GG 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		S8:
			MUZC HH 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
			
		MuzzleMedium:
			TNT1 A 0 A_Jump(256, "M1", "M2", "M3", "M4", "M5", "M6");
		M1:
			MUZA AA 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		M2:
			MUZA BB 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		M3:
			MUZA CC 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		M4:
			MUZA DD 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		M5:
			MUZA EE 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		M6:
			MUZA FF 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
			
		MuzzleBig:
			TNT1 A 0 A_Jump(256, "B1", "B2", "B3", "B4", "B5", "B6");
		B1:
			MUZB AA 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		B2:
			MUZB BB 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		B3:
			MUZB CC 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		B4:
			MUZB DD 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		B5:
			MUZB EE 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
		B6:
			MUZB FF 1 A_OverlayAlpha(-3, alpha-0.5);
			Stop;
			
	}
}

Class CODGoggles : PowerupGiver
{
   Default
   {
	  +COUNTITEM;
	  +INVENTORY.AUTOACTIVATE;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.MaxAmount 0;
	  Powerup.Type "CODNightVision";
	  Powerup.Duration 0x7FFFFFFD;
	  Inventory.PickupMessage "Tactical Night Vision Goggles";
	  inventory.pickupsound "misc/goggles";
	  Inventory.AltHudIcon "PVISA0";
  }
  States
  {
  Spawn:
    PVIS A 6 Bright;
    PVIS B 6;
    Loop;
  }
}

Class CODNightVision : PowerLightAmp
{
	transient CVar NVRes;
	
	override void DoEffect()
    {
		if(!owner) return;
        Super.DoEffect();
		
		if (!NVRes) NVRes = CVar.GetCVar("COD_NVRes",owner.player);
		int resmod = NVRes.GetInt();
		
		float sectorlightlevel = owner.player.mo.cursector.lightlevel / 16;
		
		Shader.SetEnabled(Owner.Player,"NiteVis",true);
		Shader.SetUniform1f(Owner.Player, "NiteVis", "timer", Level.time / 6.0);
		Shader.SetUniform1f(Owner.Player, "NiteVis", "exposure", 1 + sectorlightlevel / 8);
		Shader.SetUniform1f(Owner.Player, "NiteVis", "darken", 1);
		Shader.SetUniform3f(Owner.Player, "NiteVis", "hsl", (clamp(120 / 360.0, 0.0, 1.0), clamp(1.0, 0.0, 1.0), 0.5));
		
		Shader.SetEnabled(Owner.Player,"Pixelize_Scene",true);
		Shader.SetUniform1i(Owner.Player,"Pixelize_Scene","lowdetail",0);
		Shader.SetUniform1i(Owner.Player,"Pixelize_Scene","targetwt",680);
		Shader.SetUniform1i(Owner.Player,"Pixelize_Scene","targetht",400);
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Shader.SetEnabled(Owner.Player,"nitevis",false);
		Shader.SetEnabled(Owner.Player,"Pixelize_Scene",false);
	}
		
	Default
	{
		Inventory.AltHudIcon "PVISA0";
		+INVENTORY.NOSCREENBLINK;
	}
}

Class PlayerMuzzleFlash : Actor
{
	Default
	{
		Speed 0;
		PROJECTILE;
		+NOCLIP;
		+NOGRAVITY;
		+NOINTERACTION;
	}
	
	States
	{
		Spawn:
			TNT1 A 2 BRIGHT;
			Stop;
	}
}

class AimingToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class COD_RadAmount : Inventory replaces Radsuit
{
	Default
	{
		Height 10;
		Inventory.PickupMessage "Gasmask Filter";
		Inventory.PickupSound "misc/radsuit_PickUp";
		-BRIGHT;
		-COUNTITEM;
		Scale 0.025;
		Inventory.Amount 60;
		Inventory.MaxAmount 300;
	}
	
	States
	{
		Spawn:
			SUIT A -1;
			stop;
	}
}

class RadBreakSound : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class ChamberMeToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class NVToggleToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class RadToggleToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class ThrowGrenade : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class ThrowBang : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}