//=============================================================================
// EidosLogo.
//=============================================================================
class EidosLogo extends OutdoorThings;

#exec MESH IMPORT MESH=EidosLogo ANIVFILE=Models\EidosLogo_a.3d DATAFILE=Models\EidosLogo_d.3d ZEROTEX=1 MLOD=0
#exec MESHMAP SCALE MESHMAP=EidosLogo X=0.125 Y=0.125 Z=0.25
#exec MESH SEQUENCE MESH=EidosLogo SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=EidosLogo SEQ=Still  STARTFRAME=0  NUMFRAMES=1

defaultproperties
{
     Mesh=VertMesh'DeusEx.EidosLogo'
     skins(0)=Texture'DeusExDeco.Skins.EidosLogoTex1'
     CollisionRadius=85.720001
     CollisionHeight=15.940000
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     Mass=5000.000000
     Buoyancy=500.000000
}
