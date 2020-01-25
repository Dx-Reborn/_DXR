//=============================================================================
// DXLogo.
//=============================================================================
class DXLogo extends OutdoorThings;

#exec MESH IMPORT MESH=DXLogo ANIVFILE=Models\DXLogo_a.3d DATAFILE=Models\DXLogo_d.3d ZEROTEX=1 MLOD=0
#exec MESHMAP SCALE MESHMAP=DXLogo X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=DXLogo SEQ=All   STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DXLogo SEQ=Still STARTFRAME=0  NUMFRAMES=1

//#exec TEXTURE IMPORT NAME=DXLogoTex1 FILE=Models\DXLogoTex1.pcx GROUP="Skins"
//#exec MESHMAP SETTEXTURE MESHMAP=DXLogo NUM=0 TEXTURE=DXLogoTex1


defaultproperties
{
     bStatic=False
     Physics=PHYS_Rotating
     skins(0)=TexEnvMap'DeusExDeco.Skins.DxLogo_TEM'
     Texture=Texture'DeusExDeco.Skins.DXLogoTex1'
     Mesh=VertMesh'DeusEx.DXLogo'
     DrawScale=2.250000
     CollisionRadius=123.639999
     CollisionHeight=125.699997
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bFixedRotationDir=True
     Mass=5000.000000
     Buoyancy=500.000000
     RotationRate=(Yaw=8192)
}
