extend class CODWeapon
{
	double exaggerationMultiplier;
	
	protected int BraceTicker;
	bool GunBraced;
	
	int GunSlotType; //1: Primary, 2: Secondary, 3: Tools and equipment (not counted towards inventory)
	property SlotType: GunSlotType;
	
	string GunStatGraphic;
	string PickupGraphic;
	string PickupGraphicFull;
	string HUDInfoGraphic;
	
	property InfoGraphics: HUDInfoGraphic, PickupGraphic, PickupGraphicFull, GunStatGraphic;
	
	double GunSpeedMod;
	property PlaySpeed: GunSpeedMod;
	
	/*
	holser 1.6
	normal 1
	pistol 0.95
	smg 0.85
	AR/shotgun 0.8
	DMR/BattleRifle/Sniper 0.75
	LMG 0.65
	big special shit 0.6
	*/
}