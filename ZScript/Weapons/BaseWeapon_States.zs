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
			BONV ABCDEFGI 1;
			BONV K 4;
			BONV LNPR 1;
			TNT1 A 0 A_SetBlend("00 00 00", 0.0, 7, "00 00 00", 1.0);
			BONV TVX 2;
			TNT1 A 0 A_SetBlend("00 00 00", 1.0, 8, "39 74 18", 1.0);
			TNT1 A 7;
			TNT1 A 0
			{
				A_GiveInventory("CODGoggles");
			}
			TNT1 A 0 A_SetBlend("39 74 18", 1.0, 35, "39 74 18", 0.0);
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		NightVisionOFF:
			TNT1 A 0;
			TNT1 A 0 A_TakeInventory("NVToggleToken", 1);
			TNT1 A 0 A_SetCrosshair(0);
			TNT1 A 0 A_SetBlend("39 74 18", 0.0, 10, "00 00 00", 1.0);
			TNT1 A 6;
			BONV ACE 1;
			TNT1 A 0
			{
				A_TakeInventory("CODGoggles");
				A_TakeInventory("CODNightVision");
			}
			TNT1 A 0 A_SetBlend("00 00 00", 1.0, 6, "00 00 00", 0.0);
			BONV XVT 2;
			BONV RPNL 1;
			BONV K 4;
			BONV IGFEDCBA 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		User3:
		KnifeAttack:
			KNI9 ABCLDEFGHIJ 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
			
		FragGrenade:
			FRGA ABCDEFGHI 1;
			FRGA JKLMOPQ 2;
			FRGA ST 2;
			TNT1 A 0; //A_FireCustomMissile("FragGrenade", 0, 0, 0, 16);
			FRGA U 2;
			FRGA VWX 2;
			Goto Ready;
		StunGrenade:
			FRGA ABCDEFGHI 1;
			FRGA JKLMOPQ 1;
			FRGA ST 1;
			FRGB C 0; //A_FireCustomMissile("StunGrenadeThrown", 0, 0, 0, 16);
			FRGA U 2;
			FRGA VWX 2;
			Goto Ready;
			
		MuzzleSmall:
			TNT1 A 0 A_Jump(256, "S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8");
		S1:
			MUZC A 2;
			Stop;
		S2:
			MUZC B 2;
			Stop;
		S3:
			MUZC C 2;
			Stop;
		S4:
			MUZC D 2;
			Stop;
		S5:
			MUZC E 2;
			Stop;
		S6:
			MUZC F 2;
			Stop;
		S7:
			MUZC G 2;
			Stop;
		S8:
			MUZC H 2;
			Stop;
		MuzzleBig:
			TNT1 A 0 A_Jump(256, "B1", "B2", "B3", "B4", "B5", "B6");
		B1:
			MUZB A 2;
			Stop;
		B2:
			MUZB A 2;
			Stop;
		B3:
			MUZB A 2;
			Stop;
		B4:
			MUZB A 2;
			Stop;
		B5:
			MUZB A 2;
			Stop;
		B6:
			MUZB A 2;
			Stop;
			
	}
}

Class CODGoggles : Infrared
{
   Default
   {
	  +COUNTITEM;
	  +INVENTORY.AUTOACTIVATE;
	  +INVENTORY.ALWAYSPICKUP;
	  Inventory.MaxAmount 0;
	  Powerup.Type "CODNightVision";
	  Powerup.Duration 35;
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
	override void DoEffect ()
    {
		if(!owner) return;
        Super.DoEffect();
		SetNVGStyle();
		SetNVGScanlines();
		Shader.SetEnabled(Owner.Player,"NiteVis",true);
		Shader.SetUniform1f(Owner.Player, "NiteVis","exposure",2);
		Shader.SetUniform1i(Owner.Player, "NiteVis","u_resfactor",resfactor);
		Shader.SetUniform1i(Owner.Player,"NiteVis","u_posterize",posterize);
		Shader.SetUniform3f(Owner.Player,"NiteVis","u_posfilter",posfilter);
		Shader.SetUniform1f(Owner.Player,"NiteVis","u_whiteclip",whiteclip);
		Shader.SetUniform1f(Owner.Player,"NiteVis","u_desat",desat);
	}
	
	override void EndEffect()
	{
		Super.EndEffect();
		if(!owner) return;
		Shader.SetEnabled(Owner.Player,"nitevis",false);
	}
		
	Default
	{
		Inventory.AltHudIcon "PVISA0";
		+INVENTORY.NOSCREENBLINK;
	}
}

//Modified from Hideous Destructor
extend class CODNightVision
{
	transient CVar NVGStyle;
	int style;
	bool hasScan;
	transient CVar NVGScanlines;
	int resfactor,scanfactor,hscan,vscan,posterize;
	double scanstrength,whiteclip,desat;
	vector3 posfilter,negfilter;

	void SetNVGStyle() {
		if (!NVGStyle) NVGStyle = CVar.GetCVar("COD_nvstyle",owner.player);
		int style = NVGStyle.GetInt();
		switch (style) {
			default:
			case 0: // Green Phosphor
				resfactor=1;hscan=1;vscan=0;scanfactor=8;scanstrength=0.1;posterize=24;posfilter=(0,1,0);whiteclip=0.25;desat=0.0;break;
			case 1: // White Phosphor
				resfactor=2;hscan=1;vscan=0;scanfactor=2;scanstrength=0.1;posterize=256;posfilter=(0.0,1.0,0.75);whiteclip=0.8;desat=0.0;break;
		}
	}
	void SetNVGScanlines() {
		if(!NVGScanlines) NVGScanlines = Cvar.GetCVar("COD_nvscanlines",owner.player);
		hasScan = NVGScanlines.GetBool();
		if(hasScan == true)
		{
			Shader.SetUniform1i(Owner.Player, "NiteVis","u_hscan",resfactor);
			Shader.SetUniform1f(Owner.Player, "NiteVis","u_scanstrength",scanstrength);
		}
		else
		{
			Shader.SetUniform1i(Owner.Player, "NiteVis","u_hscan",0);
			Shader.SetUniform1f(Owner.Player, "NiteVis","u_scanstrength",0);
		}
	}
}

class AimingToken : Inventory
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