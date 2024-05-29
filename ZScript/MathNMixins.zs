class COD_Math abstract
{
	ClearScope Static Vector3 VecFromAngles (double angle, double pitch, double mag = 1.)
	{
		double cosp = cos(pitch);
		return (cos(angle)*cosp, sin(angle)*cosp, -sin(pitch)) * mag;
	}
	
	//[inkoalawetrust] Written by Agent_Ash, makes the Val ranging from O_Min to O_Man be crushed down to the range of N_Min and N_Max.
	//Useful for example for compressing distances to a range of 0 to 1.0.
	ClearScope Static Double LinearMap (Double Val, Double O_Min, Double O_Max, Double N_Min, Double N_Max) 
	{
		Return (Val - O_Min) * (N_Max - N_Min) / (O_Max - O_Min) + N_Min;
	}
	
	//CREDIT: RicardoLuis0
	ClearScope Static Vector3 AngleToVector3D(Double Angle, Double Pitch, Double Len = 1.0)
	{
		Return (Cos(Angle)*Cos(Pitch)*Len,Sin(Angle)*Cos(Pitch)*Len,Sin(Pitch)*Len);
	}
	
	Enum Vec3RelFlags
	{
		V3R_NOANGLE = 1 << 1, //Do not rotate based on angle.
		V3R_NOPITCH = 1 << 2, //Do not rotate based on pitch.
		V3R_NOROLL	= 1 << 3, //Do not rotate based on roll.
		
		V3R_ANGLEONLY = V3R_NOPITCH|V3R_NOROLL
	}
	
	//Like Vec3Offset, but also rotates the output vector based on the callers' angle.
	//Other: The actor to offset from.
	//Offs: The vector3 offsets to use.
	//NoPortal: Should the function account for static portals or not ?
	//Flags: See above for list of flags.
	ClearScope Static Vector3 Vec3OffsetRelative (Actor Other, Vector3 Offs, Bool NoPortal = False, Int Flags = 0)
	{
		If (!Other) Return (Double.NaN,Double.NaN,Double.NaN);
		Double Angle, Pitch, Roll;
		If (!(Flags & V3R_NOANGLE)) Angle = Other.Angle;
		If (!(Flags & V3R_NOPITCH)) Pitch = Other.Pitch;
		If (!(Flags & V3R_NOROLL)) Roll = Other.Roll;
		
		Quat Dir = Quat.FromAngles (Angle,Pitch,Roll);
		Return Level.Vec3Offset (Other.Pos,Dir * Offs,NoPortal);
	}
}

//[inkoalawetrust] CheckActorExists(), IsDead(), and IsInState() are copied from my KAI library.
Mixin Class COD_CheckFunctions
{
	ClearScope Bool CheckActorExists (Name ActorClass)
	{
		Class<Actor> Act = ActorClass;
		Return !!Act;
	}
	
	ClearScope Bool IsDead (Actor Other)
	{
		If (!Other) Return False;
		Return (Other.Player ? Other.Player.PlayerState == PST_DEAD : Other.Health <= 0);
	}
	
	ClearScope Bool IsInState (Actor Other, StateLabel CheckFor = "Spawn", Bool Exact = False, Bool FromWeapon = False)
	{
		If (!Other) Return False;
		Return (Other.InStateSequence(Other.CurState,Other.FindState (CheckFor,Exact)));
	}
}

mixin class COD_BetterPickupSound
{
	override void PlayPickupSound(actor toucher)
	{
		double atten;
		int flags = CHANF_OVERLAP|CHANF_MAYBE_LOCAL;
		if(bNoAttenPickupSound) atten = ATTN_NONE;
		else atten = ATTN_NORM;
		if(toucher && toucher.CheckLocalView()) flags |= CHANF_NOPAUSE;
		toucher.A_StartSound(PickupSound,1002,flags,1.0,atten);
	}
}

mixin class COD_PowerupTimer
{
	int time;
	bool lf;

	void PowerupTimer(color col, color col2 = 0)
	{
		time = EffectTics;

		switch(time)
		{
			case 105:
			case 70:
			case 35:
				lf = CVar.GetCVar("pb_lowflashesmode", owner.player).GetBool();
				owner.A_SetBlend(col, lf ? 0.08 : 0.25, lf ? 20 : 12, col2);
				owner.A_StartSound("powerup/countdown", CHAN_AUTO, CHANF_OVERLAP | CHANF_UI);
			default:
				break;
		}
	}
	
	void EndBlend(color col, color col2 = 0)
	{ 
		owner.A_SetBlend(col, lf ? 0.1 : 0.50, 35, col2);
		owner.A_StartSound("powerup/ranout", CHAN_AUTO, CHANF_OVERLAP | CHANF_UI); 
	}
}