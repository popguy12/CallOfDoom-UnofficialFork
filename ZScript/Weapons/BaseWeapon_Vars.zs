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
}