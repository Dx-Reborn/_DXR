class BrickHit extends DeusExDecal;

var texture RandomTexArray[2];

event BeginPlay()
{
    ProjTexture=default.RandomTexArray[rand(2)];
}

defaultproperties
{
     RandomTexArray[0]=texture'DXR_Decals.Decals.BrickHit0'
     RandomTexArray[1]=texture'DXR_Decals.Decals.BrickHit1'

     ProjTexture=texture'DXR_Decals.Decals.BrickHit0'
     DrawScale=0.2
}