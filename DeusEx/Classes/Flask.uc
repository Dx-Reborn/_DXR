//=============================================================================
// Flask.
//=============================================================================
class Flask extends DeusExDecoration;

#EXEC OBJ LOAD FILE=DeusExStaticMeshes.usx

defaultproperties
{
     FragType=Class'DeusEx.GlassFragment'
     ItemName="Lab Flask"
     mesh=mesh'DeusExDeco.Flask'
     CollisionRadius=4.300000
     CollisionHeight=7.470000
     Mass=5.000000
     Buoyancy=3.000000
     Skins(0)=material'DeusExStaticMeshes.Glass.GlassSH1'
}
