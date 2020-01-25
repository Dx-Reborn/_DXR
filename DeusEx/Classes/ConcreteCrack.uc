class ConcreteCrack extends DeusExDecal;

var texture RandomTexArray[7];

event BeginPlay()
{
    ProjTexture=default.RandomTexArray[rand(7)];
}

defaultproperties
{
     RandomTexArray[0]=texture'DXR_Decals.Decals.ConcreteHit0'
     RandomTexArray[1]=texture'DXR_Decals.Decals.ConcreteHit1'
     RandomTexArray[2]=texture'DXR_Decals.Decals.ConcreteHit2'
     RandomTexArray[3]=texture'DXR_Decals.Decals.ConcreteHit3'
     RandomTexArray[4]=texture'DXR_Decals.Decals.ConcreteHit4'
     RandomTexArray[5]=texture'DXR_Decals.Decals.ConcreteHit5'
     RandomTexArray[6]=texture'DXR_Decals.Decals.ConcreteHit6'

     ProjTexture=texture'DXR_Decals.Decals.ConcreteHit6'
     DrawScale=0.2
}