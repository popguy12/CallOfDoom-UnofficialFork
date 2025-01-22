extend class CODWeapon
{
	action void COD_WeaponReady(int weapflags = 0)
	{
		A_WeaponReady(weapflags);
		return;
	}
	
	/*
	action void COD_LowAmmoSoundWarning(string type = "default", string ammoItem = "SuperMario64ForTheXboxOne")
	{
		Ammo count;
		if(ammoItem == "SuperMario64ForTheXboxOne")
			count = invoker.ammo2;
		else
			count = Ammo(FindInventory(ammoItem));
			
		if(!count)
		{
			console.printf("COD_LowAmmoSoundWarning: Invalid ammo class");
			return;
		}
		
		int lowammocount = ceil(count.maxamount * 0.25);
		int currentammocount = count.amount;

		sound sndName = "weapons/lowammo/"..type;
		
		if(currentammocount <= lowammocount)
		{
			double clickvolume = COD_Math.LinearMap(currentammocount, 1.0, lowammocount, 1.0, 0.5);
			A_StartSound(sndName, CHAN_AUTO, CHANF_OVERLAP, clickvolume, ATTN_STATIC, frandompick(0.98, 1.0));
			
			if(currentammocount == 1)
				A_StartSound("weapons/lowammo/sweetener", CHAN_AUTO, CHANF_OVERLAP, 1.0, ATTN_STATIC);
			
			//console.printf("%f %i %i", clickvolume, lowammocount, currentammocount);
			if(currentammocount == 0)
				console.printf("COD_LowAmmoSoundWarning: Ammo count is 0 instead of 1, was the function called after the ammo item was taken?");
		}
	}
	*/
	//- L, 0 C, + R
	// [gng] credits to jaih1r0 for the position calculation, modified by me to fix the pitch bug
	Action void COD_GunSmoke(double d1 = 0, double d2 = 0 , double d3 = 0, string SActor = "COD_GunFireSmoke")
	{
		double PVZ;
		CODPlayer plr = CODPlayer(invoker.owner);
		PlayerInfo Playa = Player;
		if(Playa)
		{
			PVZ = (Playa.ViewZ - FloorZ) - 6;
		}

		d2 += plr.Radius;
		d3 -= 6;
		vector3 direction = ((self.AngleToVector(angle,cos(pitch)), sin(-pitch)));
        
        //got this from KeksDose -> https://forum.zdoom.org/viewtopic.php?t=63552&p=1090328 its very useful for this, at least now that i dont understand quats xD
        vector3 fw = (cos(angle),sin(angle),0); //forward offset
        vector3 sd = (cos(angle - 90),sin(angle - 90),0); //side offset
        
        //get the pitch and adjust the forward offset if looking up/down, so the smoke doesnt appear in front of the player from thin air in those cases
        //cos(pitch) < 1.0, and get closer to 0 when looking up/down, ig sin(pitch) ** 2 could also work (yes,this time the calculator wasnt in radians :D)
        double pt = cos(pitch);
		double pt2 = sin(pitch);

        fw *= d2 * (((0.45 + (pt2 * 0.15)) * -pt2) + pt);
		d3 -= d2 * pt2;

		//console.printf("%f %f %f", fw.x, fw.y, fw.z);
		//console.printf("%f %f %f", sd.x, sd.y, sd.z);
        
        //get a vector3 with the total offsets
        vector3 offs = fw + (sd * -d1);
        //add the offsets to the current position
        vector3 spos = self.vec3offset(offs.x, offs.y, offs.z);
        
        //add the view value
        spos.z += (height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor) + d3;

		//Vector3 CPos = (d2, -d1, d3 - 6);
		
		COD_GunFireSmoke Smoke = COD_GunFireSmoke(Spawn(SActor, spos));
		
		If(Smoke)
		{
			Smoke.master = invoker.owner;
			//Smoke.Vel = COD_Math.AngleToVector3D(self.Angle, -self.Pitch);
			vector3 momentum = plr.vel;
			Smoke.A_ChangeVelocity(momentum.X, momentum.Y, 0, CVF_RELATIVE);
			Smoke.A_FaceMovementDirection();
			double m_flScale = frandom(0.10,0.12);
			Smoke.Scale = (m_flScale, m_flScale);
			Smoke.A_SetRoll(random(0, 359));
		}
	}
	
	// Custom raise weapon function, useful for resetting information
	action void COD_RaiseWeapon() {
		A_Raise(25);
	}
	
	action void COD_LowerWeapon() {
		A_Lower(25);
	}
	/*
	//Checks if the owner has a berserk
	bool OwnerHasBerserk()
	{
        return (owner.CountInv("COD_PowerStrength") >= 1);
	}
	
	//Adds weapon recoil, modifying it if the owner has a berserk powerup
	action void COD_WeaponRecoil(float pitchDelta, float angleDelta, float powerMod = 0.5)
	{
        if (invoker.OwnerHasBerserk())
            COD_WeaponRecoilBasic(pitchDelta * powerMod, angleDelta * powerMod);
        else
            COD_WeaponRecoilBasic(pitchDelta, angleDelta);
	}
	*/
	//Normally you want to use PB_WeaponRecoil instead, because it accounts for the berserk powerup
	action void COD_WeaponRecoilBasic(float pitchDelta, float angleDelta = 0)
	{
		double fac = 1.0;
		if (invoker.GunBraced)
		{
			fac *= 0.33;
		}
		
        A_SetPitch(self.pitch+(pitchDelta * fac));
        A_SetAngle(self.angle+(angleDelta * fac));
	}
	
	//This will allow for direct spawning of shell casings and empty magazines without using an intermediary actor.
	//I highly recommend making cvars for each of the perameters for location and velocity to edit and test live, and with those numbers transpose into the final code.
	//upon request I also have code for the tactical lean mod out there.
	Action State COD_SpawnCasing(String Missile,Double ShellX,Double ShellY,Double ShellZ,Double ShellV_X,Double ShellV_Y,Double ShellV_Z)
	{
		A_SpawnItemEX(Missile,cos(pitch)*ShellX,ShellY,((ShellZ)*players[consoleplayer].Crouchfactor)-(sin(pitch)*ShellX),ShellV_X,ShellV_Y,ShellV_Z,0,SXF_TRANSFERPITCH,0);
	Return Null;
	}
	
	//A way to perform pretty much take all of the "Insertbullets" states and turn it into a function
	//An example of this action: PB_AmmoIntoMag("RifleAmmo","PB_HighCalMag",30,1) 
	action void COD_AmmoIntoMag(String AmmoMag_Action,String AmmoPool_Action,int MagazineMaxFill_Action, int takeReserve)
		{
			for(int i = 0; i < MagazineMaxFill_Action; i++)
			{
				if((CountInv(AmmoMag_Action) == MagazineMaxFill_Action) || (!CountInv(AmmoPool_Action)))
					return;
				
				A_GiveInventory(AmmoMag_Action, 1);
				A_TakeInventory(AmmoPool_Action, takeReserve);
			}
		}
	
	//Copy of Cemtex's PB_AmmoIntoMag but for unloading
	//A way to perform pretty much take all of the "RemoveBullets" states and turn it into a function	
	//An example of this action: PB_UnloadMag("RifleAmmo","PB_HighCalMag",1) 
	action void COD_UnloadMag(String AmmoMag_Action,String AmmoPool_Action, int giveReserve)
	{
		int amnt = CountInv(AmmoMag_Action);
		
		for(int i = amnt; i > 0; i--)
		{
			A_TakeInventory(AmmoMag_Action, 1);
			A_GiveInventory(AmmoPool_Action, giveReserve);
		}
	}
		
	
	//[Pop] This is a hack, ideally we shouldnt have to do this and once weapons are fully ZScript each one
	//will have its own function for firing that gets called. Even after it may be good to keep this for 
	//weapon addons that stay in DECORATE. Thanks to ADMERAL for throwing this together.
	action void COD_FireBullets(string type,int amount,float angle,double offs,double height,float pitch)
	{
		for(int i=amount;i>0;i--)
		{
			A_FireProjectile(type,(frandom(angle,angle * -1)),0,offs,height,FPF_NOAUTOAIM,(frandom(pitch,pitch * -1)));
		}
	}
	
	//[Pop]This function is so we can replace all of the shitty A_Quake or QuakeEx
	//whatever the fucks in the mod, ESPECIALLY on the weapon front
	//no more of these SHAKEYOURASSMINOR and SHAKEYOURASSMAJOR actor spawning garbage
	//its pretty bare bones but maybe we can extend it in the future if we need it
	action void COD_QuakeCamera(int qDur, float camRoll)
	{
		A_QuakeEx(0, 0, 0, qDur, 0, 100, "", 0, 1, 0, 0, 0, 0, (camRoll / 2), 1, 0, 0, 0);
		//also, camroll / 2, 2 should be made a scaling CVar at some point, or attach it to some other cvar
		//DONT FORGET DIPSHIT
	}
	
	action void COD_HandleWeaponFeedback(int qDur, float camRoll, float pitchDelta, float angleDelta, double d1 = 0, double d2 = 0 , double d3 = 0)
	{
		COD_QuakeCamera(qDur, camRoll);
		COD_WeaponRecoilBasic(pitchDelta, angleDelta);
		COD_GunSmoke(d1, d2, d3);
	}
	
	action void COD_HandleCrosshair(int num)
	{
        CVar crosshair_settings = CVar.FindCVar('cod_weapon_crosshairs');
		
		if(crosshair_settings.GetBool()){
			A_SetCrosshair(num); // Set crosshair to specific weapon
		}
		else {
			A_SetCrosshair(0); // Set crosshair to universal user setting
		}
	}
	
	 //Credits: Matt
    action bool JustPressed(int which) // "which" being any BT_* value, mentioned above or not
    {
        return player.cmd.buttons & which && !(player.oldbuttons & which);
    }
    action bool JustReleased(int which)
    {
        return !(player.cmd.buttons & which) && player.oldbuttons & which;
    }

    //Based on IsPressingInput from Project Brutality
    action bool PressingWhichInput(int which)
    {
        return player.cmd.buttons & which;
    }
	
	action bool PressingFire(){return player.cmd.buttons & BT_ATTACK;}
    action bool PressingAltfire(){return player.cmd.buttons & BT_ALTATTACK;}
	
	//[Pop]weapons should ALWAYS bob, fucking fight me
	override void DoEffect()
	{
		super.DoEffect();
		let player = owner.player;
		if (player && player.readyweapon)
		{
			player.WeaponState |= WF_WEAPONBOBBING;
		}
	}
	
	override void Tick()
	{
		Super.Tick();
		
		let plr = CODPlayer(Owner);
		if (!plr)
		{
			GunBraced = false;
			return;
		}
		
		if (plr.Player.ReadyWeapon != self)
		{
			GunBraced = false;
			return;
		}
		/*
		if (CountInv("ResetZoom") >= 1) {
			A_TakeInventory("ResetZoom", 1);
			A_ZoomFactor(1.0, ZOOM_INSTANT);
		}*/
		
		FLineTraceData dt1, dt2, dt3, dt4, dt5, dt6;
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, offsetside: -plr.Radius / 2, data: dt1);
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95 * 0.75, data: dt2);
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, offsetside: plr.Radius / 2, data: dt3);
		
		plr.LineTrace(plr.Angle + 90, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, data: dt4);
		plr.LineTrace(plr.Angle + 180, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95 * 0.75, data: dt5);
		plr.LineTrace(plr.Angle - 90, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, data: dt6);
		
		bool geometryBrace = dt1.HitType == FLineTraceData.TRACE_HitWall || dt2.HitType == FLineTraceData.TRACE_HitWall || dt3.HitType == FLineTraceData.TRACE_HitWall || dt4.HitType == FLineTraceData.TRACE_HitWall || dt5.HitType == FLineTraceData.TRACE_HitWall || dt6.HitType == FLineTraceData.TRACE_HitWall;
		
		if (!bMELEEWEAPON && (plr.Player.crouchfactor == 0.5 || geometryBrace || plr.CountInv("IsProne")) && plr.Vel.Length() < 6)
		{
			BraceTicker++;
			if (BraceTicker == 10)
			{
				GunBraced = true;
				plr.A_SetPitch(plr.Pitch - 0.2);
				Owner.A_StartSound("Weapon/Bracing", 19, 0, 0.30);
			}
			if (BraceTicker == 11)
			{
				plr.A_SetPitch(plr.Pitch + 0.2);
			}
		}
		else
		{
			GunBraced = false;
		}

		if (!GunBraced && BraceTicker > 13)
		{
			BraceTicker = 0;
		}
	}
	
	// Properties
	Default
	{
		Weapon.BobRangeX 0.3;
		Weapon.BobRangeY 0.5;
		Weapon.BobSpeed 2.4;
		Weapon.BobStyle "InverseSmooth";
		Weapon.WeaponScaleX 1.2;
		
		CODWeapon.PlaySpeed 1;
		+DONTGIB;
		+WEAPON.NOAUTOFIRE;
	}
}