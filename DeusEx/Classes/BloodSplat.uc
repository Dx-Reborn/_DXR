//=============================================================================
// BloodSplat.
//=============================================================================
class BloodSplat extends DeusExDecal;

function BeginPlay()
{
//	local Rotator rot;
	local float rnd;

	// Gore check
	if (Level.Game.bLowGore) // || Level.Game.bVeryLowGore)
	{
		Destroy();
		return;
	}

/*	rnd = FRand();
	if (rnd < 0.25)
		ProjTexture = Texture'BloodSplat1';
	else if (rnd < 0.5)
		ProjTexture = Texture'BloodSplat2';
	else if (rnd < 0.75)
		ProjTexture = Texture'BloodSplat3';*/

	SetDrawScale(FRand() * 0.2); // +=

	Super.BeginPlay();
}

defaultproperties
{
     /*Texture=*///ProjTexture=Texture'XEffects.Shark.BloodSplat1'
//     DrawScale=0.200000
}
