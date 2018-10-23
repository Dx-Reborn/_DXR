//=============================================================================
// DeusExDecal
//=============================================================================
class DeusExDecal extends xScorch //Decal -- пути назад нет! 
												abstract;

#exec obj LOAD FILE=Effects_EX2.utx

var bool bAttached, bStartedLife, bImportant;

// properties
var int MultiDecalLevel;
var float LastRenderedTime;

event PreBeginPlay(){}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.0, false);
}

simulated function Timer()
{
	// Check for nearby players, if none then destroy self

	if ( !bAttached )
	{
		Destroy();
		return;
	}

	if ( !bStartedLife )
	{
		RemoteRole = ROLE_None;
		bStartedLife = true;
		if ( Level.bDropDetail )
			SetTimer(5.0 + 2 * FRand(), false);
		else
			SetTimer(18.0 + 5 * FRand(), false);
		return;
	}
	if ( Level.bDropDetail && (MultiDecalLevel < 6) )
	{
		if ( (Level.TimeSeconds - LastRenderedTime > 0.35)
			|| (!bImportant && (FRand() < 0.2)) )
			Destroy();
		else
		{
			SetTimer(1.0, true);
			return;
		}
	}
	else if ( Level.TimeSeconds - LastRenderedTime < 1 )
	{
		SetTimer(5.0, true);
		return;
	}
	Destroy();
}


defaultproperties
{
     bAttached=True
     bImportant=True
		 MultiDecalLevel=5
		 FadeInTime=0.05
		 drawScale=2.0 //0.3
}
