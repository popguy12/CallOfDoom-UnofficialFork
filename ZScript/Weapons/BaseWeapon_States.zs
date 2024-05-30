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
		NightVisionON:
			TNT1 A 0;
			TNT1 A 0 A_SetCrosshair(0);
			BONV ABCDEFGHIJKLMNOPQRSTUVWXYZ 1;
			Goto Ready;
		NightVisionOFF:
			TNT1 A 0;
			TNT1 A 0 A_SetCrosshair(0);
			BONV ZYXWVUTSRQPONMLKJIHGFEDCBA 1;
			Goto Ready;
			
		KnifeAttack:
			KNI9 ABCLDEFGHIJ 1;
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
	}
}

class AimingToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}