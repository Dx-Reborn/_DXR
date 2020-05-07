//=============================================================================
// DeusExDecal
//=============================================================================
class DeusExDecal extends xScorch;

#EXEC OBJ LOAD FILE=DeusExItems.ukx

var bool bImportant;

defaultproperties
{
     FadeInTime=0.05
     drawScale=0.1
     bClipBSP=true
     bClipStaticMesh=true
     Lifespan=20.00
}
