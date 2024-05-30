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
			BONV ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		NightVisionOFF:
			TNT1 A 0;
			TNT1 A 0 A_TakeInventory("NVToggleToken", 1);
			TNT1 A 0 A_SetCrosshair(0);
			BONV ZYXWVUTSRQPONMLKJIHGFEDCBA 1;
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