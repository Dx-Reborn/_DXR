class WoodCrack extends DeusExDecal;

var texture RandomTexArray[9];

event BeginPlay()
{
    ProjTexture=default.RandomTexArray[rand(9)];
}

defaultproperties
{
     RandomTexArray[0]=texture'DXR_Decals.Decals.WoodCrack0'
     RandomTexArray[1]=texture'DXR_Decals.Decals.WoodCrack1'
     RandomTexArray[2]=texture'DXR_Decals.Decals.WoodCrack2'
     RandomTexArray[3]=texture'DXR_Decals.Decals.WoodCrack3'
     RandomTexArray[4]=texture'DXR_Decals.Decals.WoodCrack4'
     RandomTexArray[5]=texture'DXR_Decals.Decals.WoodCrack5'
     RandomTexArray[6]=texture'DXR_Decals.Decals.WoodCrack6'
     RandomTexArray[7]=texture'DXR_Decals.Decals.WoodCrack7'
     RandomTexArray[8]=texture'DXR_Decals.Decals.WoodCrack8'

     ProjTexture=texture'DXR_Decals.Decals.WoodCrack0'
     DrawScale=0.2
}