class MetalDent extends DeusExDecal;

var texture RandomTexArray[9];

event BeginPlay()
{
    ProjTexture=default.RandomTexArray[rand(9)];
}

defaultproperties
{
     RandomTexArray[0]=texture'DXR_Decals.Decals.MetalDent0'
     RandomTexArray[1]=texture'DXR_Decals.Decals.MetalDent1'
     RandomTexArray[2]=texture'DXR_Decals.Decals.MetalDent2'
     RandomTexArray[3]=texture'DXR_Decals.Decals.MetalDent3'
     RandomTexArray[4]=texture'DXR_Decals.Decals.MetalDent4'
     RandomTexArray[5]=texture'DXR_Decals.Decals.MetalDent5'
     RandomTexArray[6]=texture'DXR_Decals.Decals.MetalDent6'
     RandomTexArray[7]=texture'DXR_Decals.Decals.MetalDent7'
     RandomTexArray[8]=texture'DXR_Decals.Decals.MetalDent8'

     ProjTexture=texture'DXR_Decals.Decals.MetalDent0'
     DrawScale=0.1 // 0.2
}