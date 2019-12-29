class EarthHit extends DeusExDecal;

var texture RandomTexArray[3];

event BeginPlay()
{
    ProjTexture=default.RandomTexArray[rand(3)];
}

defaultproperties
{
     RandomTexArray[0]=texture'DXR_Decals.Decals.EarthHit0'
     RandomTexArray[1]=texture'DXR_Decals.Decals.EarthHit1'
     RandomTexArray[2]=texture'DXR_Decals.Decals.EarthHit2'

     ProjTexture=texture'DXR_Decals.Decals.EarthHit0'
     DrawScale=0.2
}