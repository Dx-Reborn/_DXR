//=============================================================================
// BloodSplat.
//=============================================================================
class BloodSplat extends DeusExDecal;

function BeginPlay()
{
	local float rnd;

	// Gore check
	if (Level.Game.bLowGore)
	{
		Destroy();
		return;
	}

	rnd = FRand();
	if (rnd < 0.25)
		ProjTexture = Texture'FlatFXTex3';
	else if (rnd < 0.5)
		ProjTexture = Texture'FlatFXTex5';
	else if (rnd < 0.75)
		ProjTexture = Texture'FlatFXTex6';

	SetDrawScale(DrawScale + FRand() * 0.2);

	Super.BeginPlay();
}

defaultproperties
{
     ProjTexture=Texture'DeusExItems.Skins.FlatFXTex2'
     DrawScale=0.200000
}
