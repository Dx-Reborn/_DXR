//=============================================================================
// BloodPool.
//=============================================================================
class BloodPool extends DeusExDecal;

var float spreadTime;
var float maxDrawScale;
var float time;

function BeginPlay()
{
	// Gore check
	if (Level.Game.bLowGore)
	{
		Destroy();
		return;
	}
	Super.BeginPlay();
}

function Tick(float deltaTime)
{
	time += deltaTime;
	if (time <= spreadTime)
	{
		SetDrawScale(maxDrawScale * time / spreadTime);
    AttachProjector();
	}
}


defaultproperties
{
     spreadTime=5.000000
     maxDrawScale=1.500000
     /*Texture=*/ProjTexture=Texture'DeusExItems.Skins.FlatFXTex1'
}
