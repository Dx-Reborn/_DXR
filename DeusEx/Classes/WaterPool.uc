//=============================================================================
// WaterPool.
//=============================================================================
class WaterPool extends DeusExDecal;

var float spreadTime;
var float maxDrawScale;
var float time;

event PostBeginPlay(); // Don't execute this event from parent class.

event Tick(float deltaTime)
{
    time += deltaTime;

    if (time <= spreadTime)
    {
        DetachProjector(true);
        SetDrawScale(maxDrawScale * time / spreadTime);
        AttachProjector();
    }
}

defaultproperties
{
     spreadTime=5.000000
     maxDrawScale=1.500000
     ProjTexture=Texture'DeusExItems.Skins.FlatFXTex47'
}
