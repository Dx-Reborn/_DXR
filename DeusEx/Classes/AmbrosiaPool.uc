//=============================================================================
// AmbrosiaPool.
//=============================================================================
class AmbrosiaPool extends DeusExDecal;

var float spreadTime;
var float maxDrawScale;
var float mytime;

function PostBeginPlay()
{
   Super.PostBeginPlay();
//   SetTimer(0.1, true);
}

function Tick(float deltaTime)
{
	mytime += deltaTime;

	super.Tick(deltaTime);

	if (mytime <= spreadTime)
	{
//    DetachProjector(True);
		SetDrawScale(maxDrawScale * mytime / spreadTime);
		log(self@drawScale);
//    AttachProjector();
	}
}


defaultproperties
{
     spreadTime=5.000000
     maxDrawScale=1.500000
     /*Texture*/ProjTexture=Texture'DeusExItems.Skins.FlatFXTex48'
}
