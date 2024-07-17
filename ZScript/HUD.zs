Class StatusBarMod : BaseStatusBar
{
	/*
	HUDFont hfntS;
	HUDFont hfnt;
	HUDFont hfntB;
	*/
    Override void Init()
    {
        SetSize(0, 960, 540);
		/*
		hfntS = HUDFont.Create("INDEXFONT");
		hfnt = HUDFont.Create(smallfont);
		hfntB = HUDFont.Create(BIGFONT);
		*/
		Super.Init();
	}
	
    Override void Draw (int state, double TicFrac)
    {
        Super.Draw (state, TicFrac);
        
        BeginStatusBar(true);
		
		//dummy cut screenshot from cod for reference
		DrawImage("HUDPIC", (480,270), DI_SCREEN_CENTER | DI_ITEM_CENTER, 1);
		
        DrawMainBar();
    }
	
	//[Pop] this is the actual function that draws all the hud stuff
    void DrawMainBar()
    {
		
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