//=============================================================================
// IonStormLogo.
//=============================================================================
class IonStormLogo extends OutdoorThings;

#exec MESH IMPORT MESH=IonStormLogo ANIVFILE=Models\IonStormLogo_a.3d DATAFILE=Models\IonStormLogo_d.3d MLOD=0
#exec MESHMAP SCALE MESHMAP=IonStormLogo X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=IonStormLogo SEQ=All STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=IonStormLogo SEQ=Still STARTFRAME=0  NUMFRAMES=1

defaultproperties
{
     Mesh=VertMesh'DeusEx.IonStormLogo'
     skins(0)=Texture'DeusExDeco.Skins.IonStormLogoTex1'
     skins(1)=Texture'DeusExDeco.Skins.IonStormLogoTex2'
     skins(2)=Texture'DeusExDeco.Skins.IonStormLogoTex3'
     skins(3)=Texture'DeusExDeco.Skins.IonStormLogoTex4'
     DrawScale=6.000000
     CollisionRadius=66.239998
     CollisionHeight=60.000000
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     Mass=5000.000000
     Buoyancy=500.000000
}
