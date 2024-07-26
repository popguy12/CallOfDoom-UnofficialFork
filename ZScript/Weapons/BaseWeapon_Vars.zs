extend class CODWeapon
{
	double exaggerationMultiplier;
	
	protected int BraceTicker;
	bool GunBraced;
	
	string GunStatGraphic;
	string PickupGraphic;
	string PickupGraphicFull;
	string HUDInfoGraphic;
	
	property InfoGraphics: HUDInfoGraphic, PickupGraphic, PickupGraphicFull, GunStatGraphic;
}