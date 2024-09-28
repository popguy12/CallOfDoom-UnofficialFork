Class COD_HUD : BaseStatusBar
{
	//only interpolating health and armor
	DynamicValueInterpolator mHealthBar;
	DynamicValueInterpolator mArmorBar;
	
	HUDFont hfntS;
	HUDFont hfnt;
	
	int HUDWepRenderMode;
	
	override void Tick()
	{
		Super.Tick();
		mHealthBar.Update(CPlayer.health);
		mArmorBar.Update(GetArmorAmount());
	}
	
    Override void Init()
    {
        SetSize(0, 320, 240);
		
		mHealthBar = DynamicValueInterpolator.Create(0, 0.25, 1, 10);
		mArmorBar = DynamicValueInterpolator.Create(0, 0.25, 1, 10);
		
		hfntS = HUDFont.Create("INDEXFONT_COD");
		hfnt = HUDFont.Create("HUDFONT_COD");
		Super.Init();
	}
	
    Override void Draw (int state, double TicFrac)
    {
        Super.Draw (state, TicFrac);
		
        BeginStatusBar(true);
		
		HUDWepRenderMode = CVar.GetCVAR("COD_HUDWepRender", CPlayer).GetInt();
		
        DrawMainBar();
    }
	
	//[Pop] this is the actual function that draws all the hud stuff
    void DrawMainBar()
    {
		int health = mHealthBar.GetValue();
		int armor = mArmorBar.GetValue();
		
		/*Bar will be split into 2 parts
		first part drawn right here is all background elements, this way any
		HUD bars and stuff can be drawn over it, and then a foreground graphic
		drawn over that, which has detailing or whatever, like the health bar
		outlines. Also that means that a less detailed hud can be swapped to on
		the fly*/
		DrawImage("HUDPIC", (160,120), DI_SCREEN_CENTER | DI_ITEM_CENTER, 1);
		
		//Gonna do the keys and level stats right here
		DrawKeys("Card", (356, 26), 5, -8);
        DrawKeys("Skull", (351, 27), 5, -8);
		
		if(GetAmountOnly("Backpack") > 0)
		{
			DrawImage("Graphics/HUDStuff/HUDGraphics/BackpackIcon.png", (-45,195.5), DI_ITEM_OFFSETS, 1, (-1,-1), (0.25,0.25));
		}
		
		if(GetAmountOnly("IsCrouch") > 0)
		{
			DrawImage("Graphics/HUDStuff/HUDGraphics/CrouchIcon.png", (-16,182), DI_ITEM_OFFSETS, 1, (-1,-1), (0.25,0.25));
		}
		else if(GetAmountOnly("IsProne") > 0)
		{
			DrawImage("Graphics/HUDStuff/HUDGraphics/ProneIcon.png", (-16,182), DI_ITEM_OFFSETS, 1, (-1,-1), (0.25,0.25));
		}
		
		//Health and Armor
		DrawBar("HPBAR2", "HPBAR1", health, 100, (-35.8, 222), 0, 0, DI_ITEM_OFFSETS);
		DrawBar("HPBAR3", "HPBAR1", health - 100, 100, (-35.8, 222), 0, 0, DI_ITEM_OFFSETS);
		
		DrawBar("ARMBAR2", "ARMBAR1", armor, 200, (-35, 215), 0, 0, DI_ITEM_OFFSETS);
		
		DrawImage("Graphics/HUDStuff/HUDGraphics/HealthIcon.png", (-42,221.2), DI_ITEM_OFFSETS, 1, (-1,-1), (0.15,0.15), translation: CPlayer.mo.translation);
		/* [Pop] will recode later with proper armor colors once its implemented.
		if(armortype)
		{
			if(armortype = "BlueArmor")
			{
				DrawImage("Graphics/HUDStuff/HUDGraphics/ArmorIcon.png", (-42,216.2), DI_ITEM_OFFSETS, 1, (-1,-1), (0.15,0.15), translation: PlayGreenToBlueArm);
			}
			if(armortype = "GreenArmor")
			{
				DrawImage("Graphics/HUDStuff/HUDGraphics/ArmorIcon.png", (-42,216.2), DI_ITEM_OFFSETS, 1, (-1,-1), (0.15,0.15), translation: PlayGreenToGreenArm);
			}
		}*/
		
		if (CPlayer.ReadyWeapon != NULL)
		{
			let CODWEP = CODWeapon(CPlayer.ReadyWeapon);
			if(CODWEP)
			{
				let ammo3 = CODWEP.AmmoType3;
				TextureID icon = GetInventoryIcon(CPlayer.ReadyWeapon, DI_FORCESCALE);
				
				DrawImage(CODWEP.HUDInfoGraphic, (275,230), DI_ITEM_OFFSETS, 1, (-1,-1), (0.30,0.30));
				
				if(HUDWepRenderMode && HUDWepRenderMode == 1) //[Pop] Standard behavior, horizontally
				{
					DrawTexture(icon, (318,221), DI_ITEM_RIGHT | DI_ITEM_CENTER, 1, (-1,-1), (0.10, 0.10));
				}
				else if(HUDWepRenderMode && HUDWepRenderMode == 2) //[Pop] Vertical, also future proofing for other modes
				{
					DrawImageRotated(TexMan.GetName(icon), (348,183), DI_ITEM_OFFSETS, -90, 1, (2.2,2.2));
				}
				
				let ammo1 = CPlayer.Readyweapon.ammo1;
				let ammo2 = CPlayer.Readyweapon.ammo2;
				
				if(ammo1 && ammo2) //[Pop] If weapon has reloading or alternate ammo
				{
					int ammo1amount = ammo1.amount;
					int ammo2amount = ammo2.amount;
					
					DrawString(hfnt, FormatNumber(ammo1amount, 0, 3), (358, 217), DI_TEXT_ALIGN_RIGHT, Font.CR_WHITE, 1, -1, 4, (0.5, 0.5));
					DrawString(hfnt, FormatNumber(ammo2amount, 0, 3), (333, 217), DI_TEXT_ALIGN_RIGHT, Font.CR_WHITE, 1, -1, 4, (0.5, 0.5));
					
					if(ammo3)
					{
						int ammo3amount = GetAmountOnly(ammo3);
						DrawImage("Graphics/HUDStuff/HUDGraphics/AmmoSplit.png", (315, 217.5), DI_ITEM_OFFSETS, 1, (-1,-1), (1,1));
						DrawString(hfnt, FormatNumber(ammo3amount, 0, 3), (314, 217), DI_TEXT_ALIGN_RIGHT, Font.CR_WHITE, 1, -1, 4, (0.5, 0.5));
					}
			
				}
				
				else if(ammo1)
				{
					int ammo1amount = ammo1.amount;
					DrawString(hfnt, FormatNumber(ammo1amount, 0, 3), (358, 217), DI_TEXT_ALIGN_RIGHT, Font.CR_WHITE, 1, -1, 4, (0.5, 0.5));
				}
			}
			else
			{
				let ammo1 = CPlayer.Readyweapon.ammo1;
				if(ammo1)
				{
					int ammo1amount = ammo1.amount;
					DrawString(hfnt, FormatNumber(ammo1amount, 0, 3), (358, 217), DI_TEXT_ALIGN_RIGHT, Font.CR_WHITE, 1, -1, 4, (0.5, 0.5));
				}
			}
		}
		
		DrawBar("RADBAR2", "RADBAR1", GetAmountOnly("COD_RadAmount"), 300, (-32.5, 195), 0, SHADER_VERT | SHADER_REVERSE, DI_ITEM_OFFSETS, 0.5);
		
		DrawImage("Graphics/HUDStuff/HUDGraphics/RadSuit.png", (-24, 203), DI_ITEM_CENTER, 1, (-1,-1), (0.25, 0.25));
		
		//DrawString(hfnts, FormatNumber(GetAmountOnly("GrenadeAmmo"), 0, 3), (345, 202), DI_TEXT_ALIGN_RIGHT);
		//DrawString(hfnts, FormatNumber(GetAmountOnly("BangAmmo"), 0, 3), (322, 202), DI_TEXT_ALIGN_RIGHT);
		
		int BangCount = CPlayer.mo.CountInv("BangAmmo");
		for (BangCount > 0; BangCount--;)
		{
			DrawImage("Graphics/HUDStuff/HUDGraphics/Bang.png", ((364 - (14 * HUDWepRenderMode)) - (5 * BangCount), 195), DI_ITEM_OFFSETS, 1, (-1,-1), (0.2,0.2));
		}
		
		int GrenadeCount = CPlayer.mo.CountInv("GrenadeAmmo");
		for (GrenadeCount > 0; GrenadeCount--;)
		{
			DrawImage("Graphics/HUDStuff/HUDGraphics/Grenade.png", ((359 - (14 * HUDWepRenderMode)) - (5 * GrenadeCount), 200), DI_ITEM_OFFSETS, 1, (-1,-1), (0.2,0.2));
		}
		
		DrawTexture(GetMugShot(5), (-43, 12.25), DI_ITEM_OFFSETS, 1, (-1, -1), (0.5, 0.5));
		
		DrawImage("HUDPIC2", (160,120), DI_SCREEN_CENTER | DI_ITEM_CENTER, 1);
	}
	
	//[Pop] This is a nice function to quickly grab the exact amount of an item only
	//in the players inventory.
	int GetAmountOnly(class<Inventory> item)
	{
		let it = CPlayer.mo.FindInventory(item);
		return (it ? it.Amount : 0);
	}
	
	//[Pop] heres the function to handle the drawing of keys, it does look like a lot
	//but its mainly some sprite checking and stuff to make sure it works right.
	virtual void DrawKeys (string tag, vector2 pos, int keycount = 10, int space = 23)
    {
        //from NC HUD
        textureid icon, iconskull, iconcard;
        vector2 size;
        bool scaleup;
        int count = 0;
        
        for(let i = CPlayer.mo.Inv; i != null; i = i.Inv)
        {
            if(i is "Key")
            {
                // Draw up to defined keycount.
                if(count == keycount)
                {
                    break;
                }
                
                icon = i.AltHUDIcon;

                if (!icon.IsValid())
                {
                    if(i.SpawnState && i.SpawnState.sprite != 0)
                    {
                        icon = i.SpawnState.GetSpriteTexture(0);
                    }
                    else
                    {
                        icon = i.Icon;
                    }
                    
                    if(!icon.IsValid())
                    {
                        continue;
                    }
                }
                
                // Exclude keys which use 'TNT1A0' as their icon.
                if (TexMan.GetName(icon) ~== "TNT1A0")
                {
                    continue;
                }
                
                // Scale the icon up if needed.
                size = TexMan.GetScaledSize(icon);
                scaleup = (size.x <= 11 && size.y <= 11);
                
                string icontag = i.GetTag();
                
                if (icontag.RightIndexOf(tag) != -1)
                {
                    DrawTexture(icon, (pos.x, pos.y), DI_ITEM_OFFSETS, box : (11, 11), scaleup ? (1, 1) : (1, 1));
                    pos.x += space;
                }
                else
                {
                    continue;
                }
            }
        }
    }
}