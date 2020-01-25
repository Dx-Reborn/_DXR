class GlassCrack extends DeusExDecal;

#exec OBJ LOAD FILE=DXR_Decals.usx

event BeginPlay()
{
   if (fRand() < 0.25)
      ProjTexture = texture'DXR_Decals.Decals.GlassCrack1';
   else 
   if (fRand() < 0.5)
      ProjTexture = texture'DXR_Decals.Decals.GlassCrack2';
   else 
   if (fRand() < 0.75)
      ProjTexture = texture'DXR_Decals.Decals.GlassCrack3';
   else
      ProjTexture = texture'DXR_Decals.Decals.GlassCrack4';
}

defaultproperties
{
    ProjTexture=texture'DXR_Decals.Decals.GlassCrack1'
    DrawScale=0.1
}